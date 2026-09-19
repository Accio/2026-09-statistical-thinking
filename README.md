Statistical thinking workshop
===
Jitao David Zhang with valuable input from Christian Weinmann, September 2026

## Background

The three-hour workshop aims at helping wet-lab researchers with no mathematical or statistical background become familiar with statistical thinking, and prepare them to ask questions that lead to better experiment design and statistical analysis of data.

## How I created it

I thought about the essential skills of statistical thinking I wish I had learned early in career, and summarized them in a few points. I used ChatGPT and Claude to brainstorm for the workshop, generate synthetic data, simulate examples, and visualize data. I both used agents to criticize and improve the material, and manually curated the output.

## Concept

The workshop builds on one synthetic CellTiter-Glo experiment in primary human hepatocytes. The data are generated so that we have the ground truth and that we can observe the effect of experiment design and statistical analysis.

Files
-----

| File                                                          | What it is                                                                                          |
|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| `2026-09-18-1709-workshop planning - suggestion by openai.md` | goals, modules, and the capabilities participants should leave with                                 |
| `2026-09-workshop-modules.Rmd`                                | **the workshop notebook** : ten modules, one per 15-minute block, each with the simulation it needs |
| `2026-09-statistical-thinking.Rmd`                            | technical appendix
| `R/simulate_workshop_data.R`                                  | data generator behind the workshop notebook                                              |
| `output/workshop/`                                            | per-module CSV exports for participants to take away                                                |

## Rendering

```r
rmarkdown::render("2026-09-workshop-modules.Rmd")   # the workshop
rmarkdown::render("2026-09-statistical-thinking.Rmd")
```

Needs R with `tidyverse`, `broom`, `patchwork`, `ribiosUtils` and `ribiosPlot`.

## The dataset

Eight hepatocyte lots × two compounds × three technical wells, read out at one
concentration over two run days: 48 measurements. Hidden in it are a run-day
effect that lives in the vehicle reference, one well with an air bubble, and
one lot that is genuinely more sensitive than the rest. Each surfaces in the
module where it matters.

The two documents share compounds, day effect and story, but are simulated
separately, so individual numbers differ. The workshop generator deliberately
gives each lot a sensitivity **shared** across both compounds and a wider
lot-to-lot spread — without those, the paired/unpaired contrast in Module 5
has nothing to show.

## The modules

1. What questions are we actually asking, and what is the minimal effect size that we care about?
2. What types of variations are there, and what does one number and several numbers tell us?
3. What is the 'n', i.e. the sample size? What are the differences between technical and biological replications, and what are their uses?
4. What are bias and variance? How to achieve a balance between them?
5. What are blocking and randomization, and why they are important tools for experiment design?
6. What tools do we have to compare two conditions: unpaired t-test, paired t-test, non-parametric test.
7. What do we mean with p values, estimated effect size, and the confidence intervals?
8. How to detect and handle outliers?
9. What is power, how sample size affects power, and how power affects the quality of our decision?
10. How to learn more and/or get help if stuck?

Each module runs story (3 min) → simulation (5 min) → participant task (5 min) → summary (2 min).

## Building everything

```sh
make help       # list targets
make notebook   # participants' notebook  -> 2026-09-workshop-modules.html
make appendix   # technical appendix      -> 2026-09-statistical-thinking.html
make slides     # editable deck           -> output/2026-09-workshop-slides.pptx
make handout    # one-page A4 summary     -> output/2026-09-workshop-one-pager.pdf
make all        # all of the above (about 70 s from clean)
```

Rendering the notebook also writes `output/figures/*.png` and `output/workshop/*.csv`; the deck and the handout are built from those, so `make slides` on a clean checkout renders the notebook first. `make handout` finishes by checking that the PDF really is one page and warns if it is not.

`make clean` removes the deck and the handout; `make distclean` also removes the rendered documents and the generated figures.

Needs `pandoc` and `weasyprint` in addition to R. Both are only used for the deck and the handout — the two documents render with `rmarkdown` alone.

Slide deck and handout
----------------------

| File | What it is |
|---|---|
| `slides/workshop-slides.md` | source of the deck — plain Markdown, edit this |
| `handout/one-pager.md` | source of the A4 summary — agenda and key messages |
| `handout/one-pager.css` | A4 page geometry and typography for the summary |
| `Makefile` | builds all four outputs |

The deck is generated as **PowerPoint**, so it stays editable after the build:
101 slides, the notebook's own figures, and speaker notes with timings. It
reuses `output/figures/` rather than duplicating the plotting code, which is
what keeps the deck and the notebook from drifting apart.

The deck is 4:3, pandoc's default. To restyle it, run `make reference-doc`
once, open `slides/reference.pptx`, set 16:9 and apply your own fonts and
colours. The Makefile picks that file up automatically from then on.

## Conventions

**Donor labels.** Lots are `HH1` to `HH8`. `HH2` carries the air-bubble well
and `HH7` is the genuinely sensitive lot; in the appendix `HH4` is the lot
whose plate fails QC.

**Figures.** Both documents target a width of 7 inches or less with no text
below 12 pt, so that figures stay readable when projected or printed at their
natural size. Each document defines one theme and uses it everywhere; change
the theme rather than individual plots.

**Reproducibility.** Every Monte Carlo chunk sets its own seed, so repeated
renders give identical numbers. This matters because the deck and the handout
quote figures from the notebook — without fixed seeds they would silently
drift out of step with it.
