class: CommandLineTool
cwlVersion: v1.0
label: Philosopher Database
doc: |-
  ```
  Usage:
    philosopher database [flags]

  Flags:
        --add string        add custom sequences (UniProt FASTA format only)
        --annotate string   process a ready-to-use database
        --contam            add common contaminants
        --custom string     use a pre-formatted custom database
        --enzyme string     enzyme for digestion (trypsin, lys_c, lys_n, glu_c, chymotrypsin) (default "trypsin")
    -h, --help              help for database
        --id string         UniProt proteome ID
        --isoform           add isoform sequences
        --nodecoys          don't add decoys to the database
  ```
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 0
  ramMin: 2000
- class: DockerRequirement
  dockerPull: prvst/philosopher:3.2.3
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.workspace_in)
- class: InlineJavascriptRequirement

inputs:
- id: add
  doc: add custom sequences (UniProt FASTA format only)
  type: string?
  default:
  inputBinding:
    prefix: --add
    position: 0
    shellQuote: false
- id: annotate
  doc: process a ready-to-use database
  type: File?
  inputBinding:
    prefix: --annotate
    position: 1
    shellQuote: false
- id: contam
  doc: add common contaminants
  type: boolean?
  inputBinding:
    prefix: --contam
    position: 3
    shellQuote: false
- id: custom
  doc: use a pre-formatted custom database
  type: string?
  inputBinding:
    prefix: --custom
    position: 0
    shellQuote: false
- id: enzyme
  doc: |-
    enzyme for digestion (trypsin, lys_c, lys_n, glu_c, chymotrypsin) (default "trypsin")
  type: string?
  default: trypsin
  inputBinding:
    prefix: --enzyme
    position: 5
    shellQuote: false
- id: id
  doc: UniProt proteome ID
  type: string?
  inputBinding:
    prefix: --id
    position: 6
    shellQuote: false
- id: isoform
  doc: add isoform sequences
  type: boolean?
  inputBinding:
    prefix: --isoform
    position: 7
    shellQuote: false
- id: nodecoys
  doc: don't add decoys to the database
  type: boolean?
  inputBinding:
    prefix: --nodecoys
    position: 8
    shellQuote: false
- id: prefix
  type: string?
  default: rev_
  inputBinding:
    prefix: --prefix
    position: 9
    shellQuote: false
- id: reviewed
  type: boolean?
  inputBinding:
    prefix: --reviewed
    position: 10
    shellQuote: false
- id: workspace_in
  type: Directory
  inputBinding:
    position: 0
    shellQuote: false

outputs:
- id: output
  type: File?
  outputBinding:
    glob: std.out
- id: workspace
  type: Directory
  outputBinding:
    glob: .meta
stdout: std.out

baseCommand:
- philosopher database
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-database/10/raw/
sbg:appVersion:
- v1.0
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1588885005
