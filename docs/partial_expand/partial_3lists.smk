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
