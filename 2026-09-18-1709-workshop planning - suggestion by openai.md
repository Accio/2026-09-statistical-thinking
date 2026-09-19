---
title: Workshop planning - suggestion by OpenAI
date: 2026-09-18 17:09
tags: 
---


Recurring design: Question, Design, Data, Analysis and Uncertainty, Decision

We start with a synthesized experiment of CellTiter-Glo (ATP luminescence) measuring cell viability in primary cells. We have two compounds of the same project, compound A and compound B.

Our question: *Does compound B have such a substantial different effect on cell viability that we care, or that we have to take actions?* For example, before seeing the data, we can define a shift of IC50 by *three fold or more* as scientifically relevant. The exact threshold should be adjusted to the question at hand and the decision the result aims to inform.

### Full dataset

* 8 independent hepatocyte lots (donors)
* 2 conditions: Compound A and Compound B
* 3 technical replicate wells per condition
* 2 weekdays for the assay
* one technical failure
* one donor with higher yet possible values
* different technical variance in some conditions

# Key questions and answers

The key capability that we want to help the audience build is to ask questions about experiment design so that they can decide how to analyse the data with statistical tools.

We break down the 3 hours into ten 15-minute modules separated by breaks. In each module we try to address one set of question:

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

* Story/problem: 3 minutes
* Visual demonstration and simulation: 5 minutes
* Participant task/discussions: 5 minutes
* Summary: 2 min

# 3. Module 1 — What question are we actually asking?

* Measurements of what?
* From whom/what?
* Under which conditions?
* What population are we trying to learn about?
* What decision are we trying to make?

### Concepts

Introduce visually:

**Population**
The collection of possible biological units/experiments about which we want to make a statement.

**Sample**
The units actually observed.

**Measurement**
A number obtained from a sampled unit. A measurement is not necessarily an independent sample.

### Key takeaway

Statistics cannot rescue an experiment whose question was never defined.

Before analysis, participants should be able to complete:

> `I want to estimate/compare ______ in ______ because I need to decide ______.`

# 4. Module 2 — Variation: what does one number tell us?

### Start visually

Show individual points rather than a bar chart.

Then show:

* the mean,
* spread,
* repeated hypothetical experiments.

Use an animation or simulation: repeatedly generate six measurements from the same underlying process.

The mean moves every time.

This allows you to introduce **sampling uncertainty without equations**.

### Important distinction

Draw something like:

**Observed variation**

→ measurement variation
→ biological variation
→ systematic experimental variation
→ random experimental variation

The objective is to stop people thinking: “variation = bad experiment.”

Some variation is inevitable; some is informative; some is preventable.

### Bias versus variance

**Scenario A:**
Every control sample is measured with Pipette A and every treated sample with Pipette B.

Potential **bias/confounding**.

**Scenario B:**
Within one experiment, every replicate is prepared using different consumable batches “to make things representative.”

Potentially unnecessary **variance**.

Ask:

> “Which strategy makes it hard to know whether the treatment caused the difference?”

and

> “Which strategy makes a real effect harder to detect?”

Use the cartoon of shooting at a target to show

* Bias is consistently wrong.
* Variance is inconsistently noisy.
* Reducing variance is good only if you are not doing it by introducing bias.


### Q&A prompt

Ask participants to name one source of variability from their own assay, and classify the answer to

1. Wanted variation (for instance compound treatment)
2. Unavoidable variation (for instance time, consumable)
3. Controllable variation (for instance date, plate, experimenter, machine)
4. Confounding variation (changing together, or partially overlapping with, the factor of interest)

---

# 5. Module 3 — What is *n*?

### Dataset reveal

If we have six values, 2 hepatocyte lots × 3 wells each.

What is the sample size n? Six? Two? Or other ideas?

### Technical replicate

Repeated measurements intended primarily to characterize measurement/technical variation.

### Biological/independent replicate

An independently sampled unit that gives new information about the population.

3 wells from one hepatocyte lot ≠ 3 independent hepatocyte lots.

### Visual

Show:

