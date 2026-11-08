/-
Geometric Ethics v1.25: the tensor-algebra claims of Chapters 6, 11 and 15.

All statements are pointwise: at a point p of the moral manifold the tangent space T_pM is
identified with `Fin n → ℝ` by a chart, a vector field evaluated at p is a vector, a covector
field a covector, and the Jacobian of a coordinate change at p is an invertible matrix. The book's
claims in these sections are claims about that linear algebra at each point; nothing about the
manifold beyond the point is used by any of the proofs in the book.
-/
import Mathlib

namespace GeometricEthics.Tensor

open Matrix

variable {n : ℕ}

/-! ## Proposition 6.1 (Invariance of Satisfaction) -/

/-- **GE-PROP-6-1** (Invariance of Satisfaction, book §6 Technical Appendix).
Under a coordinate change with Jacobian `A = ∂x̃/∂x` at the point (invertible), a vector
transforms as `Õ = A O` and a covector as `Ĩ_μ = (∂x^ν/∂x̃^μ) I_ν = (I ᵥ* A⁻¹)_μ`.
The satisfaction scalar `S = I_μ O^μ` is unchanged. -/
theorem satisfaction_invariant (A : Matrix (Fin n) (Fin n) ℝ) (hA : IsUnit A.det)
    (I O : Fin n → ℝ) :
    (I ᵥ* A⁻¹) ⬝ᵥ (A *ᵥ O) = I ⬝ᵥ O := by
  rw [dotProduct_mulVec, vecMul_vecMul, nonsing_inv_mul A hA, vecMul_one]

/-! ## Proposition 6.2 (Decomposition of Disagreement) -/

/-- **GE-PROP-6-2** (Decomposition of Disagreement), the decomposition:
`S' − S = ΔI_μ O^μ` with `ΔI = I' − I`. -/
theorem disagreement_decomposition (I I' O : Fin n → ℝ) :
    I' ⬝ᵥ O - I ⬝ᵥ O = (I' - I) ⬝ᵥ O := by
  rw [sub_dotProduct]

/-- **GE-PROP-6-2**, first biconditional: `S ≠ S'` iff `ΔI_μ O^μ ≠ 0`. -/
theorem disagreement_iff (I I' O : Fin n → ℝ) :
    I ⬝ᵥ O ≠ I' ⬝ᵥ O ↔ (I' - I) ⬝ᵥ O ≠ 0 := by
  rw [← disagreement_decomposition, sub_ne_zero, ne_comm]

