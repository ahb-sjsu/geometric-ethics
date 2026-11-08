/-
Geometric Ethics v1.25: the Hohfeldian group claims.

Reuses erisml-lib `formal/HohfeldV4.lean` (verified on Atlas 2026-08-17), with the jural flip
named `n` as in the book's §8.4 replacement text (source/updates/sec8_4_hohfeld_v4.tex), where
HohfeldV4.lean calls it `r2` (the square of its quarter-turn).

Positions: 0 = Obligation (O), 1 = Claim (C), 2 = Liberty (L), 3 = No-claim (N), matching
erisml-lib `src/erisml/ethics/hohfeld.py`.

Covers GE-PROP-8-3-V4, GE-THM-12-2-V4, GE-PROP-A-2-V4, GE-LEMMA-9-1-V4 and GE-LEMMA-A-2.
-/
import Mathlib

namespace GeometricEthics.Hohfeld

/-- Hohfeldian positions: 0 = O, 1 = C, 2 = L, 3 = N. -/
abbrev Position : Type := Fin 4

/-- The correlative `s`: O ↔ C, L ↔ N. -/
def s : Equiv.Perm Position := Equiv.swap 0 1 * Equiv.swap 2 3

/-- The jural flip `n` (deontic negation): O ↔ L, C ↔ N. -/
def n : Equiv.Perm Position := Equiv.swap 0 2 * Equiv.swap 1 3

/-- The quarter-turn as printed in the book, O → C → N → L → O. -/
def quarterTurnBook : Equiv.Perm Position :=
  ⟨![1, 3, 0, 2], ![2, 0, 3, 1], by decide, by decide⟩

/-- The quarter-turn of erisml-lib HohfeldV4.lean, O → C → L → N → O (its `r`). -/
def quarterTurnErisml : Equiv.Perm Position :=
  ⟨![1, 2, 3, 0], ![3, 0, 1, 2], by decide, by decide⟩

/-- HohfeldV4.lean defines the jural flip as the square of its quarter-turn; the two agree. -/
theorem n_eq_erisml_r2 : n = quarterTurnErisml * quarterTurnErisml := by decide

/-- The group the two demonstrated operations generate. -/
abbrev V4 : Subgroup (Equiv.Perm Position) := Subgroup.closure {s, n}

/-- The abstract Klein four-group `ℤ₂ × ℤ₂`, written multiplicatively. -/
abbrev K4 : Type := Multiplicative (ZMod 2 × ZMod 2)

/-- `(a, b) ↦ sᵃ nᵇ`. -/
def phi : K4 →* Equiv.Perm Position where
  toFun p := s ^ p.toAdd.1.val * n ^ p.toAdd.2.val
  map_one' := by decide
  map_mul' := by decide

theorem phi_injective : Function.Injective phi := by decide

theorem V4_eq_range : V4 = phi.range := by
  apply le_antisymm
  · rw [Subgroup.closure_le]
    intro x hx
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
    rcases hx with rfl | rfl
    · exact ⟨Multiplicative.ofAdd (1, 0), by decide⟩
    · exact ⟨Multiplicative.ofAdd (0, 1), by decide⟩
  · rintro x ⟨p, rfl⟩
    have hs : s ∈ V4 := Subgroup.subset_closure (by simp)
    have hn : n ∈ V4 := Subgroup.subset_closure (by simp)
    exact mul_mem (pow_mem hs _) (pow_mem hn _)

theorem mem_V4_iff (σ : Equiv.Perm Position) : σ ∈ V4 ↔ ∃ q : K4, phi q = σ := by
  rw [V4_eq_range]; rfl

/-! ## GE-PROP-8-3-V4 -/

/-- **GE-PROP-8-3-V4** (V₄ structure of Hohfeldian transitions), part 1: `s` and `n` are
commuting involutions, distinct and nontrivial. -/
theorem commuting_involutions :
    s * s = 1 ∧ n * n = 1 ∧ s * n = n * s ∧ s ≠ 1 ∧ n ≠ 1 ∧ s ≠ n := by decide

