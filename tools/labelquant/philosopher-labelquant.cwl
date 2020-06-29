class: CommandLineTool
cwlVersion: v1.0
label: Philosopher Labelquant
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: prvst/philosopher:latest

inputs:
- id: annot
  doc: annotation file with custom names for the TMT channels
  type: string?
  default: annotation.txt
  inputBinding:
    prefix: --annot
    position: 0
    shellQuote: false
- id: bestpsm
  doc: select the best PSMs for protein quantification
  type: boolean?
  default: true
  inputBinding:
    prefix: --bestpsm
    position: 1
    shellQuote: false
- id: brand
  doc: isobaric labeling brand (tmt, itraq)
  type: string?
  default: tmt
  inputBinding:
    prefix: --brand
    position: 2
    shellQuote: false
- id: dir
  doc: folder path containing the raw files
  type: string?
  default: .
  inputBinding:
    prefix: --dir
    position: 3
    shellQuote: false
- id: level
  doc: ms level for the quantification (default 2)
  type: int?
  default: 2
  inputBinding:
    prefix: --level
    position: 4
    shellQuote: false
- id: minprob
  doc: only use PSMs with the specified minimum probability score (default 0.7)
  type: float?
  default: 0.7
  inputBinding:
    prefix: --minprob
    position: 5
    shellQuote: false
- id: plex
  doc: number of reporter ion channels
  type: int?
  default: 10
  inputBinding:
    prefix: --plex
    position: 6
    shellQuote: false
- id: purity
  doc: ion purity threshold (default 0.5)
  type: float?
  default: 0.5
  inputBinding:
    prefix: --purity
    position: 7
    shellQuote: false
- id: removelow
  doc: |-
    ignore the lower % of PSMs based on their summed abundances. 0 means no removal, entry value must be a decimal
  type: float?
  default: 0.03
  inputBinding:
    prefix: --removelow
    position: 8
    shellQuote: false
- id: tol
  doc: m/z tolerance in ppm (default 20)
  type: float?
  default: 20
  inputBinding:
    prefix: --tol
    position: 9
    shellQuote: false
- id: uniqueonly
  doc: report quantification based only on unique peptides
  type: boolean?
  default: true
  inputBinding:
    prefix: --uniqueonly
    position: 9
    shellQuote: false

outputs: []

baseCommand:
- philosopher labelquant
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-labelquant/1/raw/
sbg:appVersion:
- v1.0
sbg:content_hash: a4ea8255b0da41765f710b97eacae10086e3298763f14f54d0bd0b520627ca7c8
sbg:contributors:
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1591645781
sbg:sbgMaintained: false
sbg:validationErrors: []
