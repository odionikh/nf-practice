nextflow.enable.dsl=2

include {AMR} from './processes.nf'
include {VFDB} from './processes.nf'
include {VFDBSUM} from './processes.nf'

workflow {
sample_id_and_fasta = Channel.fromFilePairs("${params.fasta}/*.fa", size: 1, flat: true)
    AMR(sample_id_and_fasta)
    VFDB(sample_id_and_fasta)
    // VFDB_files=VFDB(sample_id_and_fasta)
    VFDBSUM(VFDB.out.collect())
    // VFDBSUM(VFDB_files.collect())
}

