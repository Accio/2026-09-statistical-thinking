---
title: "Statistical thinking: a workshop for experimental scientists"
subtitle: "Nine questions to ask before you trust an analysis"
author: "Jitao David Zhang and Christian Weinmann"
date: "September 2026"
---

# Before we start

## What this workshop is for

By the end of today you should be able to say:

> **"I know what questions to ask before trusting or performing an analysis."**

Not: which test to memorise.

::: notes
3 min. This is not a statistics course. It is a course about asking better
questions about experiments.
:::

## The recurring loop

**Question → Design → Data → Analysis and uncertainty → Decision**

- the loop runs in that order
- statistics enters at step four
- by then, most of the answer is already fixed

## One dataset, all day

CellTiter-Glo viability in primary human hepatocytes. Synthetic, so the true
answer is known and every claim today can be checked.

| | |
|---|---|
| Independent units | 8 hepatocyte lots (HH1–HH8) |
| Conditions | CPD-A and CPD-B, both in every lot |
| Technical replicates | 3 wells per lot and compound |
| Readout | 22.4 µM, one point on the curve |
| Run days | Friday and Monday |
| **Total** | **48 measurements** |

## Three things are hidden in it

- a **run-day effect** that lives in the vehicle reference
- one well with an **air bubble**
- one lot that is **genuinely more sensitive** than the rest

Each surfaces in the module where it matters.

::: notes
Do not reveal which lot or which well yet. Modules IV and VI depend on it.
:::

# Module I — What are we asking, and what difference matters?

## The question

> **What questions are we asking, and what is the minimal difference that we
> care about?**

"Run the assay and tell me if it's significant" cannot be carried out.

- Measurements **of what**? From **whom**? Under **which conditions**?
- What **population** do we want to speak about?
- What **decision** does this inform?

## The sentence every experiment should complete

> I want to compare **viability at 22.4 µM** in **primary human hepatocyte
> lots** because I need to decide **whether CPD-B is materially less cytotoxic
> than CPD-A**.

The team fixes the threshold **before** seeing data: a **3-fold shift in the
cytotoxicity IC₅₀** is what they would act on.

Not *potency* — that is defined against a target. This assay only says how much
compound it takes to kill cells.

## Two scales: what we measure, what we decide on

![](output/figures/m1-threshold-1.png){height=4.4in}

## Why we decide on the IC₅₀ scale

- **what the instrument reports** — viability at one concentration, in
  percentage points
- **what the project decides on** — the concentration that kills half the
  cells, compared as a **fold shift**

On the IC₅₀ scale the rule is **one number, 3-fold, the same for every lot**.
In percentage points it is not one number at all — 15 to 39 pp across these
eight lots, because the same shift shows a smaller gap near either end of the
curve.

We report both. From Module III on, the **comparison** is made on the IC₅₀
scale, where the effect is additive.

## Conclusion

**We follow the order question, threshold, experiment, statistics — not the
reverse.** And the threshold belongs on the scale the decision is made on.

Statistics cannot rescue an experiment whose question was never defined.

> **Over to you.** Think of one of your own experiments or assays where this
> applies. What questions does it raise? Would it change what you do?

# Module II — What types of variation are there?

## The question

> **What types of variation are there?**

Six numbers come off the plate reader for the first lot. What can be said?

## Show the points, not a bar

![](output/figures/m2-dots-1.png){height=4.4in}

## Nothing changes but the answer

![](output/figures/m2-mean-moves-1.png){height=4.4in}

::: notes
The truth is a fixed line. Every repeat lands somewhere else. Sampling
uncertainty, introduced without an equation.
:::

## Variation is not one thing

![](output/figures/m2-taxonomy-1.png){height=4.4in}

## Bias and variance

![](output/figures/m2-target-1.png){height=4.4in}

## Conclusion

**Usually we care about biological and compound-induced variation. Technical
variation sometimes needs to be minimized. We need a balance between variation
and bias.**

Variation is not a sign of a bad experiment.

> **Over to you.** Name one source of variability in your own assay. Is it
> wanted, unavoidable, controllable, or confounding?

