---
title: "Statistical thinking for experimental scientists"
subtitle: "Ten questions to ask before you trust an analysis"
author: "Jitao David Zhang"
date: "September 2026"
---

# Before we start

## What this workshop is for

By the end of today you should be able to say:

> **"I know what questions to ask before trusting or performing an analysis."**

Not: which test to memorise.

::: notes
3 min. Set expectations: this is not a statistics course, it is a course about
asking better questions about experiments. Nobody will be asked to derive
anything.
:::

## The recurring loop

Every module follows the same five steps:

**Question → Design → Data → Analysis and uncertainty → Decision**

- the loop runs in that order
- statistics enters at step four
- by then, most of the answer is already fixed

::: notes
Emphasise: the last three modules cannot repair mistakes made in the first two.
:::

## One dataset, all day

CellTiter-Glo viability in primary human hepatocytes. Two compounds from one
project.

| | |
|---|---|
| Independent units | 8 hepatocyte lots (donors) |
| Conditions | CPD-A and CPD-B, both in every lot |
| Technical replicates | 3 wells per lot and compound |
| Readout | 22.4 µM, one point on the curve |
| Run days | Friday and Monday |
| **Total** | **48 measurements** |

## The data are synthetic

So the true answer is known, and every claim made today can be checked against
it.

## Three things are hidden in it

- a **run-day effect** that lives in the vehicle reference
- one well with an **air bubble**
- one lot that is **genuinely more sensitive** than the rest

Each surfaces in the module where it matters.

::: notes
Do not reveal which lot or which well yet. Modules 4 and 7 depend on the
surprise.
:::

# Module 1 — What question are we asking?

## "Run the assay and tell me if it's significant"

That instruction cannot be carried out.

- Measurements **of what**?
- From **whom or what**?
- Under **which conditions**?
- What **population** do we want to speak about?
- What **decision** does this inform?

## The sentence every experiment should complete

> I want to compare **viability at 22.4 µM** in **primary human hepatocyte
> lots** because I need to decide **whether CPD-B is materially less cytotoxic
> than CPD-A**.

The team fixes the threshold **before** seeing data:
a **3-fold shift in potency** is what they would act on.

## A threshold has to be carried onto the scale you measure

![](output/figures/m1-threshold-1.png){height=4.4in}

## The threshold: 24.3 pp, not 37.8 pp

- the assay reports viability, not potency — so the rule must be translated
- the same potency shift shows a **different** viability gap depending on
  where a lot sits on the curve
- translating at one "typical" lot gives **37.8 pp**
- translating in the **actual lots** gives **24.3 pp**

The naive number would have made the study look like a failure.

## Your turn — 5 minutes

Complete the sentence for one of your own experiments:

> I want to estimate/compare ______ in ______ because I need to decide ______.

Then name the number that would make you act.

## Key message

**Statistics cannot rescue an experiment whose question was never defined.**

The threshold is a scientific decision, fixed before the data, and expressed
on the scale you will actually measure.

# Module 2 — What does one number tell us?

## Six numbers from the first lot

![](output/figures/m2-dots-1.png){height=4.4in}

## The bar chart is not wrong — it is uninformative

It is compatible with almost any underlying data.

Show the points. Always.

## Nothing changes but the answer

![](output/figures/m2-mean-moves-1.png){height=4.4in}

::: notes
The truth is a fixed dashed line. Every repeat lands somewhere else. This is
sampling uncertainty, introduced without a single equation.
:::

## Variation is not one thing

![](output/figures/m2-taxonomy-1.png){height=4.4in}

## Four kinds, four responses

| Kind | Example | What to do |
|---|---|---|
| **Wanted** | the compound effect | measure it |
| **Unavoidable** | well-to-well pipetting | replicate, then average |
| **Controllable** | run day, plate, operator | block it, or standardise it |
| **Confounding** | run day that tracks compound | redesign — cannot be fixed later |

## Bias and variance

![](output/figures/m2-target-1.png){height=4.4in}

## Two scenarios to argue about

**A.** Every control is pipetted with pipette A, every treated sample with
pipette B.

**B.** Every replicate uses a different consumable batch, "to be
representative".

