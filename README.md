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

Rendering
---------

```r
rmarkdown::render("2026-09-workshop-modules.Rmd")   # the workshop
rmarkdown::render("2026-09-statistical-thinking.Rmd")
```

Needs R with `tidyverse`, `broom`, `patchwork`, `ribiosUtils` and `ribiosPlot`.

The dataset
-----------

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

The modules
-----------

1. What question are we actually asking? — and what difference would we act on
2. Variation: what does one number tell us?
3. What is *n*? — technical vs biological replicates, pseudoreplication
4. Design: blocking, randomisation, standardisation
5. Comparing two conditions: paired or unpaired?
6. P-values, effect sizes and confidence intervals
7. Surprising observations
8. Power, sample size and the decision
9. What we have learned
10. Where to go from here — including how to brief an LLM

Each module runs story (3 min) → simulation (5 min) → participant task (5 min)
→ summary (2 min).
