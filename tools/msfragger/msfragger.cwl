class: CommandLineTool
cwlVersion: v1.0
label: MSFragger
doc: |-
  ```
  To perform a search either use a parameter file:
                  1) java -jar MSFragger.jar <parameter file> <list of mzML/mzXML/MGF/RAW/.d files>
          Or specify options on the command line:
                  2) java -jar MSFragger.jar <options> <list of mzML/mzXML/MGF/RAW/.d files>

  To generate default parameter files use --config flag. E.g. "java -jar MSFragger.jar --config"

  ```
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 2
  ramMin: 8000
- class: DockerRequirement
  dockerPull: cgc-images.sbgenomics.com/prvst/msfragger:2.3
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.mzML)
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
- id: database_name
  doc: Path to the protein database file in FASTA format.
  type: File
  inputBinding:
    prefix: --database_name
    position: 5
    shellQuote: false
- id: precursor_mass_lower
  doc: Lower bound of the precursor mass window.
  type: int?
  default: -50
  inputBinding:
    prefix: --precursor_mass_lower
    position: 5
    shellQuote: false
- id: precursor_mass_upper
  doc: Upper bound of the precursor mass window.
  type: int?
  default: 50
  inputBinding:
    prefix: --precursor_mass_upper
    position: 5
    shellQuote: false
- id: precursor_mass_units
  doc: Precursor mass tolerance units (0 for Da, 1 for ppm).
  type: int?
  default: 1
  inputBinding:
    prefix: --precursor_mass_units
    position: 5
    shellQuote: false
- id: precursor_true_tolerance
  doc: True precursor mass tolerance (window is +/- this value).
  type: int?
  default: 20
  inputBinding:
    prefix: --precursor_true_tolerance
    position: 5
    shellQuote: false
- id: precursor_true_units
  doc: True precursor mass tolerance units (0 for Da, 1 for ppm).
  type: int?
  default: 1
  inputBinding:
    prefix: --precursor_true_units
    position: 5
    shellQuote: false
- id: fragment_mass_tolerance
  doc: Fragment mass tolerance (window is +/- this value).
  type: int?
  default: 20
  inputBinding:
    prefix: --fragment_mass_tolerance
    position: 6
    shellQuote: false
- id: fragment_mass_units
  doc: Fragment mass tolerance units (0 for Da, 1 for ppm).
  type: int?
  default: 1
  inputBinding:
    prefix: --fragment_mass_units
    position: 7
    shellQuote: false
- id: calibrate_mass
  doc: |-
    Perform mass calibration (0 for OFF, 1 for ON, 2 for ON and find optimal parameters).
  type: int?
  default: 2
  inputBinding:
    prefix: --calibrate_mass
    position: 8
    shellQuote: false
- id: write_calibrated_mgf
  doc: Write calibrated MS2 scan to a MGF file (0 for No, 1 for Yes).
  type: int?
  default: 1
  inputBinding:
    prefix: --write_calibrated_mgf
    position: 9
    shellQuote: false
- id: decoy_prefix
  doc: Prefix added to the decoy protein ID.
  type: string?
  default: rev_
  inputBinding:
    prefix: --decoy_prefix
    position: 10
    shellQuote: false
- id: isotope_error
  doc: Also search for MS/MS events triggered on specified isotopic peaks.
  type: string?
  default: 0/1/2
  inputBinding:
    prefix: --isotope_error
    position: 11
    shellQuote: false
- id: mass_offsets
  doc: Creates multiple precursor tolerance windows with specified mass offsets.
  type: int?
  default: 0
  inputBinding:
    prefix: --mass_offsets
    position: 12
    shellQuote: false
- id: precursor_mass_mode
  doc: One of isolated/selected/recalculated.
  type: string?
  default: selected
  inputBinding:
    prefix: --precursor_mass_mode
    position: 13
    shellQuote: false
- id: localize_delta_mass
  doc: |-
    Include fragment ions mass-shifted by unknown modifications (recommended for open and mass offset searches) (0 for OFF, 1 for ON).
  type: int?
  default: 0
  inputBinding:
    prefix: --localize_delta_mass
    position: 14
    shellQuote: false
