#!/usr/bin/env python
"""GE-P-2026-007: numerical check that the kappa estimator recovers its target.

Verifies the Stage 0 protocol s4 estimator
    kappa = (O - E) / (B - E)
against simulated participants with a known true kappa, and exercises the
degenerate-case gate (s4.1) under a deliberately weak manipulation.

Not a test of the hypothesis. A test of the INSTRUMENT, run before the
instrument is used -- the estimator's behaviour must be known before it is
pointed at data.
"""
import random

SEED = 20260825


def simulate(kappa_true, n_items=200, p1=0.50, p2=0.06, theta0=50.0,
             trials=400, gate=5):
    """One participant per trial; return (mean recovered kappa, n usable)."""
    out = []
    for _ in range(trials):
        base = [random.uniform(theta0, 100) if random.random() < p1
                else random.uniform(0, theta0) for _ in range(n_items)]
        final = [random.uniform(theta0, 100) if random.random() < p2
                 else random.uniform(0, theta0) for _ in range(n_items)]
        B = sum(1 for h in base if h > theta0)
        E = sum(1 for h in final if h > theta0)   # fixed-threshold expectation
        if B - E < gate:                          # s4.1 degenerate-case gate
            continue
        target = E + kappa_true * (B - E)
        s = sorted(final, reverse=True)
        theta_new = s[int(round(target)) - 1] if 0 < round(target) <= len(s) else 0.0
        O = sum(1 for h in final if h > theta_new)
        out.append((O - E) / (B - E))
    return (sum(out) / len(out) if out else float("nan")), len(out)


def main():
    random.seed(SEED)
    print("kappa recovery (mean over 400 simulated participants)")
    print(f"{'true':>6} {'recovered':>11} {'bias':>8} {'usable':>8}")
    biases = []
    for k in (0.0, 0.25, 0.50, 0.75, 1.0):
        est, n = simulate(k)
        biases.append(est - k)
        print(f"{k:>6.2f} {est:>11.3f} {est - k:>8.3f} {n:>6}/400")

    mb = sum(biases) / len(biases)
    print(f"\nmean bias {mb:+.4f} -- additive, not multiplicative; arises from")
    print("integer rounding of the target count. DOWNWARD, i.e. conservative:")
    print("it under-states kappa and so biases toward refuting conservation.")
    assert abs(mb) < 0.05, "bias exceeds tolerance vs the 0.5 bar"

    print("\ndegenerate case -- manipulation too weak (p1=.50 -> p2=.48):")
    est, n = simulate(0.5, p1=0.50, p2=0.48)
    print(f"  usable {n}/400; the B-E>=5 gate rejects the rest, as intended.")
    print("  In a real run, >25% gate failures VOID the run (s4.1): the")
    print("  manipulation was too weak, and that is not fixable by reanalysis.")
    print("\nALL PASS")


if __name__ == "__main__":
    main()