# Module III — Biological and technical replicates

## The question

> **What are biological and technical replicates, and what are their uses?**

48 numbers are on the table. What is *n*? 48? 16? 8?

- **Technical replicate** — tells you about the *measurement*
- **Biological replicate** — tells you about the *population*

Three wells from one lot are not three lots.

## Counting wells manufactures confidence

![](output/figures/m3-pseudo-fig-1.png){height=4.2in}

## Same estimate, and the wrong answer

Identical estimate, *p* about **15,000× smaller**, no new information about
lots — and the verdict is wrong.

| Analyzed as | Estimate | 95% CI | *p* | Verdict |
|---|---|---|---|---|
| 48 wells, as if independent | 4.82× | 2.86 – 8.13 | 3×10⁻⁷ | **inconclusive** |
| 8 lots, correctly | 4.82× | 1.83 – 12.7 | 0.004 | inconclusive |
| *(paired, Module V)* | *4.82×* | *3.11 – 7.47* | *6×10⁻⁵* | ***act*** |

::: notes
The smallest p-value on the page, and the wrong verdict. Two errors on top of
each other: counting wells narrows the interval, ignoring the pairing widens
it. The interval is not entitled to whatever width it happens to have.
:::

## Twelve measurements, two ways to spend them

![](output/figures/m3-designs-1.png){height=4.2in}

## Conclusion

**Which of them counts as the independent unit depends on the question, and
that choice sets the level at which the data must be analyzed.**

The smallest *p*-value on the page came with the wrong verdict.

> **Over to you.** In your last experiment, what was the independent unit? Was
> the *n* you reported the number of units, or of measurements?

# Module IV — Randomization and blocking

## The question

> **What are randomization and blocking, and why are they important for
> experimental design?**

Sixteen plates cannot run in one sitting. The scheduler runs all CPD-A on
Friday, all CPD-B on Monday.

On Friday the vehicle wells read about **20% higher** — and viability is
expressed relative to each plate's own vehicle.

## The day effect is visible without any compound data

![](output/figures/m4-vehicle-1.png){height=4.2in}

## The only difference is which day each plate ran

![](output/figures/m4-designs-1.png){height=4.2in}

## Two compounds that are identical by construction

![](output/figures/m4-null-fig-1.png){height=4.0in}

::: notes
Let this sit. A statistically significant 1.25-fold shift (p = 0.012) between
two compounds that are the same compound. Perfectly reproducible, and entirely an
artifact of the schedule.
:::

## Block what you can, randomize the rest

Day and compound were the **same column**. No analysis can unmix that.

| Lever | Use it for | Failure mode |
|---|---|---|
| **Block** | day, plate, operator | blocking on something that tracks treatment does nothing |
| **Randomize** | anything you cannot block | small experiments still randomize into imbalance |
| **Standardize** | same pipette, one consumable lot | standardizing *per arm* manufactures bias |

## Conclusion

**Test both A and B within each batch, rather than A in one batch and B in the
other. Block what you can, and randomize the rest.**

> **Over to you.** Which factors in your own assay could you block? Which would
> you have to randomize?

# Module V — How do we compare two groups?

## The question

> **How do we compare two groups?**

We are interested in the population; we only have samples and their
measurements.

## The way this comparison is usually drawn

![](output/figures/m5-clouds-1.png){height=4.2in}

## Four tests, one dataset

![](output/figures/m5-tests-fig-1.png){height=4.2in}

::: notes
Read the colours, not the p-values. Every test finds a difference. They do not
agree on whether it clears the threshold we committed to in Module I.
:::

## Ignoring the pairing cost the decision

- pairing is a property of the **design**, fixed before the data exist
- **Welch** as the unpaired default: protection when you need it, nothing when
  you do not
- **Wilcoxon** on 8 pairs cannot return *p* below 1/128 ≈ 0.008, whatever the
  data look like
- unpaired 1.8 – 12.7-fold, **inconclusive**; paired 3.1 – 7.5-fold, **act**

