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
