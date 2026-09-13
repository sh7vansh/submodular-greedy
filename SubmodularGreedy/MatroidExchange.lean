/-
Copyright (c) 2026 Shivansh Singh. All rights reserved.
Authors: Shivansh Singh
-/
import Mathlib.Combinatorics.Matroid.Basic
import Mathlib.Combinatorics.Matroid.Closure
import Mathlib.Data.Set.Finite.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Algebra.Field.Rat
import SubmodularGreedy.ClosureSystem
import SubmodularGreedy.SearchMetrics
import SubmodularGreedy.SubmodularGreedy

/-!
# MatroidExchange

This module implements optimality bounds under the Mac Lane-Steinitz exchange property.
-/


open Matroid ClosureSystem SearchMetrics

namespace MatroidExchange

variable {U : Type}
variable (cl : Set U → Set U)

/-- The Mac Lane-Steinitz exchange property for a closure operator. -/
def MacLaneSteinitz : Prop :=
  ∀ X x y, x ∉ cl X → x ∈ cl (insert y X) → y ∈ cl (insert x X)

/-- A Matroid whose ground set is the entire universe. -/
class UnivMatroid (M : Matroid U) : Prop where
  isUniv : M.E = Set.univ

/-- A universe-spanning Matroid naturally induces a ClosureSystem. -/
instance matroidClosureSystem (M : Matroid U) [UnivMatroid M] :
    ClosureSystem.ClosureSystem M.closure where
  extensive X := by
    have hX : X ⊆ M.E := by rw [UnivMatroid.isUniv]; exact Set.subset_univ X
    exact M.subset_closure X hX
  monotone X Y h := M.closure_subset_closure h
  idempotent X := M.closure_closure X

/-- A Matroid satisfies the Mac Lane-Steinitz exchange property. -/
lemma matroid_maclane (M : Matroid U) : MacLaneSteinitz M.closure := by
  intro X x y hnx hx_iny
  have h_diff : x ∈ M.closure (insert y X) \ M.closure X := ⟨hx_iny, hnx⟩
  have h_exc := M.closure_exchange h_diff
  exact h_exc.1

/-- An independent set in a closure system contains no redundant elements. -/
def IsIndependent (S : Set U) : Prop :=
  ∀ x ∈ S, x ∉ cl (S \ {x})

/-- The greedy Sieve yields a generating set with no redundant elements under any priority. -/
def IsGreedySieveOutput (S : Set U) : Prop :=
  IsGeneratingSet cl S ∧ IsIndependent cl S