/-- **GE-PROP-8-3-V4**, part 2: the generated group is isomorphic to `ℤ₂ × ℤ₂`. -/
noncomputable def V4MulEquivKlein : V4 ≃* K4 :=
  (MulEquiv.subgroupCongr V4_eq_range).trans (MonoidHom.ofInjective phi_injective).symm

/-- **GE-PROP-8-3-V4**, part 2: the generated group is `{e, n, s, sn}`, of order four. -/
theorem V4_card : Nat.card V4 = 4 := by
  rw [Nat.card_congr V4MulEquivKlein.toEquiv, Nat.card_eq_fintype_card]
  decide

/-- **GE-PROP-8-3-V4**, part 2: its elements are exactly `e, n, s, sn`. -/
theorem V4_elements (σ : Equiv.Perm Position) :
    σ ∈ V4 ↔ σ = 1 ∨ σ = n ∨ σ = s ∨ σ = s * n := by
  rw [mem_V4_iff]
  constructor
  · rintro ⟨q, rfl⟩
    revert q; decide
  · rintro (rfl | rfl | rfl | rfl)
    · exact ⟨Multiplicative.ofAdd (0, 0), by decide⟩
    · exact ⟨Multiplicative.ofAdd (0, 1), by decide⟩
    · exact ⟨Multiplicative.ofAdd (1, 0), by decide⟩
    · exact ⟨Multiplicative.ofAdd (1, 1), by decide⟩

/-- **GE-PROP-8-3-V4**, part 3: abelian, with every element its own inverse. -/
theorem V4_abelian_exponent_two :
    (∀ x ∈ V4, ∀ y ∈ V4, x * y = y * x) ∧ (∀ x ∈ V4, x * x = 1) := by
  constructor
  · intro x hx y hy
    obtain ⟨p, rfl⟩ := (mem_V4_iff x).mp hx
    obtain ⟨q, rfl⟩ := (mem_V4_iff y).mp hy
    rw [← map_mul, ← map_mul, mul_comm p q]
  · intro x hx
    obtain ⟨p, rfl⟩ := (mem_V4_iff x).mp hx
    clear hx; revert p; decide

/-- **GE-PROP-8-3-V4**, part 4: the action is regular. For any two positions there is an
operation of the group taking the first to the second ... -/
theorem V4_transitive (a b : Position) : ∃ σ ∈ V4, σ a = b := by
  obtain ⟨q, hq⟩ : ∃ q : K4, phi q a = b := by revert a b; decide
  exact ⟨phi q, (mem_V4_iff _).mpr ⟨q, rfl⟩, hq⟩

/-- **GE-PROP-8-3-V4**, part 4: ... and exactly one (the action is free). -/
theorem V4_free (a : Position) (σ τ : Equiv.Perm Position) (hσ : σ ∈ V4) (hτ : τ ∈ V4)
    (h : σ a = τ a) : σ = τ := by
  obtain ⟨p, rfl⟩ := (mem_V4_iff σ).mp hσ
  obtain ⟨q, rfl⟩ := (mem_V4_iff τ).mp hτ
  clear hσ hτ; revert p q a; decide

/-- **GE-PROP-8-3-V4**, part 5: no operation cycles the four positions, so the quarter-turn
as printed (O → C → N → L → O) lies outside the group; so does HohfeldV4.lean's quarter-turn
(O → C → L → N → O). -/
theorem quarter_turn_not_generated :
    quarterTurnBook ∉ V4 ∧ quarterTurnErisml ∉ V4 := by
  constructor <;>
  · intro h
    have := V4_abelian_exponent_two.2 _ h
    revert this; decide

/-- **GE-PROP-8-3-V4**, the bit encoding: `O = 00, L = 10, C = 01, N = 11` (first bit "negated",
second bit "correlated"), and the operation `sᵃ nᵇ` is the bit pattern `(b, a)`. -/
def enc : Position → ZMod 2 × ZMod 2 := ![(0, 0), (0, 1), (1, 0), (1, 1)]

/-- **GE-PROP-8-3-V4**, the bit encoding: applying an operation is bitwise XOR. -/
theorem action_is_xor (a b : ZMod 2) (p : Position) :
    enc (phi (Multiplicative.ofAdd (a, b)) p) = enc p + (b, a) := by
  revert a b p; decide