- id: fragment_ion_series
  doc: Ion series used in search, specify any of a,b,c,x,y,z (comma separated).
  type: string?
  default: b,y
  inputBinding:
    prefix: --fragment_ion_series
    position: 15
    shellQuote: false
- id: search_enzyme_name
  doc: Name of enzyme to be written to the pepXML file.
  type: string?
  default: Trypsin
  inputBinding:
    prefix: --search_enzyme_name
    position: 16
    shellQuote: false
- id: search_enzyme_cutafter
  doc: Residues after which the enzyme cuts.
  type: string?
  default: KR
  inputBinding:
    prefix: --search_enzyme_cutafter
    position: 17
    shellQuote: false
- id: search_enzyme_butnotafter
  doc: Residues that the enzyme will not cut before.
  type: string?
  default: P
  inputBinding:
    prefix: --search_enzyme_butnotafter
    position: 18
    shellQuote: false
- id: num_enzyme_termini
  doc: 0 for non-enzymatic, 1 for semi-enzymatic, and 2 for fully-enzymatic.
  type: int?
  default: 2
  inputBinding:
    prefix: --num_enzyme_termini
    position: 19
    shellQuote: false
- id: allowed_missed_cleavage
  doc: Allowed number of missed cleavages per peptide. Maximum value is 5.
  type: int?
  default: 1
  inputBinding:
    prefix: --allowed_missed_cleavage
    position: 20
    shellQuote: false
- id: clip_nTerm_M
  doc: |-
    Specifies the trimming of a protein N-terminal methionine as a variable modification (0 or 1).
  type: int?
  default: 1
  inputBinding:
    prefix: --clip_nTerm_M
    position: 21
    shellQuote: false
- id: variable_mod_01
  type: string?
  default: 15.99490_M_3
  inputBinding:
    prefix: --variable_mod_01
    position: 22
    shellQuote: false
