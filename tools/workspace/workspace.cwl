class: CommandLineTool
cwlVersion: v1.0
label: Philosopher Workspace
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 100
- class: DockerRequirement
  dockerPull: prvst/philosopher:3.2.3
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.pepXML)
- class: InlineJavascriptRequirement

inputs:
- id: init
  doc: Initialize the workspace
  type: boolean?
  default:
  inputBinding:
    prefix: --init
    position: 0
    shellQuote: false
- id: analytics
  doc: reports when a workspace is created for usage estimation (default true)
  type: boolean?
  inputBinding:
    prefix: --analytics
    position: 0
    shellQuote: false
- id: backup
  doc: create a backup of the experiment meta data
  type: boolean?
  inputBinding:
    prefix: --backup
    position: 0
    shellQuote: false
- id: clean
  doc: remove the workspace and all meta data. Experimental file are kept intact
  type: boolean?
  inputBinding:
    prefix: --clean
    position: 0
    shellQuote: false
- id: nocheck
  doc: do not check for new versions
  type: boolean?
  inputBinding:
    prefix: --nocheck
    position: 0
    shellQuote: false

outputs:
- id: std_out
  type: File
  outputBinding:
    glob: std.out
- id: workspace
  type: Directory?
  outputBinding:
    glob: .meta
stdout: std.out

baseCommand:
- philosopher workspace ./
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-workspace/13/raw/
sbg:appVersion:
- v1.0
sbg:content_hash: a8b962c4ee4f4f6f8c26508c69cf2a54fc620de3a1bed4fa9ee4bbc997d014c88
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1588707861
