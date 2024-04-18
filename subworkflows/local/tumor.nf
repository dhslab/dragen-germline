include { DRAGEN_MULTIALIGN as DRAGEN_FASTQ_LIST    } from '../../modules/local/dragen_multialign.nf'
include { DRAGEN_MULTIALIGN as DRAGEN_CRAM          } from '../../modules/local/dragen_multialign.nf'
include { DRAGEN_MULTIALIGN as DRAGEN_BAM           } from '../../modules/local/dragen_multialign.nf'
include { ANNOTATE_SMALLVARIANTS                    } from '../../modules/local/annotate_smallvariants.nf'

workflow TUMOR {
    take:
    fastq_list
    cram
    bam
    dragen_inputs

    main:
    ch_versions = Channel.empty()
    ch_dragen_output = Channel.empty()

    DRAGEN_FASTQ_LIST(fastq_list, 'fastq_list', dragen_inputs)
    ch_dragen_output = ch_dragen_output.mix(DRAGEN_FASTQ_LIST.out.dragen_output)
    ch_versions = ch_versions.mix(DRAGEN_FASTQ_LIST.out.versions)

    DRAGEN_CRAM(cram, 'cram', dragen_inputs)
    ch_dragen_output = ch_dragen_output.mix(DRAGEN_CRAM.out.dragen_output)
    ch_versions = ch_versions.mix(DRAGEN_CRAM.out.versions)

    DRAGEN_BAM(bam, 'bam', dragen_inputs)
    ch_dragen_output = ch_dragen_output.mix(DRAGEN_BAM.out.dragen_output)
    ch_versions = ch_versions.mix(DRAGEN_BAM.out.versions)

    ANNOTATE_SMALLVARIANTS(ch_dragen_output, Channel.fromPath(params.fasta), Channel.fromPath(params.vepcache))

    emit:
    ch_versions
}