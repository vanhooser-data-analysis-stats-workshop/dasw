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
| `unit3` | + time series (`dasw.signal`, `correlogram`) |
| `unit4` | + image processing (`dasw.roi`, `rescale`) |
| `unit5` | + high-dimensional data |

Pin a project to a tag (e.g. as a submodule or a setup-script clone) so a clean
checkout always resolves the same `dasw`. See the textbook's
`2026/team_projects/pipeline_principles.md` for the full rationale.

## Layout

```
+dasw/
  +plot/    plotting helpers
  +stats/   statistics and data generation
  +fit/     curve-fitting helpers
  +neuro/   neuroscience indexes
  +signal/  time-series and signal processing
  +validators/  argument checks for arguments blocks
  +data/    small data-handling helpers (name/value options)
  +tumor/   (see note below)
tests/
  +dasw/+unittest/   unit tests (test classes), mirroring the namespace
demos/
  +dasw/+demo/       graphical demos, mirroring the namespace (not run by CI)
.github/workflows/tests.yml   runs the tests in CI on every push
```

Tests mirror the namespace, one folder per function under a `+unittest`
layer, and are MATLAB test classes (`matlab.unittest.TestCase`): the test for
`dasw.math.rot2d` lives at `tests/+dasw/+unittest/+math/+rot2d/Rot2dTest.m`.
Run them locally with:

```matlab
addpath(pwd);   % repo root, so dasw.* resolves
runtests("tests", IncludeSubfolders=true)
```

Demos are the other half: a test runs unobserved and passes or fails, while a
demo draws a figure so a person can *see* that a function does what its help
says. They mirror the namespace the same way under a `+demo` layer, and each
one's help ends with a **WHAT YOU SHOULD SEE** section. They live outside
`tests/`, so CI never opens their figures. Run one with
`addpath(fullfile(pwd, "demos"))` and then call it by name, e.g.
`dasw.demo.<pkg>.<function>.<demoName>()`. Argument validators
(`dasw.validators`) need tests but not demos.

## Function catalog

### `dasw.plot`
| Function | Summary |
|----------|---------|
| `cumhist(data)` | `[X,Y]` for a cumulative histogram (percent ≤ X) |
| `histbins(data, edges)` | `[N, centers]` histogram counts for custom bin edges |
| `autohistogram(data)` | `[counts, centers]` with Freedman–Diaconis bin widths |
| `supersubplot(fig, m, n, p)` | subplot axes arranged across multiple figures |
| `displaydrugvsplacebo(mode, d1, d2)` | display helper for the `drugvsplacebo` demo |

### `dasw.stats`
| Function | Summary |
|----------|---------|
| `generate_random_data(N, dist, ...)` | draw `N` samples from a distribution (via `icdf`) |
| `ks2_cdf(n1, n2, d)` | CDF of the two-sample Kolmogorov–Smirnov statistic |
| `simulate_random_sampling(true_d, N, M)` | simulate `M` sampling experiments of size `N` |
| `drugvsplacebo(mode)` | interactive "guess drug vs. placebo" teaching demo |
| `roc_analysis(s1, s2)` | receiver-operating-characteristic curve for two samples |
| `power_ttest2(n, d, sigma, alpha, R)` | Monte-Carlo power of a 2-sample t-test |
| `stderr(data)` | standard error of the mean, column-wise |
| `cumulative_hist_diff(s1, s2)` | largest difference between two samples' empirical CDFs (the KS statistic) |
| `correlogram(t1, d1, t2, d2, lags, tol, alpha)` | correlation of two time series at each lag, with significance threshold |
| `plot_lme(lme, tbl, cond, y, subj)` | plot data, fixed-effect means, and per-subject random effects of a fitted `LinearMixedModel` |

### `dasw.fit`
| Function | Summary |
|----------|---------|
| `watchfithappen(x, y, fittype, N)` | animate a fit over its first `N` iterations; return fit, GOF, and SSE per iteration |

### `dasw.neuro`
| Function | Summary |
|----------|---------|
| `orientation_selectivity_index(angles, responses)` | `(R(pref) - R(pref+90))/R(pref)` |
| `orientation_vector_index(angles, responses)` | 1 minus circular variance in orientation space (Ringach et al. 2002) |

### `dasw.signal`
| Function | Summary |
|----------|---------|
| `threshold_crossings(input, threshold)` | indices where the data cross threshold going up |
| `fourier_coefficients(t, signal)` | discrete Fourier `an`, `bn`, `fn` by direct projection |
| `fouriercoeffs(data, si)` | complex Fourier coefficients and frequencies via `fft` |
| `display_fourier_frequencies(t)` | animate the sinusoid at each discrete Fourier frequency |
| `slidingwindowfunc(X, Y, start, step, stop, win, func, zeropad)` | apply a function in a sliding window |
| `filtertransfer(b, a, sr, N, filtfunc)` | measured gain and phase shift of a filter across frequency |

### `dasw.data`
| Function | Summary |
|----------|---------|
| `assign(name1, val1, ...)` | assign name/value pairs as variables in the caller's workspace (option parsing) |
| `struct2namevaluepair(s)` | convert a struct to a `{'name', value, ...}` cell array |

### `dasw.validators`
| Function | Summary |
|----------|---------|
| `mustBeEqualSize(A, B)` | error unless `size(A)` equals `size(B)`; for use in an `arguments` block, e.g. `y (:,1) double {dasw.validators.mustBeEqualSize(x, y)}` (MATLAB has no built-in validator that compares two inputs) |

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
- **Test coverage:** every function has a unit-test class except the
  interactive `dasw.stats.drugvsplacebo` demo and
  `dasw.data.struct2namevaluepair`. Plotting and animating functions are tested
  with hidden figures and `pause` turned off.
- **Toolboxes:** CI installs the Statistics and Machine Learning, Curve
  Fitting, and Image Processing toolboxes; functions that call into them need
  the same toolboxes locally.
