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
    message:
        "Merge using single rule"
    shell:
        """
        cat {input} > {output}
        """