**Beyond two groups:** ANOVA for more than two groups, linear regression to
adjust for covariates — the same questions still have to be answered first.

## Conclusion

**Commonly used tools include the unpaired t-test, the paired t-test, and
non-parametric tests.** The test follows the design.

> **Over to you.** Find an experiment of your own where the samples are paired.
> Was it analyzed that way?

# Module VI — How do we detect and handle outliers?

## The question

> **How do we detect and handle outliers?**

Two values look wrong. They are not the same kind of thing.

## All 48 wells

![](output/figures/m6-candidates-1.png){height=4.2in}

## One is an artifact, one is biology

**Candidate 1 — a single well.** The notebook says *"air bubble observed;
pipette felt strange"*. Documented, technical, recorded before the result was
seen. The other two wells of that condition agree.

**Candidate 2 — a whole lot.** More sensitive to **both** compounds, IC₅₀
about 3-fold lower, nothing abnormal in the QC record.

> Grubbs' test flags the second one. Grubbs asks whether a value is
> **improbable** — never whether it is **wrong**.

## A workflow, not a test

1. **Verify** — transcription, instrument, pipetting, sample identity
2. **Investigate** — is there an experimental explanation?
3. **Apply pre-defined rules** — fixed before the result was seen?
4. **Do not delete because it is inconvenient**
5. **Run a sensitivity analysis** — does the conclusion change?
6. **Document** — report what was excluded and why

## Step 5, done

![](output/figures/m6-sensitivity-fig-1.png){height=4.0in}

::: notes
The documented exclusion (air-bubble well) changes nothing. The unjustified
one (the sensitive lot) widens the interval past the 3-fold line and the
verdict falls back to inconclusive.
:::

## Conclusion

**Use common sense, experience, and prior knowledge to judge. State the reasons
explicitly, and in case of doubt run the analysis with and without.**

Implausible *given the controls* is a QC exclusion. Inconvenient *given the
hypothesis* is data manipulation.

> **Over to you.** Think of a value you or a colleague once excluded. Which
> step justified it? Was the criterion written down beforehand?

# Module VII — P-values, effect sizes and confidence intervals

## The question

> **What do we mean by p-values, effect sizes, and confidence intervals?**

Assume the two compounds are **identical**. Run the whole study 2,000 times in
that imaginary world.

## What "no difference" looks like

![](output/figures/m7-null-1.png){height=4.2in}

## What a p-value is **not**

The left panel *is* the p-value: the fraction of studies in a no-difference
world that would produce a difference at least as extreme as ours.

It is **not**:

- the probability that the compounds are identical
- the probability that the result happened by chance
- the probability that the experiment will replicate
- anything at all about the **size** of the effect

## "95% confidence" is a statement about the procedure

![](output/figures/m7-coverage-1.png){height=4.2in}

## Read the interval against the threshold, not against zero

![](output/figures/m7-three-1.png){height=4.0in}

::: notes
B is the interesting one: precise, unambiguous, significant, and far too small
to matter.
:::

## Conclusion

**The p-value tells you whether there might be a difference, not how large it
is — effect size matters. A confidence interval is an educated guess at the
range of the effect size.**

Three conclusions, not two: **relevant · not relevant · inconclusive**.

> **Over to you.** The last p-value you showed in a talk — could you still state
> the effect size and its interval?

# Module VIII — What is power, and how does it affect our decision?

## The question

> **What is power, and how does it affect the quality of our decision?**

The same true 5-fold difference, the same assay, the same noise. Only the
number of lots changes.

## Two kinds of power

![](output/figures/m8-power-fig-1.png){height=4.2in}

## Getting a small *p* is easier than answering the question

Power is not a property of an assay. It is a property of an assay **plus a
hypothesised effect size**.

| Lots | *p* < 0.05 | CI clears 3-fold |
|---|---|---|
| 2 | 54% | **19%** |
| 3 | 99% | **52%** |
| 4 | 100% | 81% |
| 6 | 100% | 97% |
| 12 | 100% | 100% |

## Underpowered studies do not just fail — they mislead

