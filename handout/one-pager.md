# Statistical thinking: a workshop

Jitao David Zhang and Christian Weinmann, September 2026

The workshop, consisting of nine modules, aims to help you become familiar with statistical thinking. We learn how to ask questions that lead to better experimental design and data analysis.

::: {.agenda}

**Module I**: What questions are we asking, and what is the minimal difference that we care about?
:   We follow the order of question, threshold, experiment, and statistics, not the reverse.

**Module II**: What types of variation are there?
:   Usually we are interested in biological and compound-induced variation. Technical variation is sometimes interesting, and sometimes needs to be minimized. We often need a balance between variation and bias.

**Module III**: What are biological and technical replicates, and what are their uses?
:   Biological replicates help us quantify variability between individual humans, animals, or cell cultures, while technical replicates help us quantify variability between parallel measurements. Which of them counts as the independent unit depends on the question, and that choice sets the level at which the data should be analyzed.

**Module IV**: What are randomization and blocking, and why are they important for experimental design?
:   If you have to compare A and B in an experiment run in two batches, test both A and B within each batch, instead of testing A in one batch and B in the other: This is the essence of *blocking*. When multiple factors may affect the outcome, block those you can, and randomize the rest.

**Module V**: How do we compare two groups?
:   While we are interested in the population, we only have samples and their measurements. Commonly used tools include the unpaired t-test, the paired t-test, and non-parametric tests. For more complex designs, we can use ANOVA (multiple groups) and linear regression (adjusting for covariates).

**Module VI**: How do we detect and handle outliers?
:   Use common sense, your experience, and prior knowledge or data to judge whether a value is an outlier. State the reasons explicitly, and in case of doubt, run statistical analyses with and without the outliers to test the sensitivity of your conclusion.

**Module VII**: What do we mean by p-values, effect sizes, and confidence intervals?
:   In the context of a two-group comparison, the null hypothesis is that there is no difference at the population level. When we apply t-tests to sample measurements, we get the p-value, which is the probability of observing a difference at least as large as ours, *given that the null hypothesis is true*. The p-value only tells you something about whether there might be a difference at the population level, but not about how large it is: effect size matters. A confidence interval is an educated guess at the range of the effect size. Its meaning can only be understood by repeating the statistical procedure many times.

**Module VIII**: What is power, and how does it affect the quality of our decision?
:   Once we define a threshold that we care about, the sample size of the experiment determines the power of the study: it is the probability that we can detect a difference of at least that size when one exists. Too few samples may not allow us to detect subtle differences, because of randomness.

**Module IX**: How can I learn more and get help if I am stuck?
:   We will recommend resources, share useful prompts for AI, and offer to consult with you.
:::

Thank you for joining the workshop. We welcome criticism, suggestions, and feedback!
