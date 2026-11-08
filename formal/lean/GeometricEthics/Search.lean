/-
Geometric Ethics v1.25: the search claims of Chapter 11.

The moral manifold with its Riemannian distance `d_g` is abstracted to a metric space: the proof
of Proposition 11.2 uses only that `d_g` is a metric (the triangle inequality) and that each edge
cost is at least the distance it spans. That a Riemannian distance is a metric is standard and is
not re-proved here.
-/
import Mathlib

namespace GeometricEthics.Search

variable {X : Type*} [MetricSpace X]

/-- **GE-PROP-11-2** (Consistency from Metric Compatibility). If `h(n) = d_g(n, G_eq)` (the
distance from `n` to the goal region) and every step cost dominates the distance it spans
(`c(n, n') ≥ d_g(n, n')`, "arc length ≥ geodesic distance"), then `h` is consistent:
`h(n) ≤ c(n, n') + h(n')`. -/
theorem geodesic_heuristic_consistent (G : Set X) (c : X → X → ℝ)
    (hc : ∀ x y, dist x y ≤ c x y) (x y : X) :
    Metric.infDist x G ≤ c x y + Metric.infDist y G := by
  have := Metric.infDist_le_infDist_add_dist (x := x) (y := y) (s := G)
  linarith [hc x y]

/-- The goal region has heuristic value zero. -/
theorem geodesic_heuristic_zero_on_goal (G : Set X) (x : X) (hx : x ∈ G) :
    Metric.infDist x G = 0 :=
  Metric.infDist_zero_of_mem hx

/-- The cost of a path, given as its list of successive states. -/
def pathCost {α : Type*} (c : α → α → ℝ) : α → List α → ℝ
  | _, [] => 0
  | x, y :: ys => c x y + pathCost c y ys

/-- The last state of a path that starts at `x`. -/
def pathEnd {α : Type*} : α → List α → α
  | x, [] => x
  | _, y :: ys => pathEnd y ys

/-- Supporting lemma for **GE-PROP-11-4** (A* optimality on stratified spaces): a consistent
heuristic that vanishes on the goal never overestimates the cost of any path to the goal
(consistency implies admissibility). Stratum-crossing penalties are part of the edge costs `c`,
as in the book's proof. This is the property the A* optimality theorem consumes; the A*
algorithm itself is not formalized here. -/
theorem consistent_implies_admissible {α : Type*} (c : α → α → ℝ) (h : α → ℝ) (goal : Set α)
    (hcons : ∀ x y, h x ≤ c x y + h y) (hgoal : ∀ x ∈ goal, h x ≤ 0)
    (x : α) (p : List α) (hp : pathEnd x p ∈ goal) : h x ≤ pathCost c x p := by
  induction p generalizing x with
  | nil => simpa [pathCost] using hgoal x hp
  | cons y ys ih =>
    have := ih y hp
    simp only [pathCost]
    linarith [hcons x y]

end GeometricEthics.Search
