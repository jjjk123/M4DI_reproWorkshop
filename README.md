# M4DI_reproWorkshop Oct 2, 2024


###

1. Map the reads to the ref genome of SARS-Cov-2

2. Call SNPs

3. Build the consensus sequence

4. Detect clades (alpha, beta, ...)


### Data:

Reference genome:
- https://www.ncbi.nlm.nih.gov/nuccore/MN908947

Samples:
- https://www.ebi.ac.uk/ena/browser/view/SRX9443330?show=reads
- https://www.ebi.ac.uk/ena/browser/view/ERR9187873

### Software:

bwa, samtools, iVar, Nextclade (https://clades.nextstrain.org/)

## Docker notes

`docker run -it --entrypoint bash containerName`

> nextflow version 24.04.4.5917
> Docker version 20.10.12, build e91ed57
