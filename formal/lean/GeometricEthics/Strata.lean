/-
Geometric Ethics v1.25, §8.10b (source/updates/sec8_10b_executable_strata.tex): executable
stratification, Containment and Absorption.

Follows gtc-prototype `formal/twin-containment/TwinContainment.lean` (`SGate`, `sstep`, `srun`,
`authority_needs_system`, `absorbing_stays`), restated over the book's Definition 8.14 tuple
`(Σ, σ₀, G, A, B)`. The theorems are about any gates whatever.
-/
import Mathlib

namespace GeometricEthics.Strata

/-- Boundary types of a gate (§8.3, Types I and II). -/
inductive BoundaryType
  | threshold
  | phase
  deriving DecidableEq

/-- A semantic gate `g = (S_g, φ_g, τ_g, β_g)` over strata `σ` and events `ε`: source strata,
triggering feature (a predicate on events, so an event type optionally with its content), target,
and boundary type. -/
structure Gate (σ ε : Type*) where
  source : Set σ
  [decSource : DecidablePred (· ∈ source)]
  trigger : ε → Prop
  [decTrigger : DecidablePred trigger]
  target : σ
  btype : BoundaryType

attribute [instance] Gate.decSource Gate.decTrigger

/-- **GE-DEF-8-14** (Executable stratification): a tuple `(Σ, σ₀, G, A, B)` with `Σ` finite,
`σ₀ ∈ Σ` the initial stratum, `G` an ordered list of gates, `A ⊆ Σ` the authority strata and
`B ⊆ Σ` the absorbing strata. -/
structure ExecStrat (σ ε : Type*) [Fintype σ] where
  init : σ
  gates : List (Gate σ ε)
  authority : Set σ
  absorbing : Set σ

/-- Boundary crossing data (Definition 8.11): the gate, its boundary type, source and target. -/
structure Crossing (σ ε : Type*) where
  gate : Gate σ ε
  btype : BoundaryType
  src : σ
  dst : σ

variable {σ ε : Type*} [Fintype σ]

/-- The first gate that fires from stratum `s` on event `e`. -/
def ExecStrat.firing (X : ExecStrat σ ε) (s : σ) (e : ε) : Option (Gate σ ε) :=
  X.gates.find? fun g => decide (s ∈ g.source) && decide (g.trigger e)

/-- **GE-DEF-8-14**, the step rule: on event `e` in stratum `s`, move to `τ_g` for the first gate
with `s ∈ S_g` whose trigger matches `e`, and otherwise stay at `s`; a move is recorded as
boundary crossing data. The step reads only the current stratum and the event just observed
(gates are edge-triggered, never history-triggered). -/
def ExecStrat.step (X : ExecStrat σ ε) (s : σ) (e : ε) : σ × Option (Crossing σ ε) :=
  match X.firing s e with
  | some g => (g.target, some ⟨g, g.btype, s, g.target⟩)
  | none => (s, none)

/-- Run from stratum `s` on an event sequence: the final stratum. -/
def ExecStrat.run (X : ExecStrat σ ε) (s : σ) (es : List ε) : σ :=
  es.foldl (fun t e => (X.step t e).1) s

/-- The boundary crossings recorded along a run. -/
def ExecStrat.crossings (X : ExecStrat σ ε) : σ → List ε → List (Crossing σ ε)
  | _, [] => []
  | s, e :: es => ((X.step s e).2.toList) ++ X.crossings (X.step s e).1 es

/-- **GE-DEF-8-14**, sanity: a firing gate is a member of `G` whose source admits the stratum and
whose trigger matches the event; a recorded crossing carries that gate's boundary type, the
stratum it came from, and the gate's target. -/
theorem step_spec (X : ExecStrat σ ε) (s : σ) (e : ε) :
    (∃ g ∈ X.gates, s ∈ g.source ∧ g.trigger e ∧ X.step s e =
        (g.target, some ⟨g, g.btype, s, g.target⟩)) ∨
    ((∀ g ∈ X.gates, ¬ (s ∈ g.source ∧ g.trigger e)) ∧ X.step s e = (s, none)) := by
  unfold ExecStrat.step ExecStrat.firing
  split
  · rename_i g hg
    have hp := List.find?_some hg
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hp
    exact Or.inl ⟨g, List.mem_of_find?_eq_some hg, hp.1, hp.2, rfl⟩
  · rename_i hg
    refine Or.inr ⟨fun g hmem hc => ?_, rfl⟩
    have := List.find?_eq_none.mp hg g hmem
    simp [hc.1, hc.2] at this

/-- **GE-DEF-8-14**, sanity: the recorded crossings account for the run. With no crossing the run
ends where it began; otherwise it ends at the target of the last crossing. -/
theorem run_eq_last_crossing (X : ExecStrat σ ε) (s : σ) (es : List ε) :
    X.run s es = ((X.crossings s es).getLast?.map Crossing.dst).getD s := by
  induction es generalizing s with
  | nil => rfl
  | cons e es ih =>
    show X.run (X.step s e).1 es = _
    rw [ih]
    simp only [ExecStrat.crossings]
    rcases step_spec X s e with ⟨g, -, -, -, hstep⟩ | ⟨-, hstep⟩
    · rw [hstep]
      simp only [Option.toList, List.getLast?_append]
      cases (X.crossings g.target es).getLast? <;> simp
    · rw [hstep]
      simp only [Option.toList, List.getLast?_append]
      cases (X.crossings s es).getLast? <;> simp

