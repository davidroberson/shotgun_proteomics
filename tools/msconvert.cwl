class: CommandLineTool
cwlVersion: v1.0
label: msconvert
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 4
  ramMin: 4000
- class: DockerRequirement
  dockerPull: chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:3.0.20066-729ef9c41
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
- id: raw_files
  type: File
  inputBinding:
    position: 0
    shellQuote: false
  sbg:fileTypes: RAW

outputs:
- id: std_out
  type: File?
  outputBinding:
    glob: std.out
    outputEval: $(inheritMetadata(self, inputs.raw_files))
- id: mzML
  type: File
  outputBinding:
    glob: '*mzML'
    outputEval: $(inheritMetadata(self, inputs.raw_files))
stdout: std.out

baseCommand:
- wine msconvert --mzML --64 --mz64 --inten64 --filter "peakPicking true 1-"
id: david.roberson/philosopher-dev/msconvert/12
sbg:appVersion:
- v1.0
sbg:content_hash: aa2a531d96d309831381da7b8ccc2a5b0f775111dfa7a92192d8c727132bc723d
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: david.roberson
sbg:createdOn: 1588617862
sbg:sbgMaintained: false
sbg:validationErrors: []