> Which makes it hard to know whether the treatment caused the difference?
> Which makes a real effect harder to detect?

## Your turn — 5 minutes

Name one source of variability in your own assay.

Classify it: **wanted**, **unavoidable**, **controllable**, or
**confounding**.

## Key message

**Variation is not a sign of a bad experiment.**

Some is the signal, some is the price of measuring, some is a design choice
you still have, and some is a design mistake you no longer have.

# Module 3 — What is *n*?

## 48 numbers. What is *n*?

48? 16? 8? Something else?

- **Technical replicate** — tells you about the *measurement*
- **Biological replicate** — tells you about the *population*

Three wells from one lot are not three lots.

Here the independent unit is the **hepatocyte lot**: *n* = 8.

## The same comparison, twice

| Analysed as | Estimate | 95% CI | *p* |
|---|---|---|---|
| 48 wells, treated as independent | 38.2 pp | 25.0 – 51.4 | 5×10⁻⁷ |
| 8 lots, treated as independent | 38.2 pp | 13.7 – 62.7 | 0.005 |

## Same estimate. Very different confidence.

*p* about **9,000× smaller**. Interval about **half as wide**.

## The extra confidence is manufactured

Counting wells adds no information about lots.

**But note:** the pseudoreplicated interval here lands close to the right
answer — by luck, not vindication. Two errors partly cancelled.

An analysis that is wrong for two reasons can still land in a plausible place.
What it cannot do is **tell you** that it has.

::: notes
This is the most important slide in the module. Resist the temptation to make
pseudoreplication look obviously wrong — it usually does not.
:::

## Twelve measurements, two ways to spend them

![](output/figures/m3-designs-1.png){height=4.4in}

## Neither design is better

- **12 lots × 1 well** — estimates lot-to-lot variation well, technical
  variation not at all
- **3 lots × 4 wells** — the opposite, and estimates lot spread from three
  points

They answer different questions. If the question is about hepatocyte lots in
general, spend the measurements on lots.

## Your turn — 5 minutes

In your last experiment: what was the independent unit?

Was the number you reported as *n* the number of **units**, or the number of
**measurements**?

## Key message

***n* is the number of independent units — and the analysis must be done at
that level.**

# Module 4 — Blocking and randomisation

## The scheduler did the natural thing

Sixteen plates cannot run in one sitting. So: all CPD-A on Friday, all CPD-B
on Monday.

Something real happened on Friday: the vehicle wells read about **20% higher**.

Viability is expressed relative to each plate's own vehicle — so a shift in
the *reference* propagates into every value on that plate.

## The day effect is visible without any compound data

![](output/figures/m4-vehicle-1.png){height=4.4in}

## The only difference is which day each plate ran

![](output/figures/m4-designs-1.png){height=4.4in}

## On the real data, confounding does not announce itself

| Schedule | Mean difference | Simulated truth |
|---|---|---|
| Blocked | 38.2 pp | 41.8 pp |
| Confounded | 40.6 pp | 41.8 pp |

## That is exactly the problem

Both land within a few points of the truth. The confounded schedule is not
obviously worse.

**Confounding does not announce itself.**

## So run the experiment that settles it

Make the two compounds **exactly identical**. Change nothing else.

| Schedule | Estimate | 95% CI | *p* |
|---|---|---|---|
| Blocked | 1.9 pp | −2.0 – 5.7 | 0.29 |
| **Confounded** | **4.5 pp** | **0.3 – 8.6** | **0.039** |

::: notes
Let this sit for a moment before clicking on.
:::

## A significant difference between two identical compounds

Significant. Perfectly reproducible. And entirely an artefact of which day the
plates ran.

## Nothing in the data can reveal it

Day and compound are the **same column**. Every CPD-A plate is a Friday plate.

No test, no model and no care in the analysis can separate two factors that
never varied independently.

Blocking does not remove the day effect — it removes the **confounding**.

## The three levers

| Lever | Use it for | Failure mode |
|---|---|---|
| **Block** | day, plate, operator | blocking on something that tracks treatment does nothing |
| **Randomise** | anything you cannot block | small experiments still randomise into imbalance |
| **Standardise** | same pipette, one consumable lot | standardising *per arm* manufactures bias |