**Experiment A**

12 independent hepatocyte lots
× 1 well each

versus

**Experiment B**

3 hepatocyte lots
× 4 wells each

Both contain 12 measurements.

Ask:

> “Which gives us more information about variation between hepatocyte lots?”

Then:

> “Which may estimate technical precision better?”

Neither design is universally “better”; they answer different questions.

### Pseudoreplication reveal

Calculate a test twice:

* incorrectly treating 24 wells as independent,
* correctly respecting the independent experimental units.

### Takeaway

Variance among biological replicates reveals differences among cell cultures or animals or humans. Variance among technical replicates reveals differences caused by the measurement procedure.

---

# 6. Module 4 — Designing experiment: randomization, blocking, batches

New data

* assay day
* plate,

### Story

Suppose experiments with Protocol A were all measured Friday afternoon, and experiments with Protocol B all on Monday morning. And we observe a difference. Is it a protocol effect or weekday effect? Confounder

Alternative design: running experiments with Protocol A and Protocol B both on Friday and on Monday. This makes the weekday (Friday/Monday) a *Block* instead of a *Confounder*.

### Poker

Form in teams of 2-3. Each team gets

* 4 donors (four numbers, say A, 2, 3, 4)
* Two compounds (two colors)
* A and B protocols (two shapes)

Arrange the experiments in two rows, representing Friday and Monday.

### Concepts

* Block known sources of variation when possible: removes confounding
* Randomize things you don't want systematically associated with treatment. (e.g. order in this case)
* Standardize, or control, or reduce irrelevant variation where appropriate. (e.g. use the same pipette and consumables in the experiment).

What are the consequences?

* Using the same pipette everywhere: reduce/standardize/control variance
* Using one pipette exclusively for condition A and another exclusively for B: creates confounding.
* Using different consumable batches randomly within every small experiment: increase irrelevant variation, adding noise.

### Takeaway

Good experimental design determines which variation statistics can separate later.

---

# 7. Module 5 — Comparing groups: paired or unpaired?

Now reveal that every hepatocyte lot was tested under both protocols.

Display the data first as two clouds of dots.

The distributions overlap considerably.

Then show exactly the same data with lines joining measurements from the same donor.

Suddenly the effect may become much clearer.

Ask:

> “What information did the first graph hide?”

That introduces pairing.

### Decision rule

Are observations linked by experimental design?

* Same donor before/after → paired.
* Same compound under two assays → paired.
* Separate independently sampled groups → unpaired.

Pairing is determined before seeing the results.

Are there examples in your work where the samples are paired?

If groups are independent, don't assume identical variability without a reason. Modern software can use a comparison that does not require equal variances.

The Welch t-test does not assume equal variances in two groups and is often suitable for two-group comparisons.

### Visualization hierarchy

1. raw observations,
2. structure such as pairing,
3. estimate of the difference,
4. uncertainty.

Later comes: bar, error bars (sd, SEM), and asterisks.

### Takeaway

The statistical test follows the experimental design.

---

# 8. Module 6 — P-values, confidence intervals and inference

Assume that there is no difference between two donors.

Simulate the entire experiment many times.

Every simulated experiment produces a slightly different difference between A and B.

Occasionally it produces a surprisingly large difference.

Then introduce the p-value conceptually:

> **If there really were no underlying difference of the type specified by our model, how surprising would data at least this incompatible with that model be?**

A p-value is the likelihood that if there is no real difference between A and B, when the experiment is performed many times, how often do we falsely believe that there is a difference between A and B due to randomness in the sampling?

P-value is not

* probability that the null hypothesis (A equals B) is true,
* probability that the result happened by chance,
* probability that the experiment will replicate,
* size of the effect.

### Confidence intervals

Use a forest-like picture:

estimated effect = −18%

with an uncertainty interval.

Ask:

> Which result is more informative?

A. `p = 0.03`

B. `estimated change = −18%, plausible range −31% to −4%`

B naturally supports a scientific decision.

### Particularly valuable comparison

Show three hypothetical results:

