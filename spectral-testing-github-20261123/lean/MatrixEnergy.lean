import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Algebra.Order.BigOperators.Ring.Finset

namespace LatentLimits.MatrixEnergy
open scoped BigOperators
open Matrix WithLp
variable {n k : Type*} [Fintype n] [Fintype k] [DecidableEq n] [DecidableEq k]

omit [DecidableEq n] in
lemma trace_transpose_product (A B : Matrix n n ℝ) :
    Matrix.trace (A.transpose * B) = ∑ i, ∑ j, A i j * B i j := by
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply, Matrix.transpose_apply]
  exact Finset.sum_comm

omit [DecidableEq n] in
/-- An actual orthonormal column frame, not an assumed scalar energy bound. -/
theorem trace_sq_le_frame_energy (Q : Matrix n n ℝ) (U : Matrix n k ℝ)
    (ortho : U.transpose * U = 1) (factor : U * (U.transpose * Q) = Q) :
    (Matrix.trace Q)^2 ≤ (Fintype.card k : ℝ) * (∑ i, ∑ j, (Q i j)^2) := by
  let P : Matrix n n ℝ := U * U.transpose
  have psym : P.transpose=P := by simp [P, Matrix.transpose_mul]
  have pid : P*P=P := by
    dsimp [P]
    calc
      U * U.transpose * (U * U.transpose) = U * (U.transpose * U) * U.transpose := by
        simp only [Matrix.mul_assoc]
      _ = U * U.transpose := by rw [ortho, Matrix.mul_one]
  have pq : P*Q=Q := by simpa only [P, Matrix.mul_assoc] using factor
  have pe : (∑ i, ∑ j, (P i j)^2)=(Fintype.card k : ℝ) := by
    calc
      _ = Matrix.trace (P.transpose * P) := by
        rw [trace_transpose_product]
        simp only [pow_two]
      _ = Matrix.trace P := by rw [psym,pid]
      _ = Matrix.trace (U.transpose * U) := Matrix.trace_mul_comm _ _
      _ = _ := by rw [ortho,Matrix.trace_one]
  have pairing : (∑ i, ∑ j, P i j*Q i j)=Matrix.trace Q := by
    rw [← trace_transpose_product, psym, pq]
  have hc := Finset.sum_mul_sq_le_sq_mul_sq (Finset.univ : Finset (n × n))
    (fun ij => P ij.1 ij.2) (fun ij => Q ij.1 ij.2)
  simp only [Fintype.sum_prod_type] at hc
  rw [pairing,pe] at hc
  exact hc

/-- Every real matrix has an orthonormal factor through its actual column range. -/
theorem exists_orthonormal_column_frame (Q : Matrix n n ℝ) :
    ∃ (r : ℕ) (U : Matrix n (Fin r) ℝ), r=Q.rank ∧
      U.transpose*U=1 ∧ U*(U.transpose*Q)=Q := by
  let E := EuclideanSpace ℝ n
  let K : Submodule ℝ E := LinearMap.range Q.toEuclideanLin
  let b := stdOrthonormalBasis ℝ K
  let U : Matrix n (Fin (Module.finrank ℝ K)) ℝ := fun i j => (b j : E) i
  have hr : Module.finrank ℝ K=Q.rank := by
    symm
    exact Q.rank_eq_finrank_range_toLin (EuclideanSpace.basisFun n ℝ).toBasis
      (EuclideanSpace.basisFun n ℝ).toBasis
  have orth : U.transpose*U=1 := by
    ext i j
    change (∑ l, U l i*U l j)=(if i=j then 1 else 0)
    have hb := b.inner_eq_ite i j
    change (∑ l, (b j : E) l * (b i : E) l)=(if i=j then 1 else 0) at hb
    change (∑ l, U l j * U l i)=(if i=j then 1 else 0) at hb
    calc
      _ = ∑ l, U l j * U l i := Finset.sum_congr rfl (fun l _ => mul_comm _ _)
      _ = _ := hb
  have colmem (j : n) : (toLp 2 (fun i => Q i j) : E) ∈ K := by
    refine ⟨EuclideanSpace.single j 1, ?_⟩
    ext i
    change (Q *ᵥ Pi.single j (1 : ℝ)) i=Q i j
    exact congrFun (Matrix.mulVec_single_one Q j) i
  have fact : U*(U.transpose*Q)=Q := by
    ext i j
    let v : K := ⟨toLp 2 (fun i => Q i j), colmem j⟩
    let L : K →ₗ[ℝ] ℝ := (EuclideanSpace.projₗ i).comp K.subtype
    have hv := congrArg L (b.sum_repr' v)
    change (∑ l, U i l*(∑ t, U t l*Q t j))=Q i j
    simp only [map_sum, map_smul, smul_eq_mul] at hv
    change (∑ l, (∑ t, Q t j*U t l)*U i l)=Q i j at hv
    calc
      _ = ∑ l, (∑ t, Q t j * U t l) * U i l := by
        apply Finset.sum_congr rfl
        intro l _
        rw [mul_comm]
        congr 1
        exact Finset.sum_congr rfl (fun t _ => mul_comm _ _)
      _ = _ := hv
  exact ⟨Module.finrank ℝ K,U,hr,orth,fact⟩

/-- Matrix.rank is mathlib's dimension of the range; no SVD or factor hypothesis remains. -/
theorem trace_sq_le_rank_frobenius (Q : Matrix n n ℝ) :
    (Matrix.trace Q)^2 ≤ (Q.rank : ℝ) * (∑ i, ∑ j, (Q i j)^2) := by
  obtain ⟨r,U,hr,ho,hf⟩ := exists_orthonormal_column_frame Q
  have hb := trace_sq_le_frame_energy Q U ho hf
  simpa only [Fintype.card_fin,hr] using hb

end LatentLimits.MatrixEnergy

#print axioms LatentLimits.MatrixEnergy.trace_transpose_product
#print axioms LatentLimits.MatrixEnergy.trace_sq_le_frame_energy
#print axioms LatentLimits.MatrixEnergy.exists_orthonormal_column_frame
#print axioms LatentLimits.MatrixEnergy.trace_sq_le_rank_frobenius
