# dasw — Data Analysis and Statistics Workshop library

The shared, reusable MATLAB namespace (`dasw`) for the Data Analysis and
Statistics Workshop. These are general-purpose functions that know **nothing**
about any particular study: you hand them data, they hand back results. Course
labs and team projects consume this library rather than each carrying their own
copy.

This repository is the single source of truth for `dasw`. It replaces the
per-lab copies of `+dasw/` that were previously duplicated across lab folders.

## Using it

A MATLAB namespace function is found by having the **parent** of the `+dasw`
folder on the path — so put the **repository root** on the path, never the
`+dasw` folder itself:

```matlab
addpath('/path/to/dasw');   % the folder that contains +dasw
[X, Y] = dasw.plot.cumhist(mydata);
```

## Versioning: pin a release

`dasw` is released as a tag per course unit. Each tag is the **cumulative**
snapshot of every function taught through that point, so a project can depend on
exactly the functions that exist at that stage of the course:

| Tag | Contents |
|-----|----------|
| `unit1` | Foundations (descriptive stats, plotting, inference helpers) |
| `unit2` | + fits and indexes |
| `unit3` | + time series *(pending new functions)* |
| `unit4` | + image processing *(pending new functions)* |
| `unit5` | + high-dimensional data |

Pin a project to a tag (e.g. as a submodule or a setup-script clone) so a clean
checkout always resolves the same `dasw`. See the textbook's
`2026/team_projects/pipeline_principles.md` for the full rationale.

## Layout

```
+dasw/
  +plot/    plotting helpers
  +stats/   statistics and data generation
  +math/    linear-algebra helpers
  +tumor/   (see note below)
tests/
  +dasw/    unit tests, mirroring the namespace under test
.github/workflows/tests.yml   runs the tests in CI on every push
```

Tests mirror the namespace: the test for `dasw.math.rot2d` lives at
`tests/+dasw/+math/rot2dTest.m`. Run them locally with:

```matlab
addpath(pwd);   % repo root, so dasw.* resolves
runtests("tests", IncludeSubfolders=true)
```

## Function catalog

### `dasw.plot`
| Function | Summary |
|----------|---------|
| `cumhist(data)` | `[X,Y]` for a cumulative histogram (percent ≤ X) |
| `histbins(data, edges)` | `[N, centers]` histogram counts for custom bin edges |
| `autohistogram(data)` | `[counts, centers]` with Freedman–Diaconis bin widths |
| `scatterplot(X, ...)` | scatter plot; pairwise subplots for >2 columns |
| `supersubplot(fig, m, n, p)` | subplot axes arranged across multiple figures |
| `linear_transform_explorer(LT, ...)` | animate a 2-D linear transformation |
| `displaydrugvsplacebo(mode, d1, d2)` | display helper for the `drugvsplacebo` demo |

### `dasw.stats`
| Function | Summary |
|----------|---------|
| `generate_random_data(N, dist, ...)` | draw `N` samples from a distribution (via `icdf`) |
| `ks2_cdf(n1, n2, d)` | CDF of the two-sample Kolmogorov–Smirnov statistic |
| `simulate_random_sampling(true_d, N, M)` | simulate `M` sampling experiments of size `N` |
| `drugvsplacebo(mode)` | interactive "guess drug vs. placebo" teaching demo |

### `dasw.math`
| Function | Summary |
|----------|---------|
| `rot2d(theta)` | 2-D rotation matrix |
| `refl2d(theta)` | 2-D reflection matrix |
| `rot3d(theta, axis)` | 3-D rotation matrix about axis 1, 2, or 3 |

### `dasw.tumor`
> **Note:** these functions are specific to the tumor-study lab, so by the
> reusable-layer principle ("`dasw` knows nothing about the study") they do not
> really belong in the shared library — they are candidates to move into a
> project namespace. Harvested here as-is for now; see the tracking issue.

| Function | Summary |
|----------|---------|
| `tumorfit(tumordata, reps)` | fit `Y = a + b*exp(c*x^d)`; return change and rate |
| `tumorplot(data, a, b, c, d)` | plot tumor data with its fit |
| `analyze_tumors(folder, condition)` | fit every `tumor_data.txt` under a folder → table |
| `analyze_tumors_plot(folder, condition, plotit)` | as above, plotting each fit |

## Notes

- **CI licensing:** the test workflow uses `matlab-actions`. Public repositories
  get MathWorks-hosted licensing automatically; a private repository needs an
  `MLM_LICENSE_TOKEN` secret configured.
- **Test coverage:** the deterministic helpers (`dasw.math.*`,
  `dasw.plot.histbins`) have unit tests. Plotting and interactive/demo functions
  are harvested without behavioral tests for now.
