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

rule combine text:
    input:
        #expand("text_{letter}_{num}.txt", num=NUMS, allow_missing=True)
        expand("text_{{letter}}_{num}.txt", num=NUMS)
    output:
        "combined_{letter}.txt"
    shell:
        """
        cat {input} > {output}
        """