/-- **GE-PROP-8-3-V4**, the gate example: the unique operation taking Liberty to Claim
("you have every right") is `sn`. -/
theorem liberty_to_claim_is_sn : ∀ σ ∈ V4, σ 2 = 1 ↔ σ = s * n := by
  intro σ hσ
  rcases (V4_elements σ).mp hσ with rfl | rfl | rfl | rfl <;> decide

/-! ## GE-THM-12-2-V4 -/

/-- **GE-THM-12-2-V4** (gauge group of the Hohfeldian positions, restated for V₄): the subgroup
of `Perm` of the four positions generated by `s` and `n` is isomorphic to `ℤ₂ × ℤ₂`, has four
elements, and is commutative. -/
theorem gauge_group_V4 :
    Nonempty (V4 ≃* Multiplicative (ZMod 2 × ZMod 2)) ∧ Nat.card V4 = 4 ∧
    ∀ x ∈ V4, ∀ y ∈ V4, x * y = y * x :=
  ⟨⟨V4MulEquivKlein⟩, V4_card, V4_abelian_exponent_two.1⟩

/-! ## GE-PROP-A-2-V4: the total count and the Hohfeldian charge -/

/-- The sign of each position in the charge `Q = n_O − n_L + n_C − n_N`. -/
def chi : Position → ℤ := ![1, 1, -1, -1]

/-- The total count `N = n_O + n_C + n_L + n_N`. -/
def total (c : Position → ℤ) : ℤ := ∑ p, c p

/-- The Hohfeldian charge `Q = n_O − n_L + n_C − n_N`. -/
def charge (c : Position → ℤ) : ℤ := ∑ p, chi p * c p

theorem charge_eq (c : Position → ℤ) : charge c = c 0 - c 2 + c 1 - c 3 := by
  simp [charge, chi, Fin.sum_univ_four]; ring

/-- Relabelling a count vector by an operation `σ`: `(σ · c)(p) = c(σ⁻¹ p)`. -/
def act (σ : Equiv.Perm Position) (c : Position → ℤ) : Position → ℤ := fun p => c (σ.symm p)

theorem charge_act (σ : Equiv.Perm Position) (c : Position → ℤ) :
    charge (act σ c) = ∑ p, chi (σ p) * c p := by
  unfold charge act
  exact (Equiv.sum_comp σ (fun p => chi p * c (σ.symm p))).symm.trans (by simp)

/-- **GE-PROP-A-2-V4**: the total count is invariant under every relabelling, in particular
under `s` and `n`. -/
theorem total_invariant (σ : Equiv.Perm Position) (c : Position → ℤ) :
    total (act σ c) = total c := by
  unfold total act
  exact Equiv.sum_comp σ.symm c

/-- **GE-PROP-A-2-V4**: `Q ∘ s = Q` and `Q ∘ n = −Q`. -/
theorem charge_s_n (c : Position → ℤ) :
    charge (act s c) = charge c ∧ charge (act n c) = -charge c := by
  rw [charge_act, charge_act]
  constructor <;> (simp [charge, chi, s, n, Fin.sum_univ_four, Equiv.swap_apply_def]; try ring)

/-- **GE-PROP-A-2-V4**: `Q²` (and `N`) are invariant under the whole group V₄. -/
theorem charge_sq_V4_invariant (σ : Equiv.Perm Position) (hσ : σ ∈ V4) (c : Position → ℤ) :
    charge (act σ c) ^ 2 = charge c ^ 2 ∧ total (act σ c) = total c := by
  refine ⟨?_, total_invariant σ c⟩
  have hsign : (fun p => chi (σ p)) = chi ∨ (fun p => chi (σ p)) = fun p => -chi p := by
    rcases (V4_elements σ).mp hσ with rfl | rfl | rfl | rfl <;> decide
  rw [charge_act]
  rcases hsign with h | h
  · rw [show (∑ p, chi (σ p) * c p) = ∑ p, chi p * c p from by
      simp_rw [show ∀ p, chi (σ p) = chi p from fun p => congrFun h p]]
    rfl
  · rw [show (∑ p, chi (σ p) * c p) = -∑ p, chi p * c p from by
      simp_rw [show ∀ p, chi (σ p) = -chi p from fun p => congrFun h p]
      simp [Finset.sum_neg_distrib]]
    unfold charge; ring

