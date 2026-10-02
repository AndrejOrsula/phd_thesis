# [Robot Learning Beyond Earth: Enabling Adaptive Autonomy in Space](https://andrejorsula.github.io/phd_thesis)

> Doctoral thesis of Andrej Orsula (University of Luxembourg, 2025)

- [digital edition](https://andrejorsula.github.io/phd_thesis/thesis_AndrejOrsula.pdf)
- [print edition](https://andrejorsula.github.io/phd_thesis/thesis_AndrejOrsula_print.pdf)

## Abstract

The growing ambition for a sustainable human presence beyond Earth requires autonomous robotic systems capable of reliable operation in extreme and unpredictable conditions. However, developing such autonomy is hindered by the scarcity of extraterrestrial data, the prohibitive cost of hardware testing, and the critical sim-to-real gap. This thesis confronts these obstacles by challenging the conventional pursuit of a singular high-fidelity digital twin. Instead, it proposes a paradigm of diversity over fidelity, where true robotic robustness is achieved not by perfecting one simulation, but by learning to master a massive distribution of scenarios.

To enable such a vision, this work introduces the Space Robotics Bench, a comprehensive open-source simulation framework for robot learning in space that combines scalable parallelization with an integrated procedural engine for the on-demand generation of diverse mission-relevant applications. Building on this foundation, a model-based reinforcement learning methodology is leveraged to acquire robust control policies that can adapt to novel situations.

Experimental validation demonstrates that procedural diversity can support policies for a range of mission-relevant capabilities, extending from planetary landing and traversal on unstructured deformable terrains to high-precision assembly and tool-aware manipulation. These efforts culminate in the successful zero-shot sim-to-real transfer of a learned policy to a physical rover.

Ultimately, this thesis delivers a new paradigm for the development and validation of learning-based autonomy. By contributing a powerful open-source toolkit and a validated methodological blueprint, this work establishes a scalable pathway for developing and verifying the adaptive robotic systems that will be essential for our multiplanetary future.

## Citation

```bibtex
@phdthesis{orsula2025robot,
  author = {Orsula, Andrej},
  title  = {Robot Learning Beyond Earth: Enabling Adaptive Autonomy in Space},
  school = {University of Luxembourg},
  year   = {2025},
  url    = {https://hdl.handle.net/10993/67015},
}
```

## Building

1. Install [Typst](https://typst.app) 0.15.1 and [uv](https://docs.astral.sh/uv).

1. Clone the repository with its template submodule:

   ```bash
   git clone --recurse-submodules --single-branch https://github.com/AndrejOrsula/phd_thesis.git
   cd phd_thesis
   ```

1. Build both editions:

   ```bash
   uv run --no-project --script template/tools/build.py thesis.typ --name thesis_AndrejOrsula --optimize --layout utils/print_layout.sha256
   ```

It writes four files next to `thesis.typ`:

| File | Content |
| ------------------------------------ | ---------------------------------------------- |
| `thesis_AndrejOrsula.pdf` | Digital edition, images at 300 dpi (max 25 MB) |
| `thesis_AndrejOrsula_print.pdf` | Print edition, images at 300 dpi (max 30 MB) |
| `thesis_AndrejOrsula_full.pdf` | Digital edition at full resolution |
| `thesis_AndrejOrsula_print_full.pdf` | Print edition at full resolution |

The editions differ only in layout:

- **Digital:** symmetric margins, no blank pages.
- **Print:** mirrored margins, every chapter opens on a right-hand page.

## Repository layout

Content:

| Path | Content |
| ------------------ | --------------------------------------------------------- |
| `thesis.typ` | Entry point (metadata, front matter and chapter order) |
| `content/` | Chapters, front matter, glossary and list of publications |
| `figures/` | Figures used throughout the thesis |
| `bibliography.bib` | References |

Code and tooling:

| Path | Content |
| ------------ | ------------------------------------------------------ |
| `snippets/` | Code listings included in the text |
| `utils/` | Typst helpers and the Pages site assembly |
| `template/` | Submodule with the thesis template and its build tools |
| `index.html` | Landing page of the published site |
