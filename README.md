# Sharp Adaptivity Gaps for Noisy Spectral Testing

SMC · Beihang University · November 23, 2026

[Read the preprint (PDF)](spectral-testing-github-20261123/spectral-testing.pdf)

## Overview

Can adaptive measurements detect a positive eigenvalue more efficiently than measurements chosen in advance?

We study testing whether an unknown symmetric matrix has a positive eigenvalue using noisy scalar measurements.

Our results establish matching sample-complexity bounds:

| Measurement design | Sample complexity |
|---|---|
| Adaptive | $\Theta(m^2\log m/\gamma^2)$ |
| Nonadaptive | $\Theta(m^3/\gamma^2)$ |

Here, $m$ is the matrix dimension and $\gamma$ is the eigenvalue separation margin. These bounds hold at fixed error probability.

**Key results:**

- Adaptivity reduces the required number of measurements by a factor of order $m/\log m$.
- Positive and negative answers have different confidence costs.
- Achieving a polynomial improvement over nonadaptive measurements requires at least order $\log m$ measurement batches.

## Reproducing the Paper

The repository includes the manuscript, LaTeX source, figures, and a Lean supplement.

- [Paper (PDF)](spectral-testing-github-20261123/spectral-testing.pdf)
- [LaTeX source](spectral-testing-github-20261123/spectral-testing.tex)
- [Figure (PDF)](spectral-testing-github-20261123/figures/confidence.pdf)
- [Figure generation (Python)](spectral-testing-github-20261123/figures/confidence.py)
- [Lean supplement](spectral-testing-github-20261123/lean/MatrixEnergy.lean)
- [Lean verification output](spectral-testing-github-20261123/lean/verification.txt)

To compile the manuscript:

```bash
cd spectral-testing-github-20261123
tectonic spectral-testing.tex
```

To build the Lean supplement:

```bash
cd spectral-testing-github-20261123/lean
lake update
lake exe cache get
lake build
```

## Citation and Feedback

If you use this work in your research, please:

1. Cite the original work using the repository's **Cite this repository** feature.
2. Share your research or feedback through GitHub Issues.
3. Consider starring this repository to support the research.

Academic discussions and collaborations are welcome.

---

The manuscript and proof development received AI assistance.