/-! ## GE-LEMMA-9-1-V4: the V₄ constraint on metric components -/

/-- **GE-LEMMA-9-1-V4** (constraint on metric components, restated for V₄): a metric component
`g_{2μ}` that is a function of the Hohfeldian position and invariant under V₄
(`g(σ p) = g(p)` for every `σ ∈ V₄`) is constant: `g(O) = g(C) = g(L) = g(N)`. The proof uses
only transitivity of the action. -/
theorem invariant_component_constant (g : Position → ℝ)
    (hg : ∀ σ ∈ V4, ∀ p, g (σ p) = g p) (p q : Position) : g p = g q := by
  obtain ⟨σ, hσ, rfl⟩ := V4_transitive p q
  exact (hg σ hσ p).symm

/-- The V₄-invariant families of nine metric components `μ ↦ (position ↦ g_{2μ})`. -/
def invariantComponents : Submodule ℝ (Fin 9 → Position → ℝ) where
  carrier := {G | ∀ σ ∈ V4, ∀ μ p, G μ (σ p) = G μ p}
  add_mem' := by
    intro a b ha hb σ hσ μ p
    show a μ (σ p) + b μ (σ p) = a μ p + b μ p
    rw [ha σ hσ μ p, hb σ hσ μ p]
  zero_mem' := by intro σ _ μ p; rfl
  smul_mem' := by
    intro c a ha σ hσ μ p
    show c * a μ (σ p) = c * a μ p
    rw [ha σ hσ μ p]

/-- Invariant families are determined by one value per component. -/
noncomputable def invariantEquiv : invariantComponents ≃ₗ[ℝ] (Fin 9 → ℝ) where
  toFun G := fun μ => G.1 μ 0
  map_add' _ _ := rfl
  map_smul' _ _ := rfl
  invFun c := ⟨fun μ _ => c μ, by intro σ _ μ p; rfl⟩
  left_inv G := by
    apply Subtype.ext
    funext μ p
    exact invariant_component_constant (G.1 μ) (fun σ hσ q => G.2 σ hσ μ q) 0 p
  right_inv _ := rfl

/-- **GE-LEMMA-9-1-V4**, the count: nine components with four position values each (36 degrees
of freedom) are cut to 9 by V₄ invariance, eliminating `9 × (4 − 1) = 27`. -/
theorem degrees_of_freedom_eliminated :
    Module.finrank ℝ (Fin 9 → Position → ℝ) = 36 ∧
    Module.finrank ℝ invariantComponents = 9 ∧
    Module.finrank ℝ (Fin 9 → Position → ℝ) - Module.finrank ℝ invariantComponents = 27 := by
  have h1 : Module.finrank ℝ (Fin 9 → Position → ℝ) = 36 := by
    rw [Module.finrank_pi_fintype]; simp
  have h2 : Module.finrank ℝ invariantComponents = 9 := by
    rw [invariantEquiv.finrank_eq]; simp
  exact ⟨h1, h2, by rw [h1, h2]⟩

/-! ## GE-LEMMA-A-2: Aut(C₄) ≅ D₄ -/

open SimpleGraph DihedralGroup

/-- `D₄` acting on the vertices of `C₄`: `r i : x ↦ x − i`, `sr i : x ↦ i − x`. -/
def d4ToPerm : DihedralGroup 4 →* Equiv.Perm (Fin 4) where
  toFun
    | .r i => Equiv.subRight (show Fin 4 from i)
    | .sr i => Equiv.subLeft (show Fin 4 from i)
  map_one' := by decide
  map_mul' := by decide

theorem d4ToPerm_injective : Function.Injective d4ToPerm := by decide

/-- The automorphisms of the cycle graph `C₄`, as permutations of its vertices. -/
def autSub : Subgroup (Equiv.Perm (Fin 4)) where
  carrier := {σ | ∀ a b, (cycleGraph 4).Adj (σ a) (σ b) ↔ (cycleGraph 4).Adj a b}
  mul_mem' := by
    intro σ τ hσ hτ a b
    simp only [Equiv.Perm.coe_mul, Function.comp_apply]
    rw [hσ, hτ]
  one_mem' := by intro a b; rfl
  inv_mem' := by
    intro σ hσ a b
    rw [← hσ (σ⁻¹ a) (σ⁻¹ b)]
    simp

