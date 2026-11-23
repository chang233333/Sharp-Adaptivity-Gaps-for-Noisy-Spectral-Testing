# Sharp Adaptivity Gaps for Noisy Spectral Testing

SMC · Beihang University · November 23, 2026

[Read the preprint (PDF)](spectral-testing.pdf)

Can feedback help detect a single direction of positive curvature in an unknown symmetric matrix? Each measurement returns one noisy scalar, and the largest eigenvalue is separated from zero by a margin $\gamma$. At fixed error, a test that chooses its next measurement from earlier answers needs $\Theta(m^2\log m/\gamma^2)$ measurements in dimension $m$. A test that fixes all directions in advance needs $\Theta(m^3/\gamma^2)$. The paper gives matching bounds across confidence levels. Once the test finds a direction of positive curvature, it can certify a positive answer with repeated measurements along that direction. Certifying a negative answer has a higher minimax cost. Any polynomial saving over fixed designs requires at least order $\log m$ batches of measurements.

## Reproducing the paper

Run `tectonic spectral-testing.tex` in this directory to build the PDF from the [LaTeX source](spectral-testing.tex). The [figure](figures/confidence.pdf) plots the ratio of the two theoretical rates. Its [Python source](figures/confidence.py) is included.

## Lean supplement

[MatrixEnergy.lean](lean/MatrixEnergy.lean) proves the trace inequality $|\operatorname{tr} Q|^2 \leq \operatorname{rank}(Q)\,\|Q\|_{\mathrm F}^2$ appearing in the confidence lower bound. The probabilistic arguments for the main theorems appear in the paper. The supplement includes a pinned Lean and mathlib configuration and the [archived verification output](lean/verification.txt). With Lean's toolchain manager installed, run

```sh
cd lean
lake update
lake exe cache get
lake build
```

The manuscript and proof development received AI assistance.