/-- **GE-THM-8-6** (Containment). If every gate whose target is an authority stratum is triggered
only by system events, then a sequence of events containing no system event (whatever a learned
model classified) never moves the stratification into an authority stratum it did not start in:
if it ends in an authority stratum, it ends where it started. -/
theorem containment (X : ExecStrat σ ε) (sys : ε → Prop)
    (hgates : ∀ g ∈ X.gates, g.target ∈ X.authority → ∀ e, g.trigger e → sys e)
    (es : List ε) (hes : ∀ e ∈ es, ¬ sys e) (s : σ)
    (hend : X.run s es ∈ X.authority) : X.run s es = s := by
  suffices key : ∀ s, X.run s es = s ∨ X.run s es ∉ X.authority by
    rcases key s with h | h
    · exact h
    · exact absurd hend h
  clear hend s
  induction es with
  | nil => intro s; exact Or.inl rfl
  | cons e es ih =>
    intro s
    have ih' := ih (fun e' he' => hes e' (List.mem_cons_of_mem _ he'))
    show X.run (X.step s e).1 es = s ∨ X.run (X.step s e).1 es ∉ X.authority
    rcases step_spec X s e with ⟨g, hg, -, htr, hstep⟩ | ⟨-, hstep⟩
    · rw [hstep]
      have hna : g.target ∉ X.authority := fun ha =>
        hes e (by simp) (hgates g hg ha e htr)
      rcases ih' g.target with h | h
      · right
        show X.run g.target es ∉ X.authority
        rw [h]
        exact hna
      · exact Or.inr h
    · rw [hstep]; exact ih' s

/-- **GE-THM-8-6**, the form proved in TwinContainment.lean (`authority_needs_system`): starting
outside every authority stratum, such a sequence never reaches one. -/
theorem containment_outside (X : ExecStrat σ ε) (sys : ε → Prop)
    (hgates : ∀ g ∈ X.gates, g.target ∈ X.authority → ∀ e, g.trigger e → sys e)
    (es : List ε) (hes : ∀ e ∈ es, ¬ sys e) (s : σ) (hs : s ∉ X.authority) :
    X.run s es ∉ X.authority := fun h =>
  hs (containment X sys hgates es hes s h ▸ h)

/-- **GE-THM-8-7** (Absorption). If every gate leaving an absorbing stratum is triggered only by
human-oversight events (a gate whose source contains an absorbing stratum `b` and whose target is
not `b`), then a sequence of events containing no oversight event never moves the stratification
out of the absorbing stratum it is in. -/
theorem absorption (X : ExecStrat σ ε) (ovs : ε → Prop)
    (hgates : ∀ g ∈ X.gates, ∀ b ∈ X.absorbing, b ∈ g.source → g.target ≠ b →
      ∀ e, g.trigger e → ovs e)
    (es : List ε) (hes : ∀ e ∈ es, ¬ ovs e) (b : σ) (hb : b ∈ X.absorbing) :
    X.run b es = b := by
  induction es with
  | nil => rfl
  | cons e es ih =>
    show X.run (X.step b e).1 es = b
    have hstay : (X.step b e).1 = b := by
      rcases step_spec X b e with ⟨g, hg, hsrc, htr, hstep⟩ | ⟨-, hstep⟩
      · rw [hstep]
        by_contra hne
        exact hes e (by simp) (hgates g hg b hb hsrc hne e htr)
      · rw [hstep]
    rw [hstay]
    exact ih (fun e' he' => hes e' (List.mem_cons_of_mem _ he'))

/-- **GE-THM-8-7**, the form proved in TwinContainment.lean (`absorbing_stays`): under the weaker
hypothesis that only gates from an absorbing stratum to a NON-absorbing one need oversight, the run
stays inside the absorbing set (it may move between absorbing strata). -/
theorem absorption_set (X : ExecStrat σ ε) (ovs : ε → Prop)
    (hgates : ∀ g ∈ X.gates, ∀ b ∈ X.absorbing, b ∈ g.source → g.target ∉ X.absorbing →
      ∀ e, g.trigger e → ovs e)
    (es : List ε) (hes : ∀ e ∈ es, ¬ ovs e) (b : σ) (hb : b ∈ X.absorbing) :
    X.run b es ∈ X.absorbing := by
  induction es generalizing b with
  | nil => exact hb
  | cons e es ih =>
    show X.run (X.step b e).1 es ∈ X.absorbing
    apply ih (fun e' he' => hes e' (List.mem_cons_of_mem _ he'))
    rcases step_spec X b e with ⟨g, hg, hsrc, htr, hstep⟩ | ⟨-, hstep⟩
    · rw [hstep]
      by_contra hna
      exact hes e (by simp) (hgates g hg b hb hsrc hna e htr)
    · rw [hstep]; exact hb

end GeometricEthics.Strata