![](output/figures/m8-exaggeration-fig-1.png){height=4.0in}

## Where to spend 24 wells

![](output/figures/m8-allocation-1.png){height=4.0in}

::: notes
3 lots x 8 wells: 68% decisive. 8 lots x 3 wells: 99%. The uncertainty that
matters is lot-to-lot, and no number of wells fixes it.
:::

## Conclusion

**Once we define a threshold, the sample size determines the power: the
probability of detecting a difference of at least that size when one exists.**

Too few samples may not allow us to detect subtle differences.

> **Over to you.** Would you act on these data? What would you run next, and how
> many **lots** would it need?

# What we have learned

## The same 48 numbers, four ways

| Analysis | Estimate | 95% CI | Conclusion | Earned? |
|---|---|---|---|---|
| Count wells, ignore lots | 4.82× | 2.86 – 8.13 | inconclusive | **no** — not entitled to its width |
| Confounded schedule | 5.86× | — | no interval possible | **no** — contains the day effect |
| Lots, pairing ignored | 4.82× | 1.83 – 12.7 | inconclusive | yes |
| **Lots, paired, blocked** | **4.82×** | **3.11 – 7.47** | **act** | **yes** |

## Only the last row is entitled to be right

Row 1 produced the **smallest *p*-value on the page** — 3×10⁻⁷ — and still
reached the wrong verdict, because the same analysis also ignored the pairing.

A very small *p*-value is not evidence that the analysis was the right one.
Here it is evidence of the opposite.

Row 2 has no interval at all. That is not a missing number; it is the design
telling you the question cannot be answered from these data.

::: notes
The closing argument. The arithmetic always runs. It never tells you which row
you are in.
:::

## Three things worth remembering

- Good design **minimizes unnecessary variation** while maximizing the chance
  of detecting what you care about
- Design and analysis **reduce uncertainty; they never remove it**
- The decision is **scientific**: effect size, threshold and context live
  outside statistics

## The one-line version

> To answer *"which statistical test should I use?"*
>
> you first have to answer *"how were the data generated?"*

# Module IX — How can I learn more and get help?

## The question

> **How can I learn more and get help if I am stuck?**

Start with the prompt you would actually type.

## The usual prompt

> *"Compare columns A and B statistically."*

An LLM will answer. It will pick a test, report a *p*-value, and sound
confident.

It cannot know whether the columns are paired, whether rows are wells or lots,
whether the groups ran on different days, or what difference you would act on.

On this dataset, that is the analysis that gets the wrong answer twice over.

## The same request, with the design in it

> *"These measurements come from eight independent human hepatocyte lots. Each
> lot was tested with both compounds, three technical wells per lot and
> compound. The independent unit is the lot, not the well. Plates ran over two
> days; day is balanced across compounds. A shift in the cytotoxicity IC₅₀
> below 3-fold would not change our decision.*
>
> *Help me visualize the data so the pairing is visible, estimate the difference
> with its uncertainty, and compare that interval with our threshold. Before
> you recommend a test, tell me what you think the independent unit is and
> whether the comparison is paired."*

## Every fact in that prompt is a design fact

And every one was decided **before** any data existed.

The last sentence is the habit worth keeping: **ask the model to state its
assumptions about the unit and the pairing before it computes anything** — so
you catch a wrong assumption while it is still cheap.

The same applies to a colleague, a statistician, or your own notebook six
months from now.

## Reading

- Krzywinski & Altman, *Points of Significance*, Nature Methods (2013–2015)
- Lazic, *Experimental Design for Laboratory Biologists* (2016)
- Amrhein, Greenland & McShane, *Retire statistical significance*, Nature (2019)
- The ARRIVE and *Nature* reporting checklists

## Conclusion

**We will recommend resources, share useful prompts for AI, and offer to
consult with you.**

Most statistical problems that reach a statistician are design problems that
arrived too late. The conversation is much shorter, and much happier,
**before** the experiment.

> Every module's data is in `output/workshop/` as plain CSV — open it in Excel,
> Prism, R or Python.
