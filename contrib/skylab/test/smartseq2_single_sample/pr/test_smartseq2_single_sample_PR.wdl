import "ss2_single_sample.wdl" as target_wdl
import "ValidateSmartSeq2SingleCell.wdl" as checker_wdl

# this task will be run by the jenkins script that gets executed on our PRs.
workflow TestSmartSeq2SingleCellPR {

  # expected hashes of target_workflow outputs
  String expected_counts_hash
  String expected_alignment_summary_metrics_hash

  # SS2 inputs
  File gtf_file
  File genome_ref_fasta
  File rrna_intervals
  File gene_ref_flat
  File hisat2_ref_index
  File hisat2_ref_trans_index
  File rsem_ref_index
  String hisat2_ref_name
  String hisat2_ref_trans_name
  String stranded
  String sample_name
  String output_name
  File fastq1
  File fastq2

  call target_wdl.SmartSeq2SingleCell as target_workflow {
    input:
      gtf_file = gtf_file,
      genome_ref_fasta = genome_ref_fasta,
      rrna_intervals = rrna_intervals,
      gene_ref_flat = gene_ref_flat,
      hisat2_ref_index = hisat2_ref_index,
      hisat2_ref_trans_index = hisat2_ref_trans_index,
      rsem_ref_index = rsem_ref_index,
      hisat2_ref_name = hisat2_ref_name,
      hisat2_ref_trans_name = hisat2_ref_trans_name,
      stranded = stranded,
      sample_name = sample_name,
      output_name = output_name,
      fastq1 = fastq1,
      fastq2 = fastq2
  }

  call checker_wdl.ValidateSmartSeq2SingleCell as checker_workflow {
    input:
     counts = target_workflow.rsem_gene_results,
     expected_counts_hash = expected_counts_hash,
     alignment_summary_metrics = target_workflow.alignment_summary_metrics,
     expected_alignment_summary_metrics_hash = expected_alignment_summary_metrics_hash
  }

}
