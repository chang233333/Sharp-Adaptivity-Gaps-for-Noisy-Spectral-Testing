"""Plot the ratio of the rate expressions in Theorem 1.1."""
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np


def main():
    t = np.geomspace(np.log(8), 65536, num=650)
    styles = [(4096, "#14395b", "-"), (512, "#ae512b", "--"), (64, "#287664", "-.")]
    with plt.rc_context({"font.family": "DejaVu Serif", "font.size": 9,
                         "mathtext.fontset": "stix", "pdf.fonttype": 42,
                         "axes.spines.right": False, "axes.spines.top": False}):
        fig, ax = plt.subplots(figsize=(5.45, 2.14), layout="constrained")
        for m, color, line in styles:
            ratio = (m + t) / (np.log(m) + t)
            ax.loglog(t, ratio, color=color, linestyle=line, linewidth=1.7,
                      label=rf"$m={m:,}$".replace(",", r"{,}"))
        ax.axhline(1, color="#71777c", linewidth=0.65)
        ax.set(xlabel=r"Log inverse error  $t=\log(1/\delta)$",
               ylabel="Fixed / adaptive rate", xlim=(2, 65536), ylim=(0.87, 700))
        ax.set_yticks([1, 10, 100], labels=["1", "10", "100"])
        ax.tick_params(which="major", length=3)
        ax.tick_params(which="minor", length=1.5)
        ax.legend(frameon=False, loc="upper right", fontsize=8, handlelength=2.7)
        fig.savefig(Path(__file__).with_name("confidence.pdf"),
                    metadata={"Title": "Confidence dependence of the adaptivity gap"})
        plt.close(fig)


if __name__ == "__main__":
    main()