- id: variable_mod_02
  type: string?
  default: 42.01060_[^_1
  inputBinding:
    prefix: --variable_mod_02
    position: 23
    shellQuote: false
- id: variable_mod_03
  type: string?
  inputBinding:
    prefix: --variable_mod_03
    position: 24
    shellQuote: false
- id: variable_mod_04
  type: string?
  inputBinding:
    prefix: --variable_mod_04
    position: 25
    shellQuote: false
- id: variable_mod_05
  type: string?
  inputBinding:
    prefix: --variable_mod_05
    position: 26
    shellQuote: false
- id: allow_multiple_variable_mods_on_residue
  doc: Allow each residue to be modified by multiple variable modifications (0 or
    1).
  type: int?
  inputBinding:
    prefix: --allow_multiple_variable_mods_on_residue
    position: 27
    shellQuote: false
- id: max_variable_mods_per_peptide
  doc: Maximum total number of variable modifications per peptide.
  type: int?
  default: 3
  inputBinding:
    prefix: --max_variable_mods_per_peptide
    position: 28
    shellQuote: false
- id: max_variable_mods_combinations
  doc: Maximum number of modified forms allowed for each peptide (up to 65534).
  type: int?
  default: 5000
  inputBinding:
    prefix: --max_variable_mods_combinations
    position: 29
    shellQuote: false
- id: output_file_extension
  doc: File extension of output files.
  type: string?
  default: pepXML
  inputBinding:
    prefix: --output_file_extension
    position: 30
    shellQuote: false
- id: output_format
  doc: File format of output files (pepXML or tsv).
  type: string?
  default: pepXML
  inputBinding:
    prefix: --output_format
    position: 31
    shellQuote: false
- id: output_report_topN
  doc: Reports top N PSMs per input spectrum.
  type: int?
  default: 1
  inputBinding:
    prefix: --output_report_topN
    position: 32
    shellQuote: false
- id: output_max_expect
  doc: |-
    Suppresses reporting of PSM if top hit has expectation value greater than this threshold.
  type: int?
  default: 50
  inputBinding:
    prefix: --output_max_expect
    position: 33
    shellQuote: false
- id: report_alternative_proteins
  doc: |-
    Report alternative proteins for peptides that are found in multiple proteins (0 for no, 1 for yes).
  type: int?
  default: 0
  inputBinding:
    prefix: --report_alternative_proteins
    position: 34
    shellQuote: false
- id: precursor_charge
  doc: |-
    Assumed range of potential precursor charge states. Only relevant when override_charge is set to 1.
  type: string?
  default: '1_4'
  inputBinding:
    prefix: --precursor_charge
    position: 35
    shellQuote: false
- id: override_charge
  doc: |-
    Ignores precursor charge and uses charge state specified in precursor_charge range (0 or 1).
  type: int?
  default: 0
  inputBinding:
    prefix: --override_charge
    position: 36
    shellQuote: false
- id: digest_min_length
  doc: Minimum length of peptides to be generated during in-silico digestion.
  type: int?
  default: 7
  inputBinding:
    prefix: --digest_min_length
    position: 37
    shellQuote: false
- id: digest_max_length
  doc: Maximum length of peptides to be generated during in-silico digestion.
  type: int?
  default: 50
  inputBinding:
    prefix: --digest_max_length
    position: 38
    shellQuote: false
- id: digest_mass_range
  doc: Mass range of peptides to be generated during in-silico digestion in Daltons.
  type: string?
  default: 500.0_5000.0
  inputBinding:
    prefix: --digest_mass_range
    position: 39
    shellQuote: false
- id: max_fragment_charge
  doc: Maximum charge state for theoretical fragments to match (1-4).
  type: int?
  default: 2
  inputBinding:
    prefix: --max_fragment_charge
    position: 40
    shellQuote: false
- id: track_zero_topN
  doc: |-
    Track top N unmodified peptide results separately from main results internally for boosting features. Should be set to a number greater than output_report_topN if zero bin boosting is desired.
  type: int?
  default: 0
  inputBinding:
    prefix: --track_zero_topN
    position: 41
    shellQuote: false
- id: zero_bin_accept_expect
  doc: |-
    Ranks a zero-bin hit above all non-zero-bin hit if it has expectation less than this value.
  type: float?
  default: 0
  inputBinding:
    prefix: --zero_bin_accept_expect
    position: 42
    shellQuote: false
- id: zero_bin_mult_expect
  doc: |-
    Multiplies expect value of PSMs in the zero-bin during  results ordering (set to less than 1 for boosting).
  type: float?
  default: 1
  inputBinding:
    prefix: --zero_bin_mult_expect
    position: 43
    shellQuote: false
- id: add_topN_complementary
  doc: |-
    Inserts complementary ions corresponding to the top N most intense fragments in each experimental spectra.
  type: int?
  default: 0
  inputBinding:
    prefix: --add_topN_complementary
    position: 44
    shellQuote: false
- id: minimum_peaks
  doc: Minimum number of peaks in experimental spectrum for matching.
  type: int?
  default: 15
  inputBinding:
    prefix: --minimum_peaks
    position: 45
    shellQuote: false
- id: use_topN_peaks
  doc: Pre-process experimental spectrum to only use top N peaks.
  type: int?
  default: 150
  inputBinding:
    prefix: --use_topN_peaks
    position: 46
    shellQuote: false
- id: deisotope
  doc: Perform deisotoping or not.
  type: int?
  default: 0
  inputBinding:
    prefix: --deisotope
    position: 47
    shellQuote: false
- id: min_fragments_modelling
  doc: Minimum number of matched peaks in PSM for inclusion in statistical modeling.
  type: int?
  default: 2
  inputBinding:
    prefix: --min_fragments_modelling
    position: 48
    shellQuote: false
- id: min_matched_fragments
  doc: Minimum number of matched peaks for PSM to be reported.
  type: int?
  default: 4
  inputBinding:
    prefix: --min_matched_fragments
    position: 49
    shellQuote: false
- id: minimum_ratio
  doc: |-
    Filters out all peaks in experimental spectrum less intense than this multiple of the base peak intensity.
  type: float?
  default: 0.01
  inputBinding:
    prefix: --minimum_ratio
    position: 50
    shellQuote: false
- id: clear_mz_range
  doc: Removes peaks in this m/z range prior to matching.
  type: string?
  default: 0.0_0.0
  inputBinding:
    prefix: --clear_mz_range
    position: 51
    shellQuote: false
- id: remove_precursor_peak
  doc: |-
    Remove precursor peaks from tandem mass spectra. 0 = not remove; 1 = remove the peak with precursor charge; 2 = remove the peaks with all charge states.
  type: int?
  default: 0
  inputBinding:
    prefix: --remove_precursor_peak
    position: 52
    shellQuote: false
- id: add_Cterm_peptide
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Cterm_peptide
    position: 53
    shellQuote: false
- id: add_Nterm_peptide
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Nterm_peptide
    position: 54
    shellQuote: false
- id: add_Cterm_protein
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Cterm_protein
    position: 55
    shellQuote: false
- id: add_Nterm_protein
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Nterm_protein
    position: 56
    shellQuote: false
- id: add_G_glycine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_G_glycine
    position: 57
    shellQuote: false
- id: add_A_alanine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_A_alanine
    position: 58
    shellQuote: false
- id: add_S_serine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_S_serine
    position: 59
    shellQuote: false
- id: add_P_proline
  type: float?
  default: 0
  inputBinding:
    prefix: --add_P_proline
    position: 60
    shellQuote: false
- id: add_V_valine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_V_valine
    position: 61
    shellQuote: false
- id: add_T_threonine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_T_threonine
    position: 62
    shellQuote: false
- id: add_C_cysteine
  type: float?
  default: 57.021464
  inputBinding:
    prefix: --add_C_cysteine
    position: 63
    shellQuote: false
- id: add_L_leucine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_L_leucine
    position: 64
    shellQuote: false
- id: add_I_isoleucine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_I_isoleucine
    position: 65
    shellQuote: false
- id: add_N_asparagine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_N_asparagine
    position: 66
    shellQuote: false
- id: add_D_aspartic_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_D_aspartic_acid
    position: 67
    shellQuote: false
- id: add_Q_glutamine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Q_glutamine
    position: 68
    shellQuote: false
- id: add_K_lysine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_K_lysine
    position: 69
    shellQuote: false
- id: add_E_glutamic_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_E_glutamic_acid
    position: 70
    shellQuote: false
- id: add_M_methionine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_M_methionine
    position: 71
    shellQuote: false
- id: add_H_histidine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_H_histidine
    position: 72
    shellQuote: false
- id: add_F_phenylalanine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_F_phenylalanine
    position: 73
    shellQuote: false
- id: add_R_arginine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_R_arginine
    position: 74
    shellQuote: false
- id: add_Y_tyrosine
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Y_tyrosine
    position: 75
    shellQuote: false
- id: add_W_tryptophan
  type: float?
  default: 0
  inputBinding:
    prefix: --add_W_tryptophan
    position: 76
    shellQuote: false
- id: add_B_user_amino_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_B_user_amino_acid
    position: 77
    shellQuote: false
- id: add_J_user_amino_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_J_user_amino_acid
    position: 78
    shellQuote: false
- id: add_O_user_amino_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_O_user_amino_acid
    position: 79
    shellQuote: false
- id: add_U_user_amino_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_U_user_amino_acid
    position: 80
    shellQuote: false
- id: add_X_user_amino_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_X_user_amino_acid
    position: 81
    shellQuote: false
- id: add_Z_user_amino_acid
  type: float?
  default: 0
  inputBinding:
    prefix: --add_Z_user_amino_acid
    position: 82
    shellQuote: false
- id: Xmx
  type: int?
  default: 8
- id: mzML
  type: File[]

outputs:
- id: standard_out
  type: File
  outputBinding:
    glob: $(inputs.mzML[0].metadata["Plex or dataset name"]).msfragger.log
    outputEval: $(inheritMetadata(self, inputs.mzML))
- id: pepxml
  type: File[]
  outputBinding:
    glob: '*.pepXML'
    outputEval: $(inheritMetadata(self, inputs.mzML))
- id: mgf
  type: File?
  outputBinding:
    glob: '*.mgf'
    outputEval: $(inheritMetadata(self, inputs.mzML))
stdout: $(inputs.mzML[0].metadata["Plex or dataset name"]).msfragger.log

baseCommand:
- java
arguments:
- prefix: -Xmx
  position: 3
  valueFrom: $(inputs.Xmx)G
  separate: false
  shellQuote: false
- prefix: -jar
  position: 3
  valueFrom: /data/MSFragger-2.3.jar *.mzML
  shellQuote: false
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/philosopher-dev/msfragger/41/raw/
'null':
sbg:appVersion:
- v1.0
sbg:content_hash: a8b797fbc2c73abc7216fe9303152178252bd5d70ea4a9160405cf99e091b0755
sbg:contributors:
- david.roberson
- prvst
sbg:createdBy: prvst
sbg:createdOn: 1588707903
sbg:id: david.roberson/philosopher-dev/msfragger/41
sbg:image_url:
sbg:latestRevision: 41
sbg:modifiedBy: david.roberson
sbg:modifiedOn: 1593378507
sbg:project: david.roberson/philosopher-dev
sbg:projectName: michigan-pipeline
sbg:publisher: sbg
sbg:revision: 41
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: prvst
  sbg:modifiedOn: 1588707903
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: prvst
  sbg:modifiedOn: 1588810289
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588862405
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588863427
  sbg:revision: 3
  sbg:revisionNotes: added enzyme input string
- sbg:modifiedBy: prvst
  sbg:modifiedOn: 1588883964
  sbg:revision: 4
  sbg:revisionNotes: adding parameters
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588942317
  sbg:revision: 5
  sbg:revisionNotes: added std.out
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588942982
  sbg:revision: 6
  sbg:revisionNotes: removed most arguments, moved java flags to args
- sbg:modifiedBy: prvst
  sbg:modifiedOn: 1588945665
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588945687
  sbg:revision: 8
  sbg:revisionNotes: added pepxml output
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588945728
  sbg:revision: 9
  sbg:revisionNotes: added Xmx input ram for java
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1588945760
  sbg:revision: 10
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589233737
  sbg:revision: 11
  sbg:revisionNotes: added mzml file
- sbg:modifiedBy: prvst
  sbg:modifiedOn: 1589318292
  sbg:revision: 12
  sbg:revisionNotes: updating parameter names
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589811474
  sbg:revision: 13
  sbg:revisionNotes: removed space in java heap arg
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589811852
  sbg:revision: 14
  sbg:revisionNotes: correcting location of jar
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589819525
  sbg:revision: 15
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589819954
  sbg:revision: 16
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589820444
  sbg:revision: 17
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589820742
  sbg:revision: 18
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589820988
  sbg:revision: 19
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589821419
  sbg:revision: 20
  sbg:revisionNotes: splitting mzML path using js
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589821904
  sbg:revision: 21
  sbg:revisionNotes: removed --mzML flag
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589822666
  sbg:revision: 22
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589822754
  sbg:revision: 23
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589836256
  sbg:revision: 24
  sbg:revisionNotes: better standard output name
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589947257
  sbg:revision: 25
  sbg:revisionNotes: better output names again.
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589948220
  sbg:revision: 26
  sbg:revisionNotes: 4 cpu mins
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1589948613
  sbg:revision: 27
  sbg:revisionNotes: 2 cpus
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590027690
  sbg:revision: 28
  sbg:revisionNotes: workspace dir
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590028343
  sbg:revision: 29
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590029207
  sbg:revision: 30
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590030342
  sbg:revision: 31
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590030742
  sbg:revision: 32
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590031093
  sbg:revision: 33
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590031679
  sbg:revision: 34
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590033109
  sbg:revision: 35
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590033657
  sbg:revision: 36
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590034608
  sbg:revision: 37
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590038058
  sbg:revision: 38
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590930352
  sbg:revision: 39
  sbg:revisionNotes: folder input
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1590932384
  sbg:revision: 40
  sbg:revisionNotes: revert
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1593378507
  sbg:revision: 41
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
