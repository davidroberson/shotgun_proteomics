class: Workflow
cwlVersion: v1.0
label: Philosopher - Convert to Peptide Prophet
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: database_name
  label: A. database file (fas)
  doc: Path to the protein database file in FASTA format.
  type: File
  sbg:fileTypes: FAS
  sbg:x: 0
  sbg:y: 228.84375
- id: Xmx
  type: int?
  sbg:exposed: true
- id: raw_files
  label: B. RAW files
  type: File[]
  sbg:fileTypes: RAW
  sbg:x: 0
  sbg:y: 0

outputs:
- id: peptide_prophet_folder_archive
  type: File?
  outputSource:
  - philosopher_peptideprophet/peptide_prophet_folder_archive
  sbg:x: 892.703125
  sbg:y: 35.5

steps:
- id: msconvert
  label: msconvert
  in:
  - id: raw_files
    source:
    - raw_files
    linkMerge: merge_flattened
  scatter:
  - raw_files
  run: ../tools/msconvert/msconvert.cwl
  out:
  - id: std_out
  - id: mzML
  sbg:x: 190.46876525878906
  sbg:y: 168.1328125
- id: msfragger
  label: MSFragger
  in:
  - id: database_name
    source: database_name
  - id: Xmx
    source: Xmx
  - id: mzML
    source:
    - msconvert/mzML
  run: ../tools/msfragger/msfragger.cwl
  out:
  - id: standard_out
  - id: pepxml
  - id: mgf
  sbg:x: 419.39678955078125
  sbg:y: 100.42185974121094
- id: philosopher_workspace
  label: Philosopher Workspace
  in:
  - id: init
    default: true
  run: ../tools/workspace/workspace.cwl
  out:
  - id: std_out
  - id: workspace
  sbg:x: 0
  sbg:y: 114.421875
- id: philosopher_database
  label: Philosopher Database
  in:
  - id: annotate
    source: database_name
  - id: workspace_in
    source: philosopher_workspace/workspace
  run: ../tools/database/database.cwl
  out:
  - id: output
  - id: workspace
  sbg:x: 190.46876525878906
  sbg:y: 46.710941314697266
- id: philosopher_peptideprophet
  label: Philosopher PeptideProphet
  in:
  - id: --database
    source: database_name
  - id: pepXML
    source:
    - msfragger/pepxml
  - id: mzML
    source:
    - msconvert/mzML
  - id: workspace_in
    source: 
    - philosopher_database/workspace
  run: ../tools/peptide-prophet/peptide_prophet.cwl
  out:
  - id: peptide_prophet_log
  - id: output_xml
  - id: peptide_prophet_folder_archive
  sbg:x: 673
  sbg:y: 39

hints:
- class: sbg:maxNumberOfParallelInstances
  value: '16'
- class: sbg:AWSInstanceType
  value: c4.8xlarge;ebs-gp2;1024
sbg:appVersion:
- v1.0
sbg:content_hash: a41154326e5bba96e319397dd770a857be57dfcc824d50b2bb8908e3f67f1c570
sbg:contributors:
- david.roberson
- prvst