* A. Large effect, high uncertainty
* B. Tiny effect, very precise
* C. Moderate effect, moderate uncertainty

Have participants discuss which would matter scientifically.

Statistical significance ≠ biological importance.

### Introduce “inconclusive”

Make participants comfortable with three possible conclusions:

* Evidence supports a meaningful difference.
* Evidence supports the absence of a meaningful difference.
* The experiment is too uncertain to distinguish those possibilities.


---

# 9. Module 7 — How to deal with outliers

Your dataset now acquires two suspicious observations.

One technical replicate is dramatically different.

Laboratory notes say:

> Air bubble observed; pipette felt strange.

### Observation 2

Some donor show aberrant values?

Ask:

> “Are both outliers?”

### Teach a workflow rather than an outlier test

When a surprising value appears:

1. Verify: Was there a transcription, instrument, pipetting or sample-identification problem?
2. Investigate: Is there an experimental explanation?
3. Apply predefined rules: Was an exclusion criterion established before seeing the result?
4. Don't delete because it is inconvenient: biology is often surprising
5. Perform sensitivity analysis: Does the conclusion change with and without the questionable observation?
6. Document: Make exclusion transparent.

### Takeaway

Outlier handling is often scientific rather than statistic: is it likely, or it is rather artifact?

---

# 10. Module 8 — Power, sample size and making the decision

Return to the original question.

The full dataset is now visible.

Ask the groups: Would you change the assay protocol on the basis of these data? What additional experiment, if any, would you run?

### Power without formulas

Show through simulation: Same underlying 20% effect.  Run an experiment with:

* n = 3 independent donors,
* n = 6,
* n = 12,
* n = 24.

Show the distributions of resulting effect estimates.

Participants will witness that small n can lead to very unstable conclusions

Then repeat:

**3 donors × 8 technical replicates**

versus

**8 donors × 3 technical replicates.**

### Important concept

Power requires specifying an **effect worth detecting**.

So before asking: “How many samples do I need?”, we have to ask ourselves “What difference would matter?”

### Final decision framework

Participants should leave with the ability to ask following questions

1. What exactly is the question?
2. What population do I want to generalize to?
3. What is my independent experimental unit?
4. Where can bias enter?
5. Which variation should I control, randomize or block?
6. Plot the observations in such a way to preserve the experimental structure.
7. Estimate the effect and its uncertainty.
8. Use a statistical test appropriate to the design.
9. Investigate surprising observations rather than automatically deleting them.
10. Make the scientific decision using effect size, uncertainty and context, instead of using the p-value alone.

---

# 11. Reflect and summarize what we have learned

# 12. Where to go from here

Ideas

* Recommend good resources
* Personal discussion
* Using LLMs

Instead of prompting

> “Compare columns A and B statistically.”

Then show why the AI cannot know whether the data are paired, independent, technical replicates, different batches, etc.

A prompt would contain the design:

> “These measurements come from eight independent hepatocyte lots. Each lot was measured under both conditions, with three technical replicate wells per condition. The biological unit is the hepatocyte lot. Help me visualize the data and compare the conditions while preserving this experimental structure. Before recommending a statistical test, explain what you consider the independent unit and whether the comparison is paired.”

---

To answer the question `Which statistical test should I use?`, we have to know `How the data were generated`.

## Final learning outcome

The idea outcome is that the audience feels that “I know what questions to ask before trusting or performing an analysis.”

Key things

* Good experiment design minimizes unnecessary and avoidable variation, while maximizing the chance to detect causal relation between factors of interest and observed variations.
* Good experiment design and statistical analysis can reduce, but not eliminate, uncertainty
* Decisions are made by scientific rationale and hypotheses that are often outside the domain of statistics.

The next useful step would be to build the actual synthetic dataset so that all modules work with the same numbers. We need to design the full 48-row dataset, including the hidden batch effect, technical replicates, one technical outlier and one real biological extreme, plus specify exactly which columns/rows are revealed in each module and what the expected plots/tests should show. Also, I want to show the difference between wide and long table formats.