lemma isIndependent_of_matroid_indep (M : Matroid U) (h_cl : cl = M.closure)
    (S : Set U) (h_indep : M.Indep S) : IsIndependent cl S := by
  intro x hx
  have h_spec := (Matroid.indep_iff_forall_notMem_closure_sdiff'.mp h_indep).2 x hx
  rw [h_cl]
  exact h_spec

lemma matroid_indep_of_isIndependent (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (S : Set U) (h_indep : IsIndependent cl S) : M.Indep S := by
  rw [Matroid.indep_iff_forall_notMem_closure_sdiff']
  refine ⟨fun x _ => by rw [UnivMatroid.isUniv]; exact Set.mem_univ x, ?_⟩
  intro e he
  have h1 := h_indep e he
  rwa [h_cl] at h1

lemma matroid_indep_iff_isIndependent (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (S : Set U) : M.Indep S ↔ IsIndependent cl S :=
  ⟨isIndependent_of_matroid_indep cl M h_cl S, matroid_indep_of_isIndependent cl M h_cl S⟩

lemma matroid_B_nat_indep (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (phi : DiscoveryOperator U) (h_nov : ∀ (C : Set U) (h : C ⊂ Set.univ), phi C h ∉ C)
    (n : ℕ) : M.Indep (SubmodularGreedy.B_nat cl phi n) := by
  subst h_cl
  induction n with
  | zero =>
    dsimp [SubmodularGreedy.B_nat]
    exact M.empty_indep
  | succ n ih =>
    dsimp [SubmodularGreedy.B_nat]
    split_ifs with h_ss
    · let e := phi (M.closure (SubmodularGreedy.B_nat M.closure phi n)) h_ss
      have he_not_cl : e ∉ M.closure (SubmodularGreedy.B_nat M.closure phi n) :=
        h_nov (M.closure (SubmodularGreedy.B_nat M.closure phi n)) h_ss
      have he_E : e ∈ M.E := by rw [UnivMatroid.isUniv]; exact Set.mem_univ e
      have h_ins : M.Indep (insert e (SubmodularGreedy.B_nat M.closure phi n)) :=
        (ih.insert_indep_iff).2 (Or.inl ⟨he_E, he_not_cl⟩)
      have h_comm : SubmodularGreedy.B_nat M.closure phi n ∪ {e} =
          insert e (SubmodularGreedy.B_nat M.closure phi n) := by
        rw [Set.union_comm]; rfl
      rw [h_comm]
      exact h_ins
    · exact ih

lemma matroid_sieve_output_indep [Fintype U] (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (phi : DiscoveryOperator U) (h_nov : ∀ (C : Set U) (h : C ⊂ Set.univ), phi C h ∉ C) :
    M.Indep (ClosureSystem.sieve_output cl phi) := by
  rw [SubmodularGreedy.sieve_output_eq_B_nat_termination cl phi]
  exact matroid_B_nat_indep cl M h_cl phi h_nov (SubmodularGreedy.terminationIndex cl phi)

/-- The greedy Sieve output is an independent generating set under any novel discovery operator. -/
theorem matroid_sieve_output_isGreedy [Fintype U] (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (phi : DiscoveryOperator U) (h_nov : ∀ (C : Set U) (h : C ⊂ Set.univ), phi C h ∉ C) :
    IsGreedySieveOutput cl (ClosureSystem.sieve_output cl phi) := by
  have instCl : ClosureSystem cl := by
    rw [h_cl]
    infer_instance
  refine ⟨SubmodularGreedy.sieve_output_isGeneratingSet cl phi h_nov, ?_⟩
  apply isIndependent_of_matroid_indep cl M h_cl
  exact matroid_sieve_output_indep cl M h_cl phi h_nov

/-- Matroid Optimality Bound from Abstract Greedy Sieve Output:
If a subset is an independent generating set in a universe-spanning matroid,
its cardinality equals that of any optimal generator. -/
theorem matroid_optimality_bound_of_isGreedy [Fintype U]
    (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (sieve_output : Set U) (h_sieve : IsGreedySieveOutput cl sieve_output)
    (opt : Set U) (h_opt : IsOptimalGenerator cl opt)
    (h_nz : opt.toFinite.toFinset.card ≠ 0) :
    cardinalityBloat cl sieve_output opt h_opt = 1 := by
  have h_subset : ∀ (X : Set U), X ⊆ M.E :=
    fun X => by rw [UnivMatroid.isUniv]; exact Set.subset_univ X
  rcases h_sieve with ⟨h_sieve_gen, h_sieve_indep⟩
  rcases h_opt with ⟨h_opt_gen, h_opt_opt⟩
  have h_sieve_span : M.Spanning sieve_output := by
    rw [Matroid.spanning_iff_closure_eq (h_subset sieve_output), UnivMatroid.isUniv, ← h_cl]
    exact h_sieve_gen
  have h_sieve_indep_matroid : M.Indep sieve_output :=
    (matroid_indep_iff_isIndependent cl M h_cl sieve_output).mpr h_sieve_indep
  have h_sieve_base : M.IsBase sieve_output :=
    Matroid.Indep.isBase_of_spanning h_sieve_indep_matroid h_sieve_span
  have h_opt_span : M.Spanning opt := by
    rw [Matroid.spanning_iff_closure_eq (h_subset opt), UnivMatroid.isUniv, ← h_cl]
    exact h_opt_gen
  obtain ⟨B, hB_base, hB_sub⟩ := Matroid.Spanning.exists_isBase_subset h_opt_span
  have h_B_gen : cl B = Set.univ := by
    have hb_span : M.Spanning B := Matroid.IsBase.spanning hB_base
    rw [Matroid.spanning_iff_closure_eq (h_subset B), UnivMatroid.isUniv] at hb_span
    rwa [h_cl]
  have h_ncard := Matroid.IsBase.ncard_eq_ncard_of_isBase hB_base h_sieve_base
  have e1 : B.ncard = B.toFinite.toFinset.card := Set.ncard_eq_toFinset_card B B.toFinite
  have e2 : sieve_output.ncard = sieve_output.toFinite.toFinset.card :=
    Set.ncard_eq_toFinset_card sieve_output sieve_output.toFinite
  rw [e1, e2] at h_ncard
  have h_card_eq : B.toFinite.toFinset.card = sieve_output.toFinite.toFinset.card := h_ncard
  have h_opt_le_B : opt.toFinite.toFinset.card ≤ B.toFinite.toFinset.card :=
    h_opt_opt B h_B_gen
  have h_B_le_opt : B.toFinite.toFinset.card ≤ opt.toFinite.toFinset.card := by
    apply Finset.card_le_card
    intro x hx
    rw [Set.Finite.mem_toFinset] at hx ⊢
    exact hB_sub hx
  unfold cardinalityBloat
  have h_opt_eq_B : sieve_output.toFinite.toFinset.card = opt.toFinite.toFinset.card := by omega
  rw [h_opt_eq_B]
  have h_nz_Q : (opt.toFinite.toFinset.card : ℚ) ≠ 0 := by exact_mod_cast h_nz
  exact div_self h_nz_Q

/-- Matroid Optimality Bound:
If the closure system has the Mac Lane-Steinitz exchange property,
the greedy Sieve yields a generating set of the exact same cardinality
as the optimal basis (c=1). -/
theorem matroid_optimality_bound [Fintype U]
    (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (sieve_output : Set U) (phi : DiscoveryOperator U)
    (h_nov : ∀ (C : Set U) (h : C ⊂ Set.univ), phi C h ∉ C)
    (h_sieve : sieve_output = ClosureSystem.sieve_output cl phi)
    (opt : Set U) (h_opt : IsOptimalGenerator cl opt)
    (h_nz : opt.toFinite.toFinset.card ≠ 0) :
    cardinalityBloat cl sieve_output opt h_opt = 1 := by
  subst h_sieve
  have h_greedy := matroid_sieve_output_isGreedy cl M h_cl phi h_nov
  exact matroid_optimality_bound_of_isGreedy cl M h_cl (ClosureSystem.sieve_output cl phi) h_greedy opt h_opt h_nz

/-- Matroid Optimality Bound for Adaptive Greedy:
Under Mac Lane-Steinitz exchange, the adaptive greedy algorithm outputs
an optimal generator with approximation ratio 1. -/
theorem matroid_adaptiveGreedy_optimality [Fintype U]
    (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (greedy : Set U)
    (h_greedy : greedy = ClosureSystem.sieve_output cl (ClosureSystem.adaptiveGreedyPhi cl))
    (opt : Set U) (h_opt : IsOptimalGenerator cl opt)
    (h_nz : opt.toFinite.toFinset.card ≠ 0) :
    cardinalityBloat cl greedy opt h_opt = 1 :=
  matroid_optimality_bound cl M h_cl greedy (ClosureSystem.adaptiveGreedyPhi cl)
    (ClosureSystem.novelty_of_adaptiveGreedyPhi cl) h_greedy opt h_opt h_nz

/-- Matroid Optimality Bound for Fixed Priority:
Under Mac Lane-Steinitz exchange, even a static fixed-priority ordering outputs
an optimal generator with approximation ratio 1. -/
theorem matroid_fixedPriority_optimality [Fintype U] [LinearOrder U] [WellFoundedLT U]
    (M : Matroid U) [UnivMatroid M] (h_cl : cl = M.closure)
    (fixed : Set U)
    (h_fixed : fixed = ClosureSystem.sieve_output cl ClosureSystem.fixedPriorityPhi)
    (opt : Set U) (h_opt : IsOptimalGenerator cl opt)
    (h_nz : opt.toFinite.toFinset.card ≠ 0) :
    cardinalityBloat cl fixed opt h_opt = 1 :=
  matroid_optimality_bound cl M h_cl fixed ClosureSystem.fixedPriorityPhi
    (fun C h => ClosureSystem.novelty_of_fixedPriorityPhi C h) h_fixed opt h_opt h_nz

end MatroidExchange