## The same word, two opposite outcomes

Same pipette **throughout**: reduces variance. Good.

Pipette A for arm A, pipette B for arm B: also "standardising". Creates a
**confounder**.

## Your turn — design poker, 5 minutes

Teams of 2–3. Four lots, two compounds, two protocols. Lay the experiments out
in two rows: Friday and Monday.

- Which factors did you **block**?
- Which did you **randomise**?
- Is any factor now perfectly **aliased**? Redeal.

## Key message

**Good design decides which variation the statistics can separate later.**

After the experiment, no analysis can unmix a confounder.

# Module 5 — Paired or unpaired?

## The way this comparison is usually drawn

![](output/figures/m5-clouds-1.png){height=4.4in}

## What did the first graph hide?

Every lot was tested with **both** compounds.

The vertical scatter is mostly **lots differing from each other** — not
compounds being similar.

Draw the lines, and the lot differences stop competing with the signal.

## Four tests, one dataset

| Test | Estimate | 95% CI | *p* | Clears 24.3 pp? |
|---|---|---|---|---|
| Student, unpaired | 38.2 | 13.7 – 62.7 | 0.005 | **inconclusive** |
| Welch, unpaired | 38.2 | 13.7 – 62.7 | 0.005 | **inconclusive** |
| **Paired t** | **38.2** | **26.4 – 50.0** | **0.0001** | **yes** |
| Wilcoxon signed rank | 36.4 | 27.0 – 48.8 | 0.008 | yes |

## Ignoring the pairing cost the decision

Every test agrees there is *a* difference.

They do **not** agree on whether it clears the threshold the team committed to
in Module 1.

> Pairing is a property of the **design**, fixed before the data exist.
> Never something you discover by trying both.

## Two footnotes worth the time

**Welch as the default.** Here the group SDs are 24.0 and 21.6 — Student and
Welch agree to the first decimal. You get protection when you need it and pay
nothing when you do not.

**Non-parametric is not free.** With *n* = 8, the smallest *p* Wilcoxon can
ever return is 1/128 ≈ 0.008. It cannot produce strong evidence here, whatever
the data look like.

## Visualisation hierarchy

1. the raw observations
2. the structure — pairing, blocks, batches
3. the estimated effect
4. its uncertainty

Bars, SEM whiskers and asterisks come after all four. If at all.

## Wide and long — the same 16 numbers

- **long** — one row per measurement, a column per factor; what R, Python and
  `ggplot2` expect
- **wide** — one factor spread across columns; what Excel and Prism are built
  for, and the right shape for a paired test

Both are exported. Keep lot, day and plate as real **columns**, not sheet
names.

## Your turn — 5 minutes

Find an experiment in your own work where the samples are **paired**.

Was it analysed that way?

## Key message

**The statistical test follows the experimental design.**

Draw the structure before you test it, and the right test is usually obvious.

# Module 6 — P-values and confidence intervals

## Assume the compounds are identical

Then run the whole study 2,000 times in that imaginary world.

![](output/figures/m6-null-1.png){height=4.4in}

## Panel A *is* the p-value

The red area is the fraction of studies in a no-difference world that would
produce a difference at least as extreme as ours.

**Panel B is worth a minute.** When there is genuinely nothing to find,
p-values are **uniform** — every value as likely as any other, about 5% below
0.05.

That is what a 5% false-positive rate means.

## What a p-value is **not**

- the probability that the compounds are identical
- the probability that the result happened by chance
- the probability that the experiment will replicate
- anything at all about the **size** of the effect

## "95% confidence" is a statement about the procedure

![](output/figures/m6-coverage-1.png){height=4.4in}

## Which result is more informative?

**A.** *p* = 0.03

**B.** estimated difference = 38 pp, plausible range 26 to 50 pp

Only **B** can be compared with a threshold. Only B supports a decision.

## Read the interval against the threshold, not against zero

![](output/figures/m6-three-1.png){height=4.4in}

## Three conclusions, not two

