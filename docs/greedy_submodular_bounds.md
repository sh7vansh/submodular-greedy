# Greedy Generator Extraction and Submodular Bounds

This document details the discrete track implemented in [`ClosureSystem.lean`](../SubmodularGreedy/ClosureSystem.lean), [`SearchMetrics.lean`](../SubmodularGreedy/SearchMetrics.lean), [`AdversarialTrap.lean`](../SubmodularGreedy/AdversarialTrap.lean), [`MatroidExchange.lean`](../SubmodularGreedy/MatroidExchange.lean), and [`SubmodularGreedy.lean`](../SubmodularGreedy/SubmodularGreedy.lean).

This document analyzes the performance gap between fixed-priority greedy algorithms (Borodin, Nielsen, and Rackoff 2003) and adaptive greedy algorithms for submodular set cover (Chvátal 1979, Nemhauser et al. 1978).

---

## 1. Closure Spaces and Selection Operators

Let $U$ be a set and let $\mathrm{cl}: \mathcal{P}(U) \to \mathcal{P}(U)$ be a closure operator satisfying extensivity ($X \subseteq \mathrm{cl}(X)$), monotonicity ($X \subseteq Y \implies \mathrm{cl}(X) \subseteq \mathrm{cl}(Y)$), and idempotence ($\mathrm{cl}(\mathrm{cl}(X)) = \mathrm{cl}(X)$).

A subset $S \subseteq U$ is a generating set if $\mathrm{cl}(S) = U$. An optimal generating set $B_{\text{opt}}$ minimizes cardinality $|B_{\text{opt}}|$ among all generating sets.

### Fixed-priority selection

Given a well-order $\prec$ on $U$, the fixed-priority operator selects the minimum available element:

$$\Phi_{\text{fixed}}(C) = \min_{\prec}(U \setminus C)$$

Because the ordering is fixed before execution and does not adapt to closure feedback during runtime, this matches the fixed-priority algorithm model defined by Borodin, Nielsen, and Rackoff (2003).

### Adaptive greedy selection

When $U$ is finite, the adaptive operator selects an element that maximizes marginal rank increase:

$$\Phi_{\text{greedy}}(C) = \arg\max_{x \in U \setminus C} |\mathrm{cl}(C \cup \{x\})|$$

---

## 2. Three Regimes of Generator Extraction

### The matroid regime

In [`MatroidExchange.lean`](../SubmodularGreedy/MatroidExchange.lean), the closure operator satisfies the Mac Lane-Steinitz exchange property:

$$y \in \mathrm{cl}(X \cup \{x\}) \setminus \mathrm{cl}(X) \implies x \in \mathrm{cl}(X \cup \{y\})$$

Under exchange, every independent generating set forms a matroid base. Because all bases in a matroid share equal cardinality, any independent generating set matches the optimal generator size exactly, producing an approximation ratio of 1.

### The adversarial trap

In [`AdversarialTrap.lean`](../SubmodularGreedy/AdversarialTrap.lean) and [`SubmodularGreedy.lean`](../SubmodularGreedy/SubmodularGreedy.lean), we define the non-matroidal closure operator:

$$\mathrm{advCl}(S) = \begin{cases} U & \text{if } e^* \in S \\ S & \text{otherwise} \end{cases}$$

For this operator:
* The optimal generator is $\{e^*\}$, with cardinality $|B_{\text{opt}}| = 1$.
* If a fixed-priority ordering places $e^*$ last, the algorithm selects every element in $U \setminus \{e^*\}$ before finally selecting $e^*$.
* Theorem `SubmodularGreedy.advCl_greedy_size_worst_case` verifies that the algorithm outputs $|B_{\text{greedy}}| = |U|$.

This gives an approximation ratio $|B_{\text{greedy}}| / |B_{\text{opt}}| = |U|$, proving that fixed-priority orderings achieve an $\Omega(|U|)$ worst-case ratio on general closure systems. Theorem `SubmodularGreedy.fixed_priority_violates_submodular_bound` confirms that this strictly exceeds the logarithmic bound for $|U| \ge 3$.

### The submodular regime

In [`SubmodularGreedy.lean`](../SubmodularGreedy/SubmodularGreedy.lean), we assume the closure rank $f(S) = |\mathrm{cl}(S)|$ is submodular:

$$f(A \cup \{x\}) - f(A) \ge f(B \cup \{x\}) - f(B) \quad \text{for } A \subseteq B, \, x \notin B$$

Under adaptive greedy selection, the rank deficit $D_i = |U| - f(B_i)$ contracts at each step. 

Theorem `SubmodularGreedy.submodular_opt_step_le` proves the per-step gain satisfies:
$$D_i - D_{i+1} \ge \frac{D_i}{|B_{\text{opt}}|}$$

Summing over the discrete steps via harmonic series bounds and logarithmic integration yields theorem `SubmodularGreedy.greedy_submodular_bound`:

$$|B_{\text{greedy}}| \le (\ln \Delta + 1) |B_{\text{opt}}|$$

where $\Delta = \max_{x \in U} |\mathrm{cl}(\{x\})|$. This completes the Lean 4 proof of the classical Chvátal (1979) and Nemhauser et al. (1978) set cover bound specialized to closure ranks.

---

## 3. Notes on Randomized Limits

The module contains theorem `SubmodularGreedy.randomized_expected_bound`, which shows that if a rank function satisfies the complement symmetry identity:

$$f(S) + f(S^c) = |U| \quad \text{for all } S \subseteq U$$

then the uniform average of $f(S)$ over all $2^{|U|}$ subsets equals $|U| / 2$. 

This statement is an algebraic symmetry identity over subset complements. It does not model expectation over uniform random permutations of the ground set under Yao's minimax principle, as the adversarial closure $\mathrm{advCl}$ does not satisfy complement symmetry.

---

## 4. References

* Borodin, A., Nielsen, M. N., & Rackoff, C. (2003). Lower bounds for greedy algorithms in graph coloring and set cover. *Journal of Computer and System Sciences*, 67(1), 1-36.
* Chvátal, V. (1979). A greedy heuristic for the set-covering problem. *Mathematics of Operations Research*, 4(3), 233-235.
* Nemhauser, G. L., Wolsey, L. A., & Fisher, M. L. (1978). An analysis of approximations for maximizing submodular set functions. *Mathematical Programming*, 14(1), 265-294.
* Mac Lane, S. (1936). Some interpretations of abstract linear dependence. *Annals of Mathematics*, 37(2), 360-375.
