# Submodular Greedy Bounds in Lean 4

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22736769.svg)](https://doi.org/10.5281/zenodo.22736769)

This library formalizes discrete greedy generator extraction algorithms on finite closure spaces in Lean 4 with Mathlib.

The formalization contains no `sorry` placeholders. Every theorem depends strictly on the standard Lean 4 core axioms (`propext`, `Classical.choice`, and `Quot.sound`).

## 1. Overview

The library formalizes discrete optimization and matroid bounds under closure systems $(U, \mathrm{cl})$:

1. **Greedy Submodular Approximation.** Proves the logarithmic approximation bound for adaptive greedy generator extraction under submodular rank functions, following Chvátal (1979) and Nemhauser, Wolsey, and Fisher (1978). For any submodular closure operator, the adaptive greedy sieve satisfies:
   $$|B_{\text{greedy}}| \le (\ln \Delta + 1) |B_{\text{opt}}|$$
   where $\Delta = \max_{x \in U} |\mathrm{cl}(\{x\})|$ is the maximum single-element marginal gain.
2. **Adversarial Worst-Case Traps.** Formulates the fixed-priority algorithm framework of Borodin, Nielsen, and Rackoff (2003). Proves that static orderings suffer linear bloat $|B| = |U|$ on adversarial closure systems where the optimal basis has size 1, strictly violating the logarithmic bound for $|U| \ge 3$.
3. **Matroid Optimality.** Formalizes the Mac Lane-Steinitz exchange property and proves base cardinality preservation for matroid closure operators.

## 2. Directory Structure

```
submodular-greedy/
├── lakefile.toml
├── lean-toolchain
├── lake-manifest.json
├── LICENSE
├── README.md
├── theorems.txt
├── docs/
│   └── greedy_submodular_bounds.md
├── SubmodularGreedy.lean
└── SubmodularGreedy/
    ├── ClosureSystem.lean
    ├── SearchMetrics.lean
    ├── AdversarialTrap.lean
    ├── MatroidExchange.lean
    ├── SubmodularGreedy.lean
    ├── CheckAxioms.lean
    └── CheckAll.lean
```

## 3. Module Map

| Module | Scope | Primary declarations |
| :--- | :--- | :--- |
| `ClosureSystem.lean` | Closure systems and discovery operators. | `ClosureSystem`, `fixedPriorityPhi`, `adaptiveGreedyPhi`, `sieve_output`. |
| `SearchMetrics.lean` | Optimality metrics and approximation ratios. | `IsGeneratingSet`, `IsOptimalGenerator`, `cardinalityBloat`, `searchWork_limit`. |
| `AdversarialTrap.lean` | Non-matroidal worst-case space. | `advCl`, `optimal_e_star`, `searchWork_adv_trap_limit`. |
| `MatroidExchange.lean` | Mac Lane-Steinitz exchange and base equality. | `MacLaneSteinitz`, `UnivMatroid`, `matroid_maclane`, `matroid_optimality_bound`. |
| `SubmodularGreedy.lean` | Submodular greedy bounds and discrete limits. | `greedyDeficit_step_le`, `greedy_submodular_bound`, `advCl_greedy_size_worst_case`, `fixed_priority_violates_submodular_bound`. |

## 4. Build and Verification

Install elan and the Lean 4 toolchain (`leanprover/lean4:v4.33.1`). Run the verification commands from the project directory:

```bash
# Build the library
lake build

# Run Batteries style and convention linter
lake lint

# Audit the core theorem axioms
lake env lean SubmodularGreedy/CheckAxioms.lean

# Audit full theorem set axioms
lake env lean SubmodularGreedy/CheckAll.lean
```

All audit commands confirm zero external axioms beyond `propext`, `Classical.choice`, and `Quot.sound`.

## 5. References

* Chvátal, V. (1979). A greedy heuristic for the set-covering problem. *Mathematics of Operations Research*, 4(3), 233-235.
* Nemhauser, G. L., Wolsey, L. A., and Fisher, M. L. (1978). An analysis of approximations for maximizing submodular set functions. *Mathematical Programming*, 14(1), 265-294.
* Borodin, A., Nielsen, M. N., and Rackoff, C. (2003). Lower bounds for greedy algorithms in graph coloring and set cover. *Journal of Computer and System Sciences*, 67(1), 1-36.
* Mac Lane, S. (1936). Some interpretations of abstract linear dependence. *Annals of Mathematics*, 37(2), 360-375.

## 6. License

This project is licensed under the Apache License, Version 2.0.
Copyright (c) 2026 Shivansh Singh. See [LICENSE](LICENSE) for details.
