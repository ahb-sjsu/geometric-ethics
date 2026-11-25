"""Deterministic checks of three book items raised in
notes/2026-11-25-hnsw-and-stratified-geometry.md, Section 8.

  A. Proposition 8.5(i): do minimum-weight paths on a fixed-connectivity grid
     converge to straight-line (geodesic) distance as the spacing goes to zero?
  B. MORAL-PATHFIND (Sections 11.1, 11.5): is "additive boundary penalties,
     total cost <= B" an ordinary shortest-path problem?
  C. Proposition 8.1, Step 2: does Whitney condition (A) hold for the Whitney
     umbrella when the z-axis is taken as a single stratum?

Run single-threaded. Writes results.json next to this file and prints a summary.
No randomness outside the seeded generator in B.
"""

from __future__ import annotations

import itertools
import json
import math
import sys
from pathlib import Path

import numpy as np
import scipy.sparse as sp
import sympy as sym
from scipy.sparse.csgraph import dijkstra


# --------------------------------------------------------------------- A
def grid_error(n: int, r: int) -> dict:
    """Unit square, (n+1)^2 nodes, spacing 1/n, Euclidean metric.

    Each node is joined to every node within Chebyshev distance r (r=1 is the
    8-neighbour grid, the 2-D case of the 3^d - 1 neighbours of Ch. 11).
    Edge weight = Euclidean length. Error = graph distance / Euclidean - 1 from
    the corner, over nodes at Euclidean distance in [0.5, 1.0].
    """
    m = n + 1
    idx = np.arange(m * m).reshape(m, m)
    rows, cols, w = [], [], []
    for dx, dy in itertools.product(range(-r, r + 1), repeat=2):
        if (dx, dy) <= (0, 0):  # each undirected edge once
            continue
        if math.gcd(abs(dx), abs(dy)) != 1:  # collinear duplicates add nothing
            continue
        x0, x1 = max(0, -dx), min(m, m - dx)
        y0, y1 = max(0, -dy), min(m, m - dy)
        a = idx[x0:x1, y0:y1].ravel()
        b = idx[x0 + dx : x1 + dx, y0 + dy : y1 + dy].ravel()
        rows.append(a)
        cols.append(b)
        w.append(np.full(a.size, math.hypot(dx, dy) / n))
    g = sp.coo_matrix(
        (np.concatenate(w), (np.concatenate(rows), np.concatenate(cols))), shape=(m * m, m * m)
    ).tocsr()
    d = dijkstra(g, directed=False, indices=0).reshape(m, m)
    xs, ys = np.meshgrid(np.arange(m) / n, np.arange(m) / n, indexing="ij")
    e = np.hypot(xs, ys)
    mask = (e >= 0.5) & (e <= 1.0)
    rel = d[mask] / e[mask] - 1.0
    return {"n": n, "r": r, "max_rel_err": float(rel.max()), "mean_rel_err": float(rel.mean())}


def check_a() -> dict:
    fixed = [grid_error(n, 1) for n in (50, 100, 200, 400)]
    growing = [grid_error(n, r) for n, r in ((50, 1), (100, 2), (200, 4), (400, 8))]
    theory_r1 = 1.0 / math.cos(math.pi / 8) - 1.0  # worst direction 22.5 degrees
    return {
        "fixed_connectivity_r1": fixed,
        "radius_growing_with_n": growing,
        "theory_max_rel_err_r1": theory_r1,
        "fixed_error_does_not_vanish": bool(fixed[-1]["max_rel_err"] > 0.9 * theory_r1),
        "growing_radius_error_shrinks": bool(
            all(a["max_rel_err"] > b["max_rel_err"] for a, b in zip(growing, growing[1:]))
        ),
    }


# --------------------------------------------------------------------- B
def all_simple_paths_min(n, edges, s, t, cost_fn, feasible_fn):
    """Brute-force minimum over simple s-t paths. edges: dict (u,v)->attrs."""
    adj = {u: [] for u in range(n)}
    for (u, v) in edges:
        adj[u].append(v)
    best = math.inf
    stack = [(s, (s,), ())]
    while stack:
        u, path, used = stack.pop()
        if u == t:
            if feasible_fn(used):
                best = min(best, cost_fn(used))
            continue
        for v in adj[u]:
            if v not in path:
                stack.append((v, path + (v,), used + ((u, v),)))
    return best


