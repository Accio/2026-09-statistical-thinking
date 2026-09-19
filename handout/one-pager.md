# Statistical thinking for experimental scientists

**A three-hour workshop.** One synthetic CellTiter-Glo experiment — 8 hepatocyte lots × 2 compounds × 3 wells over 2 run days — carries all ten modules, each following the same loop: **Question → Design → Data → Analysis and uncertainty → Decision.**

| | Module | The question it answers | What to take away |
|---|---|---|---|
| **0:00** | **1 · The question** | What are we actually asking, and what difference would we act on? | Statistics cannot rescue an experiment whose question was never defined. Fix the threshold *before* the data, on the scale you measure. |
| **0:15** | **2 · Variation** | What does one number tell us? | Some variation is signal, some is the price of measuring, some is a design choice you still have. |
| **0:30** | **3 · What is *n*?** | Technical or biological replicate? | *n* is the number of **independent units** — analyse at that level. Counting wells manufactures confidence. |
| *0:45* | *Break* | | |
| **1:00** | **4 · Design** | Blocking, randomisation, standardisation | Design decides what statistics can separate later. No analysis can unmix a confounder. |
| **1:15** | **5 · Paired or not** | Are the observations linked by design? | The test follows the design. Pairing is fixed before the data exist, never found by trying both. |
| **1:30** | **6 · Inference** | What do *p*, effect size and CI mean? | The *p*-value answers a narrow question about a world we do not believe in. Decide on the effect and its interval. |
| **1:45** | **7 · Outliers** | Artefact or biology? | Implausible *given the controls* is QC. Inconvenient *given the hypothesis* is manipulation. |
| *2:00* | *Break* | | |
| **2:15** | **8 · Power** | How many, and how good is the decision? | Power needs an effect worth detecting. Significance is easier to reach than a decision. |
| **2:30** | **9 · Review** | What did the design decide for us? | The arithmetic always runs. It never tells you whether it was entitled to. |
| **2:45** | **10 · Next steps** | How to get help, including from an LLM | Every fact that makes a good prompt is a design fact, decided before any data existed. |

::: {.cols}

::: {.box}
## Ten questions to ask before you trust an analysis

1. What exactly is the question, and what difference would matter?
2. What population do I want to generalise to?
3. What is my independent experimental unit?
4. Where can bias enter?
5. Which variation do I block, randomise, or standardise?
6. Does my plot preserve the experimental structure?
7. Have I estimated the effect **and** its uncertainty?
8. Does the test match the design?
9. Have I investigated surprising values rather than deleted them?
10. Am I deciding on effect size and context — not the *p*-value alone?
:::

::: {.box}
## What the dataset shows

| Analysis of the same 48 numbers | 95% CI | Entitled? |
|---|---|---|
| Count wells, ignore lots | 25.0 – 51.4 | **no** — too narrow to believe |
| Confounded schedule | none possible | **no** — contains the day effect |
| Lots, pairing ignored | 13.7 – 62.7 | yes — *inconclusive* |
| **Lots, paired, blocked** | **26.4 – 50.0** | **yes — act** |

Relevance threshold, fixed in advance: **24.3 pp**.

Three conclusions, not two: evidence **for** a relevant difference · evidence **against** one · **inconclusive**. The third is a result worth reporting.
:::

::: {.box}
## Briefing an LLM — or a colleague

> *"Eight independent hepatocyte lots. Each lot tested with both compounds, three technical wells per lot and compound. The independent unit is the **lot**, not the well. Plates ran over two days; day is balanced across compounds. A difference below 24 percentage points would not change our decision. Visualise the data so the pairing is visible, estimate the difference with its uncertainty, and compare that interval with our threshold. **Before recommending a test, tell me what you think the independent unit is and whether the comparison is paired.**"*

The last sentence is the habit: make assumptions visible while they are cheap to correct.
:::

:::

**To answer "which statistical test should I use?", you first have to answer "how were the data generated?"**
