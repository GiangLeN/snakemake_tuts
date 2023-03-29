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
