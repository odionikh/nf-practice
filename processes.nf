params.fasta = false
params.outdir = false
params.vfsum = false

process AMR { 
  tag "AMR on $sample_id"
  container 'staphb/ncbi-amrfinderplus:latest'
  publishDir "${params.outdir}/AMR/${sample_id}/", mode:'copy'

  input: 
    tuple(val(sample_id), path(fasta))

  output:
    path("${sample_id}_amrfinder_output.txt")

  script:
    """
  #  amrfinder -u
    amrfinder -n ${fasta} -o ${sample_id}_amrfinder_output.txt --name ${sample_id} --plus
    """
}

process VFDB { 
  tag "VFDB on $sample_id"
  container 'quay.io/biocontainers/abricate:1.0.1--ha8f3691_1'
  publishDir "${params.outdir}/VFDB/${sample_id}", mode:'copy'

  input: 
    tuple(val(sample_id), path(fasta))

  output:
    path("${sample_id}_VFDB.txt")

  script:
    """
   abricate --db vfdb --quiet ${fasta} > ${sample_id}_VFDB.txt  
    """
}

process VFDBSUM { 
  tag "VFDB_comb"
  container 'quay.io/biocontainers/abricate:1.0.1--ha8f3691_1'
  publishDir "${params.outdir}/VFDB/summary", mode:'copy'

  input: 
   path(VFDB_files)

  output:
    path "VFDBSUMMARY.txt"

  script:
    """
   abricate --summary $VFDB_files > VFDBSUMMARY.txt  
    """
}
