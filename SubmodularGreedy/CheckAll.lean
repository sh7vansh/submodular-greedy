/-
Copyright (c) 2026 Shivansh Singh. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Shivansh Singh
-/
import SubmodularGreedy.ClosureSystem
import SubmodularGreedy.SearchMetrics
import SubmodularGreedy.AdversarialTrap
import SubmodularGreedy.MatroidExchange
import SubmodularGreedy.SubmodularGreedy

-- Adversarial Trap
#print axioms AdversarialTrap.gen_e_star
#print axioms AdversarialTrap.optimal_e_star
#print axioms AdversarialTrap.searchWork_adv_trap_limit

-- Search Metrics
#print axioms SearchMetrics.searchWork_perfect_alignment
#print axioms SearchMetrics.searchWork_limit

-- Closure System
#print axioms ClosureSystem.novelty_of_fixedPriorityPhi
#print axioms ClosureSystem.novelty_of_adaptiveGreedyPhi
#print axioms ClosureSystem.adaptiveGreedyPhi_max

-- Matroid Exchange
#print axioms MatroidExchange.matroid_maclane
#print axioms MatroidExchange.matroid_indep_iff_isIndependent
#print axioms MatroidExchange.matroid_sieve_output_isGreedy
#print axioms MatroidExchange.matroid_optimality_bound_of_isGreedy
#print axioms MatroidExchange.matroid_optimality_bound
#print axioms MatroidExchange.matroid_adaptiveGreedy_optimality
#print axioms MatroidExchange.matroid_fixedPriority_optimality

-- Submodular Greedy Bounds and Sequences
#print axioms SubmodularGreedy.advCl_max_marginal_gain
#print axioms SubmodularGreedy.advCl_opt_size
#print axioms SubmodularGreedy.B_seq_zero
#print axioms SubmodularGreedy.B_seq_add_one
#print axioms SubmodularGreedy.B_seq_nat_eq
#print axioms SubmodularGreedy.B_nat_subset_sieve_output
#print axioms SubmodularGreedy.one_le_log_plus_one
#print axioms SubmodularGreedy.bound_of_le
#print axioms SubmodularGreedy.opt_empty_of_card_zero
#print axioms SubmodularGreedy.B_seq_empty_of_cl_empty
#print axioms SubmodularGreedy.sieve_output_empty_of_cl_empty
#print axioms SubmodularGreedy.greedy_empty_of_opt_zero
#print axioms SubmodularGreedy.closureRank_univ_of_gen
#print axioms SubmodularGreedy.closureRank_mono
#print axioms SubmodularGreedy.cl_union_eq_cl_cl_union
#print axioms SubmodularGreedy.closureRank_union_eq
#print axioms SubmodularGreedy.closureRank_cl_eq
#print axioms SubmodularGreedy.submodular_finset_le
#print axioms SubmodularGreedy.sum_le_card_mul
#print axioms SubmodularGreedy.deficit_zero_le
#print axioms SubmodularGreedy.div_sub_le_log_sub
#print axioms SubmodularGreedy.sum_log_telescope
#print axioms SubmodularGreedy.analytic_greedy_bound_m
#print axioms SubmodularGreedy.greedyDeficit_zero
#print axioms SubmodularGreedy.greedyDeficit_zero_le
#print axioms SubmodularGreedy.greedyDeficit_zero_pos
#print axioms SubmodularGreedy.B_nat_subset_succ
#print axioms SubmodularGreedy.B_nat_card_le
#print axioms SubmodularGreedy.B_nat_succ_of_cl_univ
#print axioms SubmodularGreedy.adaptiveGreedy_gain_ge
#print axioms SubmodularGreedy.each_opt_gain_le
#print axioms SubmodularGreedy.sum_opt_gain_le
#print axioms SubmodularGreedy.submodular_opt_step_le
#print axioms SubmodularGreedy.B_nat_monotone
#print axioms SubmodularGreedy.B_nat_eventually_stabilizes
#print axioms SubmodularGreedy.B_nat_strict_mono
#print axioms SubmodularGreedy.B_nat_stabilizes_add
#print axioms SubmodularGreedy.B_nat_stabilizes
#print axioms SubmodularGreedy.B_seq_eq_B_nat
#print axioms SubmodularGreedy.sieve_output_eq_B_nat_termination
#print axioms SubmodularGreedy.B_nat_card_eq_of_lt
#print axioms SubmodularGreedy.greedy_card_eq_terminationIndex
#print axioms SubmodularGreedy.closureRank_step_ge_one
#print axioms SubmodularGreedy.closureRank_diff_ge
#print axioms SubmodularGreedy.div_le_div_of_mul_le
#print axioms SubmodularGreedy.B_nat_termination_cl_univ
#print axioms SubmodularGreedy.sieve_output_isGeneratingSet
#print axioms SubmodularGreedy.adaptiveGreedy_isGeneratingSet
#print axioms SubmodularGreedy.greedyDeficit_mono
#print axioms SubmodularGreedy.greedyDeficit_pos
#print axioms SubmodularGreedy.greedyDeficit_ukm
#print axioms SubmodularGreedy.greedyDeficit_step_le
#print axioms SubmodularGreedy.greedy_submodular_bound
#print axioms SubmodularGreedy.B_nat_step
#print axioms SubmodularGreedy.B_nat_card_and_not_mem
#print axioms SubmodularGreedy.advCl_greedy_size_worst_case
#print axioms SubmodularGreedy.log_bound_fails
#print axioms SubmodularGreedy.fixed_priority_violates_submodular_bound
#print axioms SubmodularGreedy.randomized_expected_bound

