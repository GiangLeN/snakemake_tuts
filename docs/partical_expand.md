

https://stackoverflow.com/questions/40398091/how-to-do-a-partial-expand-in-snakemake

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
        echo "test" > {output}
        """

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