1. **Evidence for a relevant difference** — interval above the threshold
2. **Evidence against** — interval entirely below it
3. **Inconclusive** — interval spans it

The third is a result, and it is worth reporting.

## Our study

**38.2 pp, 95% CI 26.4 – 50.0, threshold 24.3 pp**

→ **relevant difference — act**

## Your turn — 5 minutes

Which of the three results would change what you do next, and why?

Then: the last *p*-value you showed in a presentation — could you still state
the effect size and its interval?

## Key message

**The p-value answers a narrow question about a world we do not believe in.**

The effect size and its interval answer the question we asked. Report both,
decide on the second.

# Module 7 — Surprising observations

## Two values look wrong. They are not the same kind of thing.

![](output/figures/m7-candidates-1.png){height=4.4in}

## Candidate 1 — a single well

Laboratory notebook for that plate:

> *Air bubble observed in well B; pipette felt strange.*

- independent, documented, technical
- recorded **before** anyone saw the result
- the other two wells of that condition agree with each other

A measurement failure. Excluding it is a **QC** decision.

## Candidate 2 — a whole lot

Grubbs' test flags it.

But the lot is more sensitive to **both** compounds, its IC₅₀ genuinely about
3-fold lower, and nothing in the QC record marks that plate.

> Grubbs asks whether a value is **improbable**. Never whether it is
> **wrong**.

A lot that is genuinely more sensitive is exactly what a safety margin should
be built on.

## A workflow, not a test

1. **Verify** — transcription, instrument, pipetting, sample identity
2. **Investigate** — is there an experimental explanation?
3. **Apply pre-defined rules** — fixed before the result was seen?
4. **Do not delete because it is inconvenient**
5. **Run a sensitivity analysis** — does the conclusion change?
6. **Document** — report what was excluded and why

## Step 5, done

| Scenario | Estimate | 95% CI | Clears threshold? |
|---|---|---|---|
| Keep everything | 38.2 | 26.4 – 50.0 | yes |
| Exclude the bubble well | 39.8 | 28.7 – 50.8 | yes |
| Exclude the sensitive lot | 38.6 | 24.6 – 52.6 | yes |
| Exclude both | 40.4 | 27.3 – 53.4 | yes |

## Report both ways

Running the analysis with and without is cheap — three lines of code.

A result that survives both is worth far more than one that requires a
particular exclusion.

## Your turn — 5 minutes

Think of a value you or a colleague once excluded.

- Which of the six steps justified it?
- Was the criterion written down **before** the result was seen?
- Would the conclusion have survived if it had stayed in?

## Key message

**Is the value implausible given the controls, or merely inconvenient given
the hypothesis?**

The first is a QC exclusion. The second is data manipulation.

# Module 8 — Power and the decision

## Same effect, same assay, same noise. Only *n* changes.

![](output/figures/m8-power-fig-1.png){height=4.4in}

## Two kinds of power

| Lots | *p* < 0.05 | CI clears the threshold |
|---|---|---|
| 3 | 83% | **27%** |
| 6 | 100% | **64%** |
| 12 | 100% | 98% |
| 24 | 100% | 100% |

## Getting a small *p*-value is far easier than answering the question

With 3 lots you would reach significance in 83% of studies — but could only
**act** on 27% of them.

## Power is not a property of an assay

It is a property of an assay **plus a hypothesised effect size**.

> "How many samples do I need?" has no answer until
> "what difference would matter?" has one.

## Underpowered studies do not just fail — they mislead

![](output/figures/m8-exaggeration-fig-1.png){height=4.4in}

## The bias always points the same way

At 18% power, the studies that reach significance overstate the effect by about
**29%**. By 99% power the distortion is gone.

An underpowered literature is not merely noisy. It is **biased**.

## Where to spend 24 wells

![](output/figures/m8-allocation-1.png){height=4.4in}

## Technical replicates cannot substitute for lots

| Allocation | *p* < 0.05 | Clears the threshold | Median CI width |
|---|---|---|---|
| 3 lots × 8 wells | 84% | **28%** | 44.3 pp |
| **8 lots × 3 wells** | 100% | **84%** | **18.3 pp** |

## Adding wells to three lots never fixes it

