class: CommandLineTool
cwlVersion: v1.0
label: Philosopher Freequant
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 0
  ramMin: 8000
- class: DockerRequirement
  dockerPull: prvst/philosopher:latest

inputs:
- id: dir
  doc: folder path containing the raw files
  type: string?
  default: .
  inputBinding:
    prefix: --dir
    position: 0
    shellQuote: false
- id: isolated
  doc: use the isolated ion instead of the selected ion for quantification
  type: boolean?
  default: true
  inputBinding:
    prefix: --isolated
    position: 1
    shellQuote: false
- id: ptw
  doc: specify the time windows for the peak (minute) (default 0.4)
  type: float?
  default: 0.4
  inputBinding:
    prefix: --ptw
    position: 2
    shellQuote: false
- id: tol
  doc: m/z tolerance in ppm (default 10)
  type: int?
  inputBinding:
    prefix: --tol
    position: 3
    shellQuote: false

outputs: []

baseCommand:
- philosopher freequant
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-freequant/1/raw/
sbg:appVersion:
- v1.0
sbg:content_hash: a0a01b7b0c69038039298dcb3472fe86b0cf790d63a1102f93102651f7e6317c7
sbg:contributors:
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1591644624
sbg:sbgMaintained: false
sbg:validationErrors: []
