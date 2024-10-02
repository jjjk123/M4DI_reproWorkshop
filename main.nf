process indexing {
    input:
    file reference

    output:
    file "${reference}.*"

    script:
    """
    bwa index ${reference}
    """
}

process mapping {
    input: 
    tuple val(name), file(r1), file(r2)
    file reference
    file index

    output:
    file "*.sam"

    script:
    """
    bwa mem -t 1 ${reference} ${r1} ${r2} > ${r1.simpleName}.sam
    """
}

process samToBam {
    input: 
    file samFile

    output:
    file "*.bam"

    script:
    """
    samtools sort -o ${samFile.baseName}.bam ${samFile} \ 
    samtools index ${samFile.baseName}.bam
    """
}

process callSNP {
    input:
    file reference
    file bamFile

    output:
    file "*.variants.tsv"
    
    script:
    """
    samtools mpileup -A -d 600000 --reference ${reference} -B -Q 0 ${bamFile} | ivar variants -r ${reference} -p ${bamFile.simpleName}.variants.tsv -q 0 -t 0.02
    """
}

process consensus {
    input:
    file bamFile

    output:
    file "consensus.*"

    script:
    """
    samtools mpileup -d 600000 -A -Q 0 -F 0 ${bamFile} | ivar consensus -q 20 -t 0 -m 5 -n N - p consensus
    """
}

workflow {
    reference = file("data/reference.fasta")
    index = indexing(reference)

    fastq = Channel.fromFilePairs("data/*_{1,2}.fastq.gz", flat:true)
    samFile = mapping(fastq, reference, index)

    bamFile = samToBam(samFile)

    variants = callSNP(reference, bamFile)

    consensus(bamFile)
}