The uncertainty that matters is **lot-to-lot**. No number of technical
replicates reduces it.

## Your turn — 5 minutes

Would you act on these data?

What would you run next, and how many **lots** would it need?

## Key message

**Power is the question "what would this experiment be able to tell me?" —
asked while there is still time to change the answer.**

# Module 9 — What we have learned

## The same 48 numbers, four ways

| Analysis | Estimate | 95% CI | Conclusion | Earned? |
|---|---|---|---|---|
| Count wells, ignore lots | 38.2 | 25.0 – 51.4 | relevant | **no** — interval too narrow to believe |
| Confounded schedule | 40.6 | — | no interval possible | **no** — contains the day effect |
| Lots, pairing ignored | 38.2 | 13.7 – 62.7 | inconclusive | yes |
| **Lots, paired, blocked** | **38.2** | **26.4 – 50.0** | **relevant** | **yes** |

## Only the last row is both right and entitled to be right

Row 1 is the uncomfortable one: the shortcut reaches the same conclusion, with
a far smaller *p*-value. It is right **by accident**.

Had the lots been a little more variable, the same shortcut would have
produced the same unwarranted confidence behind a **wrong** answer — and
nothing in the output would have looked different.

::: notes
This is the closing argument of the whole workshop. The arithmetic always
runs. It never tells you which row you are in.
:::

## Three things worth remembering

- Good design **minimises unnecessary variation** while maximising the chance
  of detecting what you care about
- Design and analysis **reduce uncertainty; they never remove it** — an honest
  interval beats a confident sentence
- The decision is **scientific**: effect size, threshold and context live
  outside statistics

## The one-line version

> To answer *"which statistical test should I use?"*
>
> you first have to answer *"how were the data generated?"*

# Module 10 — Where to go from here

## The usual prompt

> *"Compare columns A and B statistically."*

An LLM will answer. It will pick a test, report a *p*-value, and sound
confident.

It cannot know whether the columns are paired, whether rows are wells or lots,
whether the groups ran on different days, or what difference you would act on.

So it guesses — usually an unpaired t-test on every row. On this dataset, the
analysis that gets the wrong answer twice over.

## The same request, with the design in it

> *"These measurements come from eight independent human hepatocyte lots. Each
> lot was tested with both compounds, three technical wells per lot and
> compound. The independent unit is the lot, not the well. Plates ran over two
> days; day is balanced across compounds. We decided in advance that a
> difference below 24 percentage points would not change our decision.*
>
> *Help me visualise the data so the pairing is visible, estimate the
> difference with its uncertainty, and compare that interval with our
> threshold. Before recommending a test, tell me what you think the
> independent unit is and whether the comparison is paired."*

## Every fact in that prompt is a design fact

And every one was decided **before** any data existed.

The last sentence is the habit worth keeping: **ask the model to state its
assumptions about the unit and the pairing before it computes anything** — so
you catch a wrong assumption while it is still cheap.

The same applies to a colleague, a statistician, or your own notebook six
months from now.

## The final checklist

1. What is the question, and what difference would matter?
2. What population do I want to generalise to?
3. What is my independent experimental unit?
4. Where can bias enter?
5. Which variation do I block, randomise, or standardise?
6. Plot so the experimental structure is visible
7. Estimate the effect **and** its uncertainty
8. Use a test that matches the design
9. Investigate surprising observations instead of deleting them
10. Decide on effect size, uncertainty and context — not the *p*-value alone

## Reading

- Krzywinski & Altman, *Points of Significance*, Nature Methods (2013–2015)
- Lazic, *Experimental Design for Laboratory Biologists* (2016)
- Amrhein, Greenland & McShane, *Retire statistical significance*, Nature (2019)
- The ARRIVE and *Nature* reporting checklists

## And otherwise

**Come and talk to me.**

Most statistical problems that reach a statistician are design problems that
arrived too late.

The conversation is much shorter, and much happier, **before** the experiment.

## Take the data with you

Every module exported the data it used, as plain CSV, in `output/workshop/`.

Open them in Excel, Prism, R or Python — or paste one into an LLM together
with the design description from two slides ago.
