class: CommandLineTool
cwlVersion: v1.0
label: Philosopher PeptideProphet
doc: |-
  ```
  Peptide assignment validation

  Usage:
    philosopher peptideprophet [flags]

  Flags:
        --accmass            use accurate mass model binning
        --clevel int         set Conservative Level in neg_stdev from the neg_mean, low numbers are less conservative, high numbers are more conservative
        --combine            combine the results from PeptideProphet into a single result file
        --database string    path to the database
        --decoy string       semi-supervised mode, protein name prefix to identify decoy entries (default "rev_")
        --decoyprobs         compute possible non-zero probabilities for decoy entries on the last iteration
        --enzyme string      enzyme used in sample
        --expectscore        use expectation value as the only contributor to the f-value for modeling
        --glyc               enable peptide glyco motif model
    -h, --help               help for peptideprophet
        --ignorechg string   use comma to separate the charge states to exclude from modeling
        --masswidth float    model mass width (default 5)
        --minpeplen int      minimum peptide length not rejected (default 7)
        --minprob float      report results with minimum probability (default 0.05)
        --nomass             disable mass model
        --nonmc              disable NMC missed cleavage model
        --nonparam           use semi-parametric modeling, must be used in conjunction with --decoy option
        --nontt              disable NTT enzymatic termini model
        --output string      output name prefix (default "interact")
        --phospho            enable peptide phospho motif model
        --ppm                use ppm mass error instead of Daltons for mass modeling```


  ```
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 2000
- class: DockerRequirement
  dockerPull: prvst/philosopher:latest
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.pepXML)
  - $(inputs.mzML)
  - $(inputs.workspace_in)
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
- id: accmass
  doc: use accurate mass model binning
  type: boolean?
  inputBinding:
    prefix: --accmass
    position: 0
    shellQuote: false
- id: combine
  doc: combine the results from PeptideProphet into a single result file
  type: boolean?
  inputBinding:
    prefix: --combine
    position: 1
    shellQuote: false
- id: --database
  doc: path to the database
  type: File
  inputBinding:
    prefix: --database
    position: 2
    shellQuote: false
- id: decoy
  doc: |-
    semi-supervised mode, protein name prefix to identify decoy entries (default "rev_")
  type: string?
  default: rev_
  inputBinding:
    prefix: --decoy
    position: 3
    shellQuote: false
- id: decoyprobs
  doc: compute possible non-zero probabilities for decoy entries on the last iteration
  type: boolean?
  inputBinding:
    prefix: --decoyprobs
    position: 4
    shellQuote: false
- id: enzyme
  doc: enzyme used in sample
  type: string?
  default: trypsin
  inputBinding:
    prefix: --enzyme
    position: 5
    shellQuote: false
- id: expectscore
  doc: use expectation value as the only contributor to the f-value for modeling
  type: boolean?
  inputBinding:
    prefix: --expectscore
    position: 6
    shellQuote: false
- id: masswidth
  doc: model mass width (default 5)
  type: float?
  default: 5
  inputBinding:
    prefix: --masswidth
    position: 7
    shellQuote: false
- id: minpeplen
  doc: minimum peptide length not rejected (default 7)
  type: int?
  default: 7
  inputBinding:
    prefix: --minpeplen
    position: 8
    shellQuote: false
- id: minprob
  doc: report results with minimum probability (default 0.05)
  type: float?
  default: 0.05
  inputBinding:
    prefix: --minprob
    position: 9
    shellQuote: false
- id: nonparam
  doc: use semi-parametric modeling, must be used in conjunction with --decoy option
  type: boolean?
  inputBinding:
    prefix: --nonparam
    position: 10
    shellQuote: false
- id: nontt
  doc: disable NTT enzymatic termini model
  type: boolean?
  inputBinding:
    prefix: --nontt
    position: 11
    shellQuote: false
- id: ppm
  doc: use ppm mass error instead of Daltons for mass modeling
  type: boolean?
  inputBinding:
    prefix: --ppm
    position: 12
    shellQuote: false
- id: pepXML
  type: File[]
- id: mzML
  type: File[]
- id: workspace_in
  type: Directory

outputs:
- id: peptide_prophet_log
  type: File
  outputBinding:
    glob: $(inputs.pepXML[0].metadata["Plex or dataset name"]).peptide_prophet.log
    outputEval: $(inheritMetadata(self, inputs.pepXML))
- id: output_xml
  type: File[]
  outputBinding:
    glob: '*pep.xml'
    outputEval: $(inheritMetadata(self, inputs.pepXML))
- id: peptide_prophet_folder_archive
  type: File?
  outputBinding:
    glob: $(inputs.pepXML[0].metadata["Plex or dataset name"]).tar.gz
    outputEval: $(inheritMetadata(self, inputs.pepXML))

baseCommand:
- philosopher peptideprophet
arguments:
- prefix: ''
  position: 90
  valueFrom: '*.pepXML'
  shellQuote: false
- prefix: ''
  position: 91
  valueFrom: '> $(inputs.pepXML[0].metadata["Plex or dataset name"]).peptide_prophet.log'
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: |-
    && tar -cvzf $(inputs.pepXML[0].metadata["Plex or dataset name"]).tar.gz *.log *.mzML *.pepXML *pep.xml .meta
  shellQuote: false
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/philosopher-peptideprophet/28/raw/
sbg:appVersion:
- v1.0
sbg:categories:
- Proteomics
sbg:content_hash: a8daf778c862975403d17aa3c57ae6a3e9c8157dd430b301e370ad73763855e20
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1589572965
sbg:id: david.roberson/philosopher-dev/philosopher-peptideprophet/28
sbg:image_url:
sbg:latestRevision: 28
sbg:links:
- id: https://github.com/Nesvilab/philosopher
  label: Github Project
sbg:sbgMaintained: false
sbg:toolAuthor: Felipe da Veiga Leprevost
sbg:toolkitVersion: Philosopher
sbg:validationErrors: []
sbg:wrapperAuthor: Felipe da Veiga Leprevost; David Roberson
