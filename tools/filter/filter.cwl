class: CommandLineTool
cwlVersion: v1.0
label: Philosopher Filter
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 0
  ramMin: 8000
- class: DockerRequirement
  dockerPull: prvst/philosopher:latest
- class: InitialWorkDirRequirement
  listing:
  - entryname: philosopher_filter.sh
    writable: false
    entry: |+
      mkdir $(inputs.workspace_in.metadata["Plex or dataset name"])

      tar -xvzf $(inputs.workspace_in.path) -C $(inputs.workspace_in.metadata["Plex or dataset name"])

      cd $(inputs.workspace_in.metadata["Plex or dataset name"])

      echo $@

      philosopher filter --pepxml ./ $@ &&

      cd ../

      sleep 180

      tar -cvzf $(inputs.workspace_in.metadata["Plex or dataset name"]).tar.gz $(inputs.workspace_in.metadata["Plex or dataset name"]) || true


- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file)) {
            file['metadata'] = {}
        }
        for (var key in metadata) {
            file['metadata'][key] = metadata[key];
        }
        return file
    };
    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!o2) {
            return o1;
        };
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
            for (var key in commonMetadata) {
                if (!(key in example)) {
                    delete commonMetadata[key]
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
            if (o1.secondaryFiles) {
                o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)
            }
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
                if (o1[i].secondaryFiles) {
                    o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)
                }
            }
        }
        return o1;
    };

inputs:
- id: 2d
  type: boolean?
  inputBinding:
    prefix: --2d
    position: 0
    shellQuote: false
- id: inference
  type: boolean?
  inputBinding:
    prefix: --inference
    position: 1
    shellQuote: false
- id: ion
  doc: peptide ion FDR level (default 0.01)
  type: float?
  default: 0.01
  inputBinding:
    prefix: --ion
    position: 2
    shellQuote: false
- id: mapmods
  type: boolean?
  inputBinding:
    prefix: --mapmods
    position: 3
    shellQuote: false
- id: models
  doc: print model distribution
  type: boolean?
  inputBinding:
    prefix: --models
    position: 4
    shellQuote: false
- id: pep
  doc: peptide FDR level (default 0.01)
  type: float?
  default: 0.01
  inputBinding:
    prefix: --pep
    position: 5
    shellQuote: false
- id: pepProb
  doc: top peptide probability threshold for the FDR filtering (default 0.7)
  type: float?
  default: 0.7
  inputBinding:
    prefix: --pepProb
    position: 6
    shellQuote: false
- id: picked
  doc: apply the picked FDR algorithm before the protein scoring
  type: boolean?
  inputBinding:
    prefix: --picked
    position: 8
    shellQuote: false
- id: prot
  doc: protein FDR level (default 0.01)
  type: float?
  default: 0.01
  inputBinding:
    prefix: --prot
    position: 9
    shellQuote: false
- id: protProb
  doc: |-
    protein probability threshold for the FDR filtering (not used with the razor algorithm) (default 0.5)
  type: float?
  default: 0.05
  inputBinding:
    prefix: --protProb
    position: 10
    shellQuote: false
- id: protxml
  doc: protXML file path
  type: string?
  default:
  inputBinding:
    prefix: --protxml
    position: 11
    shellQuote: false
- id: psm
  doc: psm FDR level (default 0.01)
  type: float?
  default: 0.01
  inputBinding:
    prefix: --psm
    position: 12
    shellQuote: false
- id: razor
  doc: use razor peptides for protein FDR scoring
  type: boolean?
  inputBinding:
    prefix: --razor
    position: 13
    shellQuote: false
- id: sequential
  doc: |-
    alternative algorithm that estimates FDR using both filtered PSM and protein lists
  type: boolean?
  inputBinding:
    prefix: --sequential
    position: 14
    shellQuote: false
- id: tag
  doc: decoy tag (default "rev_")
  type: string?
  default: rev_
  inputBinding:
    prefix: --tag
    position: 15
    shellQuote: false
- id: weight
  doc: threshold for defining peptide uniqueness (default 1)
  type: float?
  default: 1
  inputBinding:
    prefix: --weight
    position: 16
    shellQuote: false
- id: workspace_in
  type: File
- id: pepXML
  type: File[]?

outputs:
- id: log_file
  type: File?
  outputBinding:
    glob: std.out
    outputEval: $(inheritMetadata(self, inputs.pepXML))
- id: workspace_out
  type: File?
  outputBinding:
    glob: $(inputs.workspace_in.metadata["Plex or dataset name"]).tar.gz
    outputEval: $(inheritMetadata(self, inputs.workspace_in))
- id: script
  type: File?
  outputBinding:
    glob: philosopher_filter.sh

baseCommand:
- bash philosopher_filter.sh
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-filter/15/raw/
sbg:appVersion:
- v1.0
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1589995391
