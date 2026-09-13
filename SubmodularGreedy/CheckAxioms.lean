/-
Copyright (c) 2026 Shivansh Singh. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Shivansh Singh
-/
import SubmodularGreedy.SubmodularGreedy
import SubmodularGreedy.MatroidExchange
import SubmodularGreedy.AdversarialTrap

-- Core greedy submodular approximation theorem
#print axioms SubmodularGreedy.greedy_submodular_bound

-- Core matroid optimality bound under Mac Lane-Steinitz exchange
#print axioms MatroidExchange.matroid_optimality_bound

-- Core adversarial trap lower bound
#print axioms SubmodularGreedy.fixed_priority_violates_submodular_bound

-- Core asymptotic search work limit
#print axioms AdversarialTrap.searchWork_adv_trap_limit