def check_b(trials: int = 300, n: int = 8, k: int = 2, seed: int = 0) -> dict:
    rng = np.random.default_rng(seed)
    agree, wcsp_differs, wcsp_infeasible = 0, 0, 0
    max_abs_diff = 0.0
    for _ in range(trials):
        edges = {}
        for u in range(n):
            for v in range(n):
                if u != v and rng.random() < 0.45:
                    edges[(u, v)] = {
                        "w": float(rng.uniform(0.1, 2.0)),
                        "cross": rng.random(k) < 0.3,
                    }
        beta = rng.uniform(0.5, 3.0, size=k)

        def pen_cost(used):
            return sum(edges[e]["w"] + float(beta @ edges[e]["cross"]) for e in used)

        # (1) the problem as the book states it: additive penalties, one budget
        brute = all_simple_paths_min(n, edges, 0, n - 1, pen_cost, lambda used: True)
        rows = [u for (u, v) in edges]
        cols = [v for (u, v) in edges]
        vals = [edges[e]["w"] + float(beta @ edges[e]["cross"]) for e in edges]
        g = sp.coo_matrix((vals, (rows, cols)), shape=(n, n)).tocsr()
        dj = float(dijkstra(g, directed=True, indices=0)[n - 1])
        if (math.isinf(brute) and math.isinf(dj)) or abs(brute - dj) < 1e-9:
            agree += 1
        else:
            max_abs_diff = max(max_abs_diff, abs(brute - dj))

        # (2) the genuinely constrained variant: minimise weight alone subject to
        #     a SEPARATE bound on the number of crossings (weight-constrained SP)
        def n_cross(used):
            return sum(int(edges[e]["cross"].sum()) for e in used)

        unconstrained = all_simple_paths_min(
            n, edges, 0, n - 1, lambda used: sum(edges[e]["w"] for e in used), lambda used: True
        )
        constrained = all_simple_paths_min(
            n,
            edges,
            0,
            n - 1,
            lambda used: sum(edges[e]["w"] for e in used),
            lambda used: n_cross(used) <= 0,
        )
        if math.isinf(constrained) and not math.isinf(unconstrained):
            wcsp_infeasible += 1
        elif not math.isinf(constrained) and constrained > unconstrained + 1e-9:
            wcsp_differs += 1
    return {
        "trials": trials,
        "nodes": n,
        "boundaries": k,
        "penalty_form_equals_dijkstra": agree,
        "penalty_form_max_abs_diff": max_abs_diff,
        "separate_budget_changes_optimum": wcsp_differs,
        "separate_budget_makes_infeasible": wcsp_infeasible,
        "penalty_form_is_plain_shortest_path": bool(agree == trials),
    }


# --------------------------------------------------------------------- C
def check_c() -> dict:
    """Whitney umbrella x^2 = z y^2. Strata tried: Y = z-axis, X = the rest.

    Condition (A) at the origin needs every limit of tangent planes T_p X, as
    p -> 0 in X, to contain T_0 Y = the z direction, i.e. the limiting unit
    normal must have zero z-component.
    """
    x, y, z, t = sym.symbols("x y z t", positive=True)
    F = x**2 - z * y**2
    grad = sym.Matrix([sym.diff(F, v) for v in (x, y, z)])

    def limit_normal(sub):
        gvec = grad.subs(sub)
        on_surface = sym.simplify(F.subs(sub))
        nrm = sym.sqrt(sum(c**2 for c in gvec))
        unit = [sym.limit(sym.simplify(c / nrm), t, 0, "+") for c in gvec]
        return on_surface, [sym.nsimplify(u) for u in unit]

    # points (x, y, z) = (s*yv, yv, s^2) lie on the surface for any s, yv
    p1 = {x: t * t**3, y: t**3, z: t**2}  # y much smaller than sqrt(z)
    p2 = {x: t**2 * t, y: t, z: t**4}  # y much larger than sqrt(z)
    on1, n1 = limit_normal(p1)
    on2, n2 = limit_normal(p2)
    return {
        "path1_on_surface": bool(on1 == 0),
        "path1_limit_unit_normal": [str(c) for c in n1],
        "path1_plane_contains_z_axis": bool(n1[2] == 0),
        "path2_on_surface": bool(on2 == 0),
        "path2_limit_unit_normal": [str(c) for c in n2],
        "path2_plane_contains_z_axis": bool(n2[2] == 0),
        "condition_A_fails_at_origin_with_z_axis_as_one_stratum": bool(n2[2] != 0),
    }


def main() -> int:
    out = {"A_grid_convergence": check_a(), "B_moral_pathfind": check_b(), "C_whitney_umbrella": check_c()}
    Path(__file__).with_name("results.json").write_text(json.dumps(out, indent=2))
    print(json.dumps(out, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