/-- **GE-PROP-6-2**, the proof's necessity step: a disagreement requires a dimension `μ` on
which both the interest difference and the obligation are nonzero. -/
theorem disagreement_needs_shared_dimension (I I' O : Fin n → ℝ)
    (h : I ⬝ᵥ O ≠ I' ⬝ᵥ O) : ∃ μ, (I' - I) μ ≠ 0 ∧ O μ ≠ 0 := by
  rw [disagreement_iff] at h
  by_contra hc
  push Not at hc
  apply h
  unfold dotProduct
  refine Finset.sum_eq_zero fun μ _ => ?_
  by_cases hμ : (I' - I) μ = 0
  · simp [hμ]
  · simp [hc μ hμ]

/-- **GE-PROP-6-2**, "in particular": `S = S'` for all `O` iff `I = I'`. -/
theorem agree_on_all_obligations_iff (I I' : Fin n → ℝ) :
    (∀ O : Fin n → ℝ, I ⬝ᵥ O = I' ⬝ᵥ O) ↔ I = I' := by
  constructor
  · intro h
    funext μ
    have := h (Pi.single μ 1)
    simpa [dotProduct_single] using this
  · rintro rfl _
    rfl

/-- **GE-PROP-6-2**, the component-wise statement: the contribution of dimension `μ`,
`ΔI_μ O^μ`, vanishes iff `ΔI_μ = 0` or `O^μ = 0`. -/
theorem disagreement_component_zero_iff (ΔI O : Fin n → ℝ) (μ : Fin n) :
    ΔI μ * O μ = 0 ↔ ΔI μ = 0 ∨ O μ = 0 :=
  mul_eq_zero

/-! ## Proposition 6.3 (Metric Dependence of the Gradient Direction) -/

/-- **GE-PROP-6-3** (Metric Dependence of the Gradient), the defining property: for a symmetric
invertible metric `g`, the gradient `g⁻¹ df` is the unique vector `u` with
`g(u, V) = df(V)` for all `V`. -/
theorem gradient_unique (g : Matrix (Fin n) (Fin n) ℝ) (hsymm : gᵀ = g) (hg : IsUnit g.det)
    (df u : Fin n → ℝ) :
    (∀ V : Fin n → ℝ, u ⬝ᵥ (g *ᵥ V) = df ⬝ᵥ V) ↔ u = g⁻¹ *ᵥ df := by
  have key : (∀ V : Fin n → ℝ, u ⬝ᵥ (g *ᵥ V) = df ⬝ᵥ V) ↔ g *ᵥ u = df := by
    have hu : u ᵥ* g = g *ᵥ u := by
      conv_lhs => rw [← hsymm]
      rw [vecMul_transpose]
    simp only [dotProduct_mulVec, hu]
    exact agree_on_all_obligations_iff (g *ᵥ u) df
  rw [key]
  constructor
  · rintro rfl
    rw [mulVec_mulVec, nonsing_inv_mul g hg, one_mulVec]
  · rintro rfl
    rw [mulVec_mulVec, mul_nonsing_inv g hg, one_mulVec]

/-- **GE-PROP-6-3**, the correct criterion: the gradients of `f` under two inverse metrics
differ iff `(g⁻¹ − ĝ⁻¹) df ≠ 0`. -/
theorem gradients_differ_iff (ginv ghinv : Matrix (Fin n) (Fin n) ℝ) (df : Fin n → ℝ) :
    ginv *ᵥ df ≠ ghinv *ᵥ df ↔ (ginv - ghinv) *ᵥ df ≠ 0 := by
  rw [sub_mulVec, sub_ne_zero]

/-- The inverse metric `3·δ` on ℝ². -/
def ginvA : Matrix (Fin 2) (Fin 2) ℝ := !![3, 0; 0, 3]
/-- The inverse metric `[[2,1],[1,2]]` on ℝ². -/
def ginvB : Matrix (Fin 2) (Fin 2) ℝ := !![2, 1; 1, 2]
/-- The differential `df = (1, 1)`. -/
def dfEx : Fin 2 → ℝ := ![1, 1]

/-- **GE-PROP-6-3**, counterexample to the sufficient condition in the book's proof
("(grad_g f)^ν ≠ (grad_ĝ f)^ν whenever ∂f/∂x^μ ≠ 0 along a dimension where the inverse metrics
differ"). Both inverse metrics are symmetric and positive definite, they differ in every entry,
every component of `df` is nonzero, and yet the two gradients are equal (both `(3, 3)`). -/
theorem gradient_sufficient_condition_fails :
    ginvAᵀ = ginvA ∧ ginvBᵀ = ginvB ∧
    (∀ x : Fin 2 → ℝ, x ≠ 0 → 0 < x ⬝ᵥ (ginvA *ᵥ x)) ∧
    (∀ x : Fin 2 → ℝ, x ≠ 0 → 0 < x ⬝ᵥ (ginvB *ᵥ x)) ∧
    (∀ μ ν, ginvA μ ν ≠ ginvB μ ν) ∧ (∀ μ, dfEx μ ≠ 0) ∧
    ginvA *ᵥ dfEx = ginvB *ᵥ dfEx := by
  have hx : ∀ x : Fin 2 → ℝ, x ≠ 0 → x 0 ≠ 0 ∨ x 1 ≠ 0 := by
    intro x hx
    by_contra hc
    push Not at hc
    apply hx
    funext i
    fin_cases i <;> simp [hc.1, hc.2]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp [ginvA]
  · ext i j; fin_cases i <;> fin_cases j <;> simp [ginvB]
  · intro x h0
    simp only [ginvA, dotProduct, mulVec, Fin.sum_univ_two, Matrix.of_apply, Matrix.cons_val',
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one]
    rcases hx x h0 with h | h
    · have := sq_pos_of_ne_zero h; nlinarith [sq_nonneg (x 1)]
    · have := sq_pos_of_ne_zero h; nlinarith [sq_nonneg (x 0)]
  · intro x h0
    simp only [ginvB, dotProduct, mulVec, Fin.sum_univ_two, Matrix.of_apply, Matrix.cons_val',
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one]
    rcases hx x h0 with h | h
    · have := sq_pos_of_ne_zero h; nlinarith [sq_nonneg (x 1), sq_nonneg (x 0 + x 1)]
    · have := sq_pos_of_ne_zero h; nlinarith [sq_nonneg (x 0), sq_nonneg (x 0 + x 1)]
  · intro μ ν; fin_cases μ <;> fin_cases ν <;> norm_num [ginvA, ginvB]
  · intro μ; fin_cases μ <;> norm_num [dfEx]
  · ext i; fin_cases i <;> norm_num [ginvA, ginvB, dfEx, mulVec, dotProduct, Fin.sum_univ_two]

/-! ## Proposition 11.3 (Satisfaction as Directional Derivative of the Heuristic) -/

/-- **GE-PROP-11-3** (Satisfaction as Directional Derivative), given Proposition 11.1
(`O = −g⁻¹ dh`) as a hypothesis: `S = I_μ O^μ = −I_μ g^{μν} ∂_ν h`, and, for a symmetric inverse
metric, this equals `−dh(I♯)` with `I♯ = g⁻¹ I`: the NEGATIVE of the directional derivative of
`h` along the metric-raised interest direction. -/
theorem satisfaction_directional_derivative (ginv : Matrix (Fin n) (Fin n) ℝ)
    (hsymm : ginvᵀ = ginv) (I O dh : Fin n → ℝ) (h11_1 : O = -(ginv *ᵥ dh)) :
    I ⬝ᵥ O = -(I ⬝ᵥ (ginv *ᵥ dh)) ∧ I ⬝ᵥ O = -(dh ⬝ᵥ (ginv *ᵥ I)) := by
  subst h11_1
  refine ⟨dotProduct_neg _ _, ?_⟩
  have hv : I ᵥ* ginv = ginv *ᵥ I := by rw [← vecMul_transpose, hsymm]
  rw [dotProduct_neg, neg_inj, dotProduct_mulVec, hv, dotProduct_comm]

/-! ## Proposition 15.1 (Inevitability of Residue) -/

section Residue

variable {V : Type*} [AddCommGroup V] [Module ℝ V] [FiniteDimensional ℝ V]

/-- The residue `R = T − s(C T)` of a tensor `T` under a contraction `C : V → ℝ` with a chosen
section `s : ℝ → V` (`C ∘ s = id`), the book's `T − C⁻¹(S)`. -/
def residue (C : V →ₗ[ℝ] ℝ) (s : ℝ →ₗ[ℝ] V) (T : V) : V := T - s (C T)

omit [FiniteDimensional ℝ V] in
/-- **GE-PROP-15-1** (Inevitability of Residue), proof supplement: the residue lies in `ker C`. -/
theorem residue_mem_ker (C : V →ₗ[ℝ] ℝ) (s : ℝ →ₗ[ℝ] V) (hs : ∀ x, C (s x) = x) (T : V) :
    C (residue C s T) = 0 := by
  simp [residue, hs]

omit [FiniteDimensional ℝ V] in
/-- **GE-PROP-15-1**: the residue of `T` vanishes iff `T` lies in the one-dimensional image of the
section. -/
theorem residue_eq_zero_iff (C : V →ₗ[ℝ] ℝ) (s : ℝ →ₗ[ℝ] V) (hs : ∀ x, C (s x) = x) (T : V) :
    residue C s T = 0 ↔ T ∈ LinearMap.range s := by
  constructor
  · intro h
    exact ⟨C T, (sub_eq_zero.mp h).symm⟩
  · rintro ⟨x, rfl⟩
    simp [residue, hs]

/-- **GE-PROP-15-1**, proof supplement (rank-nullity): when `dim V = n^r > 1`, `ker C` has
dimension `dim V − 1 > 0`. -/
theorem ker_contraction_finrank (C : V →ₗ[ℝ] ℝ) (s : ℝ →ₗ[ℝ] V) (hs : ∀ x, C (s x) = x)
    (hV : 1 < Module.finrank ℝ V) :
    Module.finrank ℝ (LinearMap.ker C) = Module.finrank ℝ V - 1 ∧
    0 < Module.finrank ℝ (LinearMap.ker C) := by
  have hsurj : LinearMap.range C = ⊤ :=
    LinearMap.range_eq_top.mpr fun x => ⟨s x, hs x⟩
  have h := LinearMap.finrank_range_add_finrank_ker C
  rw [hsurj, finrank_top, Module.finrank_self] at h
  omega

omit [FiniteDimensional ℝ V] in
/-- **GE-PROP-15-1**, what is true: when `dim V > 1`, some tensor has nonzero residue (the
contraction is not invertible). -/
theorem exists_nonzero_residue (C : V →ₗ[ℝ] ℝ) (s : ℝ →ₗ[ℝ] V) (hs : ∀ x, C (s x) = x)
    (hV : 1 < Module.finrank ℝ V) : ∃ T : V, residue C s T ≠ 0 := by
  by_contra hc
  push Not at hc
  have htop : LinearMap.range s = ⊤ := by
    rw [eq_top_iff]
    intro T _
    exact (residue_eq_zero_iff C s hs T).mp (hc T)
  have h1 : Module.finrank ℝ (LinearMap.range s) ≤ 1 := by
    simpa using LinearMap.finrank_range_le s
  rw [htop, finrank_top] at h1
  omega

omit [FiniteDimensional ℝ V] in
/-- **GE-PROP-15-1**, counterexample to the statement as printed ("the moral residue is nonzero
unless T is already scalar"): the nonzero tensor `T = s(1)`, of any rank, has zero residue. -/
theorem residue_zero_for_nonscalar (C : V →ₗ[ℝ] ℝ) (s : ℝ →ₗ[ℝ] V) (hs : ∀ x, C (s x) = x) :
    s 1 ≠ 0 ∧ residue C s (s 1) = 0 := by
  refine ⟨fun h => ?_, (residue_eq_zero_iff C s hs _).mpr ⟨1, rfl⟩⟩
  have := hs 1
  rw [h, map_zero] at this
  exact zero_ne_one this

end Residue

/-! ## Proposition 15.3 (Non-Commutativity of Contraction) -/

section Contraction

variable {ι κ : Type*} [Fintype ι] [Fintype κ] [Nonempty κ]

/-- `C₁(T) = max_ν Σ_μ w_μ T^{μν}`: contract over `μ` first, then maximize over `ν`. -/
noncomputable def C₁ (w : ι → ℝ) (T : ι → κ → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty fun ν => ∑ μ, w μ * T μ ν

/-- `C₂(T) = Σ_μ w_μ max_ν T^{μν}`: maximize over `ν` first, then contract over `μ`. -/
noncomputable def C₂ (w : ι → ℝ) (T : ι → κ → ℝ) : ℝ :=
  ∑ μ, w μ * Finset.univ.sup' Finset.univ_nonempty (T μ)

/-- `ν` maximizes row `μ` of `T`. -/
def IsRowMax (T : ι → κ → ℝ) (μ : ι) (ν : κ) : Prop := ∀ ν', T μ ν' ≤ T μ ν

omit [Fintype ι] [Nonempty κ] in
theorem isRowMax_iff (T : ι → κ → ℝ) [Nonempty κ] (μ : ι) (ν : κ) :
    IsRowMax T μ ν ↔ T μ ν = Finset.univ.sup' Finset.univ_nonempty (T μ) := by
  constructor
  · intro h
    exact le_antisymm (Finset.le_sup' (T μ) (Finset.mem_univ ν))
      (Finset.sup'_le _ _ fun ν' _ => h ν')
  · intro h ν'
    rw [h]
    exact Finset.le_sup' (T μ) (Finset.mem_univ ν')

/-- **GE-PROP-15-3** (Non-Commutativity of Contraction), with nonnegative weights `C₁ ≤ C₂`. -/
theorem C₁_le_C₂ (w : ι → ℝ) (hw : ∀ μ, 0 ≤ w μ) (T : ι → κ → ℝ) : C₁ w T ≤ C₂ w T := by
  unfold C₁ C₂
  refine Finset.sup'_le _ _ fun ν _ => Finset.sum_le_sum fun μ _ => ?_
  exact mul_le_mul_of_nonneg_left (Finset.le_sup' (T μ) (Finset.mem_univ ν)) (hw μ)

/-- **GE-PROP-15-3**, corrected biconditional for nonnegative weights: `C₁ = C₂` iff some single
option `ν*` maximizes every row that carries positive weight. -/
theorem C₁_eq_C₂_iff_nonneg (w : ι → ℝ) (hw : ∀ μ, 0 ≤ w μ) (T : ι → κ → ℝ) :
    C₁ w T = C₂ w T ↔ ∃ ν, ∀ μ, 0 < w μ → IsRowMax T μ ν := by
  constructor
  · intro heq
    obtain ⟨ν, -, hν⟩ := Finset.exists_mem_eq_sup' (Finset.univ_nonempty (α := κ))
      (fun ν => ∑ μ, w μ * T μ ν)
    refine ⟨ν, fun μ hμ => ?_⟩
    have hsum : ∑ μ, w μ * (Finset.univ.sup' Finset.univ_nonempty (T μ) - T μ ν) = 0 := by
      simp only [mul_sub, Finset.sum_sub_distrib]
      rw [← C₂, ← hν, ← C₁, heq, sub_self]
    have hnn : ∀ μ ∈ Finset.univ,
        0 ≤ w μ * (Finset.univ.sup' Finset.univ_nonempty (T μ) - T μ ν) := fun μ _ =>
      mul_nonneg (hw μ) (sub_nonneg.mpr (Finset.le_sup' (T μ) (Finset.mem_univ ν)))
    have h0 := (Finset.sum_eq_zero_iff_of_nonneg hnn).mp hsum μ (Finset.mem_univ μ)
    rcases mul_eq_zero.mp h0 with h | h
    · exact absurd h hμ.ne'
    · exact (isRowMax_iff T μ ν).mpr (sub_eq_zero.mp h).symm
  · rintro ⟨ν, hν⟩
    refine le_antisymm (C₁_le_C₂ w hw T) ?_
    have : C₂ w T = ∑ μ, w μ * T μ ν := by
      unfold C₂
      refine Finset.sum_congr rfl fun μ _ => ?_
      rcases (hw μ).lt_or_eq with h | h
      · rw [← (isRowMax_iff T μ ν).mp (hν μ h)]
      · rw [← h, zero_mul, zero_mul]
    rw [this]
    exact Finset.le_sup' (fun ν => ∑ μ, w μ * T μ ν) (Finset.mem_univ ν)

/-- **GE-PROP-15-3**, the book's biconditional, which holds when every weight is strictly
positive: `C₁ = C₂` iff some option `ν*` maximizes every row ("a unanimous best option"). -/
theorem C₁_eq_C₂_iff_pos (w : ι → ℝ) (hw : ∀ μ, 0 < w μ) (T : ι → κ → ℝ) :
    C₁ w T = C₂ w T ↔ ∃ ν, ∀ μ, IsRowMax T μ ν := by
  rw [C₁_eq_C₂_iff_nonneg w (fun μ => (hw μ).le)]
  exact exists_congr fun ν => ⟨fun h μ => h μ (hw μ), fun h μ _ => h μ⟩

end Contraction

/-- The `2 × 2` identity table, used in the examples below. -/
def Tid : Fin 2 → Fin 2 → ℝ := fun μ ν => if μ = ν then 1 else 0

/-- **GE-PROP-15-3**, "in general `C₁(T) ≠ C₂(T)`": with weights `(1,1)` and the identity table,
`C₁ = 1` and `C₂ = 2`. -/
theorem contraction_order_matters : C₁ ![1, 1] Tid = 1 ∧ C₂ ![1, 1] Tid = 2 := by
  constructor
  · unfold C₁
    apply le_antisymm
    · refine Finset.sup'_le _ _ fun ν _ => ?_
      fin_cases ν <;> simp [Tid]
    · refine le_trans ?_ (Finset.le_sup' _ (Finset.mem_univ (0 : Fin 2)))
      simp [Tid]
  · unfold C₂
    have h : ∀ μ : Fin 2, Finset.univ.sup' Finset.univ_nonempty (Tid μ) = 1 := by
      intro μ
      apply le_antisymm
      · refine Finset.sup'_le _ _ fun ν _ => ?_
        unfold Tid; split_ifs <;> norm_num
      · refine le_trans ?_ (Finset.le_sup' _ (Finset.mem_univ μ))
        simp [Tid]
    simp only [h, Fin.sum_univ_two]
    norm_num

/-- **GE-PROP-15-3**, counterexample to the "only if" half of the printed biconditional: with
weights `(1, 0)` and the identity table, `C₁ = C₂ = 1`, yet no option maximizes both rows. A zero
weight hides the disagreement of its row. -/
theorem equality_without_unanimity :
    C₁ ![1, 0] Tid = C₂ ![1, 0] Tid ∧ ¬ ∃ ν, ∀ μ, IsRowMax Tid μ ν := by
  constructor
  · rw [C₁_eq_C₂_iff_nonneg _ (by intro μ; fin_cases μ <;> norm_num)]
    refine ⟨0, fun μ hμ => ?_⟩
    fin_cases μ
    · intro ν'; fin_cases ν' <;> simp [Tid]
    · simp at hμ
  · rintro ⟨ν, hν⟩
    fin_cases ν
    · have := hν 1 1; norm_num [Tid] at this
    · have := hν 0 0; norm_num [Tid] at this

/-- **GE-PROP-15-3**, counterexample to the "if" half without a sign condition on the weights:
one dimension with weight `−1` and row `(0, 1)`; option `1` is unanimous, yet `C₁ = 0 ≠ −1 = C₂`. -/
theorem unanimity_without_equality_negative_weight :
    (∃ ν, ∀ μ, IsRowMax (fun (_ : Fin 1) (ν : Fin 2) => (ν : ℝ)) μ ν) ∧
    C₁ ![-1] (fun (_ : Fin 1) (ν : Fin 2) => (ν : ℝ)) ≠
      C₂ ![-1] (fun (_ : Fin 1) (ν : Fin 2) => (ν : ℝ)) := by
  have hmax : Finset.univ.sup' Finset.univ_nonempty (fun ν : Fin 2 => (ν : ℝ)) = 1 := by
    apply le_antisymm
    · refine Finset.sup'_le _ _ fun ν _ => ?_
      fin_cases ν <;> norm_num
    · exact le_trans (by norm_num) (Finset.le_sup' _ (Finset.mem_univ (1 : Fin 2)))
  have h1 : C₁ ![-1] (fun (_ : Fin 1) (ν : Fin 2) => (ν : ℝ)) = 0 := by
    unfold C₁
    apply le_antisymm
    · refine Finset.sup'_le _ _ fun ν _ => ?_
      fin_cases ν <;> norm_num
    · exact le_trans (by norm_num) (Finset.le_sup' _ (Finset.mem_univ (0 : Fin 2)))
  have h2 : C₂ ![-1] (fun (_ : Fin 1) (ν : Fin 2) => (ν : ℝ)) = -1 := by
    unfold C₂
    simp [hmax]
  refine ⟨⟨1, fun μ ν' => ?_⟩, ?_⟩
  · fin_cases ν' <;> norm_num
  · rw [h1, h2]; norm_num

end GeometricEthics.Tensor
