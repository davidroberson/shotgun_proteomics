class: CommandLineTool
cwlVersion: v1.0
label: Philosopher Report
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 0
  ramMin: 2000
- class: DockerRequirement
  dockerPull: prvst/philosopher:latest
- class: InitialWorkDirRequirement
  listing:
  - entryname: philosopher_report.sh
    writable: false
    entry: |-
      tar -xvzf $(inputs.workspace_in.path)

      cd $(inputs.workspace_in.metadata["Plex or dataset name"])

      philosopher report $@

      cd ../

      mkdir $(inputs.workspace_in.metadata["Plex or dataset name"])_report_files

      cp $(inputs.workspace_in.metadata["Plex or dataset name"])/*tsv $(inputs.workspace_in.metadata["Plex or dataset name"])_report_files
- class: InlineJavascriptRequirement

inputs:
- id: decoys
  type: boolean?
  inputBinding:
    prefix: --decoys
    position: 0
    shellQuote: false
- id: msstats
  type: boolean?
  inputBinding:
    prefix: --msstats
    position: 1
    shellQuote: false
- id: mzid
  type: boolean?
  inputBinding:
    prefix: --mzid
    position: 2
    shellQuote: false
- id: workspace_in
  type: File

outputs:
- id: report_outputs
  type: Directory?
  outputBinding:
    glob: "$(inputs.workspace_in.metadata['Plex or dataset name'])_report_files "
- id: script
  type: File?
  outputBinding:
    glob: philosopher_report.sh

baseCommand:
- bash philosopher_report.sh
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-report/14/raw/
sbg:appVersion:
- v1.0
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1589996818