instance : DecidablePred (· ∈ autSub) := fun σ =>
  inferInstanceAs (Decidable (∀ a b, (cycleGraph 4).Adj (σ a) (σ b) ↔ (cycleGraph 4).Adj a b))

theorem autSub_eq_range : autSub = d4ToPerm.range := by
  ext σ
  change σ ∈ autSub ↔ ∃ d, d4ToPerm d = σ
  revert σ; decide

/-- Graph automorphisms of `C₄` are the adjacency-preserving permutations. -/
def autEquiv : (cycleGraph 4 ≃g cycleGraph 4) ≃* autSub where
  toFun f := ⟨f.toEquiv, fun _ _ => f.map_rel_iff⟩
  invFun σ := ⟨σ.1, fun {a b} => σ.2 a b⟩
  left_inv _ := rfl
  right_inv _ := rfl
  map_mul' _ _ := rfl

/-- **GE-LEMMA-A-2** (Automorphism Group of C₄): `Aut(C₄) ≅ D₄`. -/
noncomputable def autC4MulEquivD4 : (cycleGraph 4 ≃g cycleGraph 4) ≃* DihedralGroup 4 :=
  autEquiv.trans ((MulEquiv.subgroupCongr autSub_eq_range).trans
    (MonoidHom.ofInjective d4ToPerm_injective).symm)

/-- **GE-LEMMA-A-2**: `|Aut(C₄)| = 8`. -/
theorem card_aut_C4 : Nat.card (cycleGraph 4 ≃g cycleGraph 4) = 8 := by
  rw [Nat.card_congr autC4MulEquivD4.toEquiv, DihedralGroup.nat_card]

/-- The book's rotation `r : i ↦ i + 1 (mod 4)` and reflection `s : i ↦ −i (mod 4)` are the
images of `r 3` and `sr 0`. -/
theorem book_generators :
    (∀ x : Fin 4, d4ToPerm (r 3) x = x + 1) ∧ (∀ x : Fin 4, d4ToPerm (sr 0) x = -x) := by
  decide

/-- **GE-LEMMA-A-2**, generation: the book's `r` and `s` generate D₄ ... -/
theorem book_generators_generate :
    Subgroup.closure ({r 3, sr 0} : Set (DihedralGroup 4)) = ⊤ := by
  rw [eq_top_iff]
  rintro x -
  have h3 : (r 3 : DihedralGroup 4) ∈ Subgroup.closure ({r 3, sr 0} : Set (DihedralGroup 4)) :=
    Subgroup.subset_closure (by simp)
  have h0 : (sr 0 : DihedralGroup 4) ∈ Subgroup.closure ({r 3, sr 0} : Set (DihedralGroup 4)) :=
    Subgroup.subset_closure (by simp)
  have hr : ∀ i : ZMod 4, r i ∈ Subgroup.closure ({r 3, sr 0} : Set (DihedralGroup 4)) := by
    intro i
    have h1 : (r 1 : DihedralGroup 4) = r 3 ^ 3 := by decide
    have : (r i : DihedralGroup 4) = (r 3 ^ 3) ^ i.val := by
      rw [← h1, r_one_pow, ZMod.natCast_zmod_val]
    rw [this]
    exact pow_mem (pow_mem h3 3) _
  cases x with
  | r i => exact hr i
  | sr i =>
    have : (sr i : DihedralGroup 4) = sr 0 * r i := by simp [sr_mul_r]
    rw [this]
    exact mul_mem h0 (hr i)

/-- **GE-LEMMA-A-2**, ... and satisfy the standard presentation `r⁴ = s² = e`, `srs = r⁻¹`. -/
theorem book_presentation :
    (r 3 : DihedralGroup 4) ^ 4 = 1 ∧ (sr 0 : DihedralGroup 4) ^ 2 = 1 ∧
    sr 0 * r 3 * sr 0 = (r 3 : DihedralGroup 4)⁻¹ := by
  decide

end GeometricEthics.Hohfeld
