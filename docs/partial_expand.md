---
title: "Snakemake expand tutorial"
output:
   html_document:
      toc: true # table of content true
      toc_float: true
      toc_depth: 3  # up to three depths of headings (specified by #, ## and ###)
      fig_caption: true
      highlight: tango  # specifies the syntax highlighting style
#      number_sections: true  ## if you want number sections at each table header
#      theme: united 
---

This tutorial is inspired by this question [here](https://stackoverflow.com/questions/40398091/how-to-do-a-partial-expand-in-snakemake).

## Expand for all combinations

Consider the normal usage of `expand()` function.

```
LETTERS = ["A", "B"]
NUMS = ["1", "2"]

rule all:
    input:
        expand("combined_{letter}.txt", letter=LETTERS)

rule generate_text:
    output:
        "text_{letter}_{num}.txt"
    shell:
        """
        echo "{wildcards.letter}" "{wildcards.num}" > {output}
        """

rule combine_text:
    input:
        expand("text_{letter}_{num}.txt", letter= LETTERS, num=NUMS)
    output:
        "combined_{letter}.txt"
    shell:
        """
        cat {input} > {output}
        """
```

In this case, both files called *combined_A.txt* and *combined_B.txt* are generated.
However beside their names, they are identical.

## Partial expand

Use double bracket for non-expanded wildcard.
Update `rule combine_text` to the following:

```
rule combine text:
    input:
        expand("text_{{letter}}_{num}.txt", num=NUMS)
    output:
        "combined_{letter}.txt"
    shell:
        """
        cat {input} > {output}
        """
```

The files *combined_A.txt* and *combine_B.txt* are no longer the same.
Check with `diff combined_A.txt combined_B.txt`

Another way to write is as following: 
```
expand("text_{letter}_{num}.txt", num=NUMS, allow_missing=True)
```
This will also produce the same result.

## Expand further 

Lets add in the third variable.

```
LETTERS = ["A", "B"]
NUMS = ["1", "2"]
SAMPLES = ["S1","S2"]

rule all:
    input:
        expand("{sample}_{letter}.txt", sample = SAMPLES, letter=LETTERS)

rule generate_text:
    output:
        "{sample}_{letter}_{num}.txt"
    shell:
        """
        echo {wildcards.sample} {wildcards.letter} {wildcards.num} > {output}
        """

rule combine_text:
    input:
        expand("{{sample}}_{{letter}}_{num}.txt", num=NUMS)
    wildcard_constraints:
        letter="|".join(LETTERS)
    output:
        "{sample}_{letter}.txt"
    shell:
        """
        cat {input} > {output}
        """
```

In this case *sample* and *letter* are grouped together.


The `wildcard_constraints` is added to specify that the letter can only come from the list LETTERS. 
Without the constraints Snakemake will fail due to *AmbigousRuleException*.
 
Check the files with `diff S1_A.txt S2_A.txt`

## Combine to sample (2 steps) 

Lets go one step further and generate a rule to combine all under *sample*.
For that we need to use `wildcard_constraints`.
This can be part of the rule or global.

```
LETTERS = ["A", "B"]
NUMS = ["1", "2"]
SAMPLES = ["S1","S2"]

wildcard_constraints:
    letter="|".join(LETTERS),
    sample="|".join(SAMPLES)

rule all:
    input:
        expand("{sample}.txt", sample = SAMPLES)

rule generate_text:
    output:
        "{sample}_{letter}_{num}.txt"
    shell:
        """
        echo {wildcards.sample} {wildcards.letter} {wildcards.num} > {output}
        """

rule combine_text:
    input:
        expand("{{sample}}_{{letter}}_{num}.txt", num=NUMS)
    output:
        "{sample}_{letter}.txt"
    shell:
        """
        cat {input} > {output}
        """

rule combine_sample:
    input:
        expand("{{sample}}_{letter}.txt", letter=LETTERS)
    output:
        "{sample}.txt"
    shell:
        """
        cat {input} > {output}
        """
```

## Combine to sample (1 step)

Same as above but in 1 step:

```
LETTERS = ["A", "B"]
NUMS = ["1", "2"]
SAMPLES = ["S1","S2"]

wildcard_constraints:
    sample="|".join(SAMPLES)

rule all:
    input:
        expand("{sample}.txt", sample = SAMPLES)

rule generate_text:
    output:
        "{sample}_{letter}_{num}.txt"
    shell:
        """
        echo {wildcards.sample} {wildcards.letter} {wildcards.num} > {output}
        """

rule combine_text:
    input:
        expand("{{sample}}_{letter}_{num}.txt", letter=LETTERS, num=NUMS)
    output:
        "{sample}.txt"
    shell:
        """
        cat {input} > {output}
        """
```
