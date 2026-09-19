# Statistical thinking: a workshop for experimental scientists
Jitao David Zhang and Christian Weinmann, September 2026

## Background

The three-hour workshop aims at helping wet-lab researchers with familiar with statistical thinking, and prepare you to ask questions that lead to better experiment design and data analysis.

## Agenda

The workshop consists of 15-minute modules.

**Module I**: What questions are we asking, and what is the minimal difference that we care about?
We act in the order of question, threshold, experiments, and statistics, not the reverse.

**Module II**: What types of variance are there?
Often we are interested in biological and compound-induced variance. Technical variance is sometimes interesting, and sometimes needs to be minimized. We often need a balance between variance and bias.

**Module III**: What are biological and technical replications, and what are their uses?
Biological replicates help us quantify variability between individual humans, animals, or cell cultures, while technical replicates help us quantify variability between parallel measurements. The sample size $n$ depends on the interest of the experiment and determines the level of analysis.

**Module IV**: What are randomization and blocking, and why they are important tools for experiment design?
If you have to compare A and B in an experiment run in two batches, make sure that you test both A and B within each batch, instead of testing A only in one batch and B in the other: this is the essence of 'blocking'. When multiple factors may affect the outcome, block those you can, and randomise the rest.

**Module V**: How to compare two groups?
While we are interested in the population, we only have samples and their measurements. Commonly used tools include unpaired t-test, paired t-test, and non-parametric test.

**Module VI**: How to detect and handle outliers?
Use common sense, your experience and observation, and prior knowledge and data to judge whether a value is an outlier. State the reasons explicitly, and in case of doubt, running statistical analyses with and without the outliers to test the sensitivity.

**Module VII**: What do we mean with p-values, effect size, and the confidence intervals?
In the context of two-group comparison, the null hypothesis is that at the population level there is no difference. When we apply t-tests to sample measurements, we get the p-value, which is the probability of observing the same or a stronger difference *given that the null hypothesis is true*. P-value only tells you something about there might be a difference at the population level, but not about how large is the difference: effect size matters. Confidence interval is an educated guess of the range of the effect size: its meaning can only be understood by repeating the statistical procedure many times.

**Module VIII**: What is power, and how power affects the quality of our decision?
Once we define a threshold that we care about, the sample number *n* of the experiment determines the power of the study: it is the probability that we can detect true difference if there is one, and too few samples may not allow us detect fine differences because of randomness.

**Module IX**: How can I learn more and get help if I am stuck?
We will recommend resources, share useful prompts for LLM, and offer help for consultation.

::: {.cols}

::: {.box}
## Ten simple questions to ask before designing an experiment or analysing a dataset

1. What exactly is the question, and what difference would matter?
2. What population do I want to generalise to?
3. What is my independent experimental unit?
4. Which variance do I block, randomise, or minimize?
5. Does my plot reflect the experimental structure?
6. Have I estimated the effect *and* its uncertainty?
7. Does the test match the design?
8. Have I investigate surprising values, and if necessary, label them as outliers?
9. Am I deciding on effect size and context, instead of on the *p*-value alone?
10. Can I improve my design and analysis by let AI criticize it and by consulting another colleague?
:::

Thank you for joining the workshop, and we welcome oral and written criticism, suggestions, and feedback!
