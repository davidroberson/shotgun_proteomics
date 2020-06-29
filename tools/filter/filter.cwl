class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://sevenbridges.com'
id: >-
  https:_cgc_api_sbgenomics_com_v2_apps_david_roberson_philosopher_dev_philosopher_filter_15_raw_
baseCommand:
  - bash philosopher_filter.sh
inputs:
  - id: 2d
    type: boolean?
    inputBinding:
      position: 0
      prefix: '--2d'
      shellQuote: false
  - id: inference
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--inference'
      shellQuote: false
  - default: 0.01
    id: ion
    type: float?
    inputBinding:
      position: 2
      prefix: '--ion'
      shellQuote: false
    doc: peptide ion FDR level (default 0.01)
  - id: mapmods
    type: boolean?
    inputBinding:
      position: 3
      prefix: '--mapmods'
      shellQuote: false
  - id: models
    type: boolean?
    inputBinding:
      position: 4
      prefix: '--models'
      shellQuote: false
    doc: print model distribution
  - default: 0.01
    id: pep
    type: float?
    inputBinding:
      position: 5
      prefix: '--pep'
      shellQuote: false
    doc: peptide FDR level (default 0.01)
  - default: 0.7
    id: pepProb
    type: float?
    inputBinding:
      position: 6
      prefix: '--pepProb'
      shellQuote: false
    doc: top peptide probability threshold for the FDR filtering (default 0.7)
  - id: picked
    type: boolean?
    inputBinding:
      position: 8
      prefix: '--picked'
      shellQuote: false
    doc: apply the picked FDR algorithm before the protein scoring
  - default: 0.01
    id: prot
    type: float?
    inputBinding:
      position: 9
      prefix: '--prot'
      shellQuote: false
    doc: protein FDR level (default 0.01)
  - default: 0.05
    id: protProb
    type: float?
    inputBinding:
      position: 10
      prefix: '--protProb'
      shellQuote: false
    doc: >-
      protein probability threshold for the FDR filtering (not used with the
      razor algorithm) (default 0.5)
  - default: null
    id: protxml
    type: string?
    inputBinding:
      position: 11
      prefix: '--protxml'
      shellQuote: false
    doc: protXML file path
  - default: 0.01
    id: psm
    type: float?
    inputBinding:
      position: 12
      prefix: '--psm'
      shellQuote: false
    doc: psm FDR level (default 0.01)
  - id: razor
    type: boolean?
    inputBinding:
      position: 13
      prefix: '--razor'
      shellQuote: false
    doc: use razor peptides for protein FDR scoring
  - id: sequential
    type: boolean?
    inputBinding:
      position: 14
      prefix: '--sequential'
      shellQuote: false
    doc: >-
      alternative algorithm that estimates FDR using both filtered PSM and
      protein lists
  - default: rev_
    id: tag
    type: string?
    inputBinding:
      position: 15
      prefix: '--tag'
      shellQuote: false
    doc: decoy tag (default "rev_")
  - default: 1
    id: weight
    type: float?
    inputBinding:
      position: 16
      prefix: '--weight'
      shellQuote: false
    doc: threshold for defining peptide uniqueness (default 1)
  - id: workspace_in
    type: File
  - id: pepXML
    type: 'File[]?'
outputs:
  - id: log_file
    type: File?
    outputBinding:
      glob: std.out
      outputEval: '$(inheritMetadata(self, inputs.pepXML))'
  - id: workspace_out
    type: File?
    outputBinding:
      glob: '$(inputs.workspace_in.metadata["Plex or dataset name"]).tar.gz'
      outputEval: '$(inheritMetadata(self, inputs.workspace_in))'
  - id: script
    type: File?
    outputBinding:
      glob: philosopher_filter.sh
label: Philosopher Filter
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 0
  - class: DockerRequirement
    dockerPull: 'prvst/philosopher:latest'
  - class: InitialWorkDirRequirement
    listing:
      - entryname: philosopher_filter.sh
        entry: >+
          mkdir $(inputs.workspace_in.metadata["Plex or dataset name"])


          tar -xvzf $(inputs.workspace_in.path) -C
          $(inputs.workspace_in.metadata["Plex or dataset name"])


          cd $(inputs.workspace_in.metadata["Plex or dataset name"])


          echo $@


          philosopher filter --pepxml ./ $@ &&


          cd ../


          sleep 180


          tar -cvzf $(inputs.workspace_in.metadata["Plex or dataset
          name"]).tar.gz $(inputs.workspace_in.metadata["Plex or dataset name"])
          || true


        writable: false
  - class: InlineJavascriptRequirement
    expressionLib:
      - |-

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
'sbg:appVersion':
  - v1.0
'sbg:contributors':
  - david.roberson
  - prvst
'sbg:createdBy': prvst
'sbg:createdOn': 1589995391
