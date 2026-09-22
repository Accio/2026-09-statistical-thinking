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
make tools      # show the R, pandoc and PDF engine picked up on this machine
make notebook   # participants' notebook  -> 2026-09-workshop-modules.html
make appendix   # technical appendix      -> 2026-09-statistical-thinking.html
make slides     # editable deck           -> output/2026-09-workshop-slides.pptx
make handout    # one-page A4 summary     -> output/2026-09-workshop-one-pager.pdf
make poster     # A4 poster of questions  -> output/2026-09-workshop-poster.pdf
make survey     # A4 feedback form        -> output/2026-09-workshop-survey.pdf
make all        # all of the above (about 70 s from clean)
```

Rendering the notebook also writes `output/figures/*.png` and `output/workshop/*.csv`; the deck and the handout are built from those, so `make slides` on a clean checkout renders the notebook first. `make handout` finishes by checking that the PDF really is one page and warns if it is not.

`make clean` removes the deck and the handout; `make distclean` also removes the rendered documents and the generated figures.

Needs `pandoc` in addition to R, and something that turns HTML into PDF. Both are only used for the deck and the handout — the two documents render with `rmarkdown` alone.

The Makefile detects the toolchain itself, so the same `make all` works on a laptop and on the HPC; `make tools` prints what it found.

| | laptop | HPC |
|---|---|---|
| R | `Rscript` on the `PATH` | `~/scripts/load-bioinfo-R.bash`, which loads the R module |
| pandoc | `pandoc` on the `PATH` | `module load Pandoc` |
| HTML -> PDF | `weasyprint` | headless Google Chrome, no WeasyPrint needed |

Chrome honours the same `@page` rules in `handout/one-pager.css` as WeasyPrint, so the handout comes out as the same single A4 page either way. Any of the three can be forced, e.g. `make handout PANDOC=/opt/bin/pandoc` or `make handout CHROME=/usr/bin/chromium`.

## Slide deck and handout

| File | What it is |
|---|---|
| `slides/workshop-slides.md` | source of the deck — plain Markdown, edit this |
| `handout/one-pager.md` | source of the A4 summary — agenda and key messages |
| `handout/one-pager.css` | A4 page geometry and typography for the summary |
| `handout/poster.awk` | pulls the poster out of `one-pager.md` — questions only |
| `handout/poster.css` | A4 page geometry and typography for the poster |
| `handout/survey.md` | source of the feedback form — plain text, edit this |
| `handout/survey.awk` | builds the rating rows and write-in rules the form needs |
| `handout/survey.css` | A4 page geometry and typography for the form |
| `Makefile` | builds all six outputs |

The handout is set from one knob: `html { font-size }` in
`handout/one-pager.css`. Every other size is an `em`, so that single value
rescales the whole sheet. It is fitted to leave roughly 12 mm at the foot of
the page, because how full the page looks depends on the font the machine
actually has — Source Sans 3 sets about 5 mm shorter than the Liberation
Sans / Arial fallback you get where Source Sans is not installed. `make
handout` prints the free space it measured and **fails** if the summary ever
spills onto a second page, so raising or lowering that one value is safe to
try on either machine.

The **poster** is the same sheet with the answers taken out: the title, the
opening paragraph, the nine module questions and the closing line, set large
enough to read from a few steps away, with the two 15-minute breaks marked
between modules III/IV and VI/VII. It is not written by hand — `make poster`
extracts it from `handout/one-pager.md` with `handout/poster.awk`, so editing
a question in the handout changes the poster too and the two can never
disagree. The breaks are the one thing the poster adds; which modules they
follow is the `split("III VI", ...)` line at the top of `handout/poster.awk`.
Its typography is tuned the same way, from `html { font-size }` in
`handout/poster.css`, and it gets the same one-page check.

The **survey** is the feedback form to print and hand out at the end. Write it
in `handout/survey.md` as plain text — a question per paragraph, and under a
rating question a line like `Poor    1   2   3   4   5   6   Excellent`, or a
row of underscores where you want space to write. Markdown collapses those
runs of spaces, so `handout/survey.awk` turns each rating line into a row of
tick-boxes and each underscore line into a ruled writing line before pandoc
sees it. Add or reorder questions freely; nothing but the plain text needs
touching. One caveat: because the sheet ends in blank rules, the free-space
figure `make survey` prints is measured to the last piece of *text* and reads
about 25 mm high — the real headroom is about 7 mm.

The deck is generated as **PowerPoint**, so it stays editable after the build:
101 slides, the notebook's own figures, and speaker notes with timings. It
reuses `output/figures/` rather than duplicating the plotting code, which is
what keeps the deck and the notebook from drifting apart.

The deck is 16:9 (10 x 5.625 in), pandoc's default. To restyle it, run
`make reference-doc` once, open `slides/reference.pptx`, and apply your own
fonts, colours and placeholder sizes. The Makefile picks that file up
automatically from then on.

Figures on slides are scaled to the content placeholder, so a compact,
near-square figure will not fill a 16:9 slide edge to edge. That is the cost
of keeping the figures compact in the documents, and it is the right trade:
the type stays large and the figure stays legible.

## Conventions

**Donor labels.** Lots are `HH1` to `HH8`. `HH2` carries the air-bubble well
and `HH7` is the genuinely sensitive lot; in the appendix `HH4` is the lot
whose plate fails QC.

**Figures.** Both documents target a width of 7 inches or less with no text
below 12 pt, so that figures stay readable when projected or printed at their
natural size. They are also drawn compactly: discrete axes use tighter
expansion than the default, boxes and bars are widened into the space that
frees up, tile plots fill their panel, and each canvas is only as large as its
content needs — most figures are 4.4 to 6 inches wide.

Each document defines one theme and uses it everywhere; change the theme
rather than individual plots. Titles and subtitles have to be short enough for
the panel they sit in — at these widths an over-long title on a two-panel
figure will run into its neighbour.

**Reproducibility.** Every Monte Carlo chunk sets its own seed, so repeated
renders give identical numbers. This matters because the deck and the handout
quote figures from the notebook — without fixed seeds they would silently
drift out of step with it.
