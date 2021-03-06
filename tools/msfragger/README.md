
```
Usage:

	To perform a search either:
		1) java -jar MSFragger.jar <parameter file> <list of mzML/mzXML/MGF/RAW/.d files>
		To generate default parameter files use --config flag. E.g. "java -jar MSFragger.jar --config"
	Or:
		2) java -jar MSFragger.jar <options> <list of mzML/mzXML/MGF/RAW/.d files>

Options:

--num_threads <integer>                       # Number of CPU threads to use, should be set to the 
                                              # number of logical processors; A value of 0 
                                              # (auto-detect) will cause MSFragger to use the 
                                              # auto-detected number of processors. Default: 0
--database_name <string>                      # Path to the protein database file in FASTA format.
--precursor_mass_lower <float>                # Lower bound of the precursor mass window. Default: -20
--precursor_mass_upper <float>                # Upper bound of the precursor mass window. Default: 20
--precursor_mass_units 0/1                    # Precursor mass tolerance units (0 for Da, 1 for ppm).
                                              # Default: 1
--precursor_true_tolerance <float>            # True precursor mass tolerance (window is +/- this value).
                                              # Used for tie breaker of results (in spectral ambiguous
                                              # cases), zero bin boosting in open searches (0 disables
                                              # these features), and mass calibration. This option is
                                              # STRONGLY recommended for open searches. Default: 20
--precursor_true_units 0/1                    # True precursor mass tolerance units (0 for Da, 1 for ppm).
                                              # Default: 1
--fragment_mass_tolerance <float>             # Fragment mass tolerance (window is +/- this value).
                                              # Default: 20
--fragment_mass_units 0/1                     # Fragment mass tolerance units (0 for Da, 1 for ppm).
                                              # Default: 1
--calibrate_mass 0/1/2                        # Perform mass calibration (0 for OFF, 1 for ON, 2 for ON
                                              # and find optimal parameters). Default: 2 
--write_calibrated_mgf 0/1                    # Write calibrated MS2 scan to a MGF file (0 for No, 1 for Yes).
                                              # Default: 1
--decoy_prefix <string>                       # Prefix added to the decoy protein ID. Default: <blank>
--isotope_error <string>                      # Also search for MS/MS events triggered on specified isotopic
                                              # peaks. Default: 0
--mass_offsets <string>                       # Creates multiple precursor tolerance windows with
                                              # specified mass offsets. These values are multiplexed
                                              # with the isotope error option. For example,
                                              # mass_offsets = 0/79.966 can be used as a restricted
                                              # 'open' search that looks for unmodified and phosphorylated
                                              # peptides. Setting isotope_error to 0/1/2 in combination
                                              # with this example will create search windows around
                                              # (0, 1, 2, 79.966, 80.966, 81.966). Default: 0
--precursor_mass_mode <string>                # One of isolated/selected/recalculated. Isolated uses 
                                              # the isolation m/z, selected uses the selected m/z, 
                                              # while recalculated uses a recalculated m/z from .ma 
                                              # files within the same directory. If the desired m/z 
                                              # type is not present for a scan, it will default to 
                                              # whatever m/z is available. Default: selected
--localize_delta_mass 0/1                     # Include fragment ions mass-shifted by unknown
                                              # modifications (recommended for open and mass offset 
                                              # searches). Default: 0
--delta_mass_exclude_ranges <string>          # Exclude mass range for searching with delta mass to remove
                                              # double counting of fragments in chimeric spectra and
                                              # instances of monoisotopic error. Default: \(-1.5,3.5\)
--fragment_ion_series <string>                # Ion series used in search, specify any of a,b,c,x,y,z
                                              # (comma separated). Default: b,y
--search_enzyme_name <string>                 # Name of enzyme to be written to the pepXML file. 
                                              # Default: Trypsin
--search_enzyme_cutafter <string>             # Residues after which the enzyme cuts (specified as
                                              # a string of amino acids). Default: KR
--search_enzyme_butnotafter <string>          # Residues that the enzyme will not cut before (misnomer:
                                              # should really be called butnotbefore). Default: <blank> 
--num_enzyme_termini 0/1/2                    # Number of enzyme termini (0 for non-enzymatic, 1 for
                                              # semi-enzymatic, and 2 for fully-enzymatic). Default: 2
--allowed_missed_cleavage <integer>           # Allowed number of missed cleavages per peptide. Maximum
                                              # value is 5. Default: 1
--clip_nTerm_M 0/1                            # Specifies the trimming of a protein N-terminal methionine
                                              # as a variable modification (0 or 1) Default: 1
--variable_mod_01 <string>                    # Set variable modifications. Check the document for
                                              # detail. Replacing all spaces with _. Default: 15.99490_M_3
--variable_mod_02 <string>                    # Set variable modifications. Check the document for detail. 
                                              # Replacing all spaces with _. Default: 42.01060_[^_1
--variable_mod_03 <string>                    # Set variable modifications. Check the document for detail. 
                                              # Replacing all spaces with _. Default: <blank>
--variable_mod_04 <string>                    # Set variable modifications. Check the document for detail. 
                                              # Replacing all spaces with _. Default: <blank>
--variable_mod_05 <string>                    # Set variable modifications. Check the document for detail. 
                                              # Replacing all spaces with _. Default: <blank>
--variable_mod_06 <string>                    # Set variable modifications. Check the document for detail. 
                                              # Replacing all spaces with _. Default: <blank>
--variable_mod_07 <string>                    # Set variable modifications. Check the document for detail. 
                                              # Replacing all spaces with _. Default: <blank>
--allow_multiple_variable_mods_on_residue 0/1 # Allow each residue to be modified by multiple variable
                                              # modifications (0 or 1). Default: 0
--max_variable_mods_per_peptide <integer>     # Maximum total number of variable modifications per peptide. 
                                              # Default: 3
--max_variable_mods_combinations <integer>    # Maximum number of modified forms allowed for each peptide
                                              # (up to 65534). Default: 5000.
--output_file_extension <string>              # File extension of output files. Default: pepXML
--output_format pepXML/tsv                    # File format of output files (pepXML or tsv). 
                                              # Default: pepXML
--output_report_topN <integer>                # Reports top N PSMs per input spectrum. Default: 1
--output_max_expect <float>                   # Suppresses reporting of PSM if top hit has expectation value
                                              # greater than this threshold. Default: 50.0
--report_alternative_proteins 0/1             # Report alternative proteins for peptides that are found 
                                              # in multiple proteins. 0=no, 1=yes. Default: 0
--precursor_charge <string>                   # Assumed range of potential precursor charge states. Only
                                              # relevant when override_charge is set to 1. Default: 1_4
--override_charge 0/1                         # Ignores precursor charge and uses charge state specified 
                                              # in precursor_charge range (0 or 1). Default: 0
--digest_min_length <integer>                 # Minimum length of peptides to be generated during 
                                              # in-silico digestion. Default: 7
--digest_max_length <integer>                 # Maximum length of peptides to be generated during 
                                              # in-silico digestion. Default: 50
--digest_mass_range <string>                  # Mass range of peptides to be generated during in-silico
                                              # digestion in Daltons (specified as a space separated 
                                              # range). Default: 500.0_5000.0
--max_fragment_charge <integer>               # Maximum charge state for theoretical fragments to match 
                                              # (1-4). Default: 2
--excluded_scan_list_file <string>            # Text file containing a list of scan names to be ignored
                                              # in the search. Default: <blank>
--track_zero_topN <integer>                   # Track top N unmodified peptide results separately from 
                                              # main results internally for boosting features. Should 
                                              # be set to a number greater than output_report_topN if 
                                              # zero bin boosting is desired. Default: 0
--zero_bin_accept_expect <float>              # Ranks a zero-bin hit above all non-zero-bin hit if it 
                                              # has expectation less than this value. Default: 0.0
--zero_bin_mult_expect <float>                # Multiplies expect value of PSMs in the zero-bin during 
                                              # results ordering (set to less than 1 for boosting). 
                                              # Default: 1.0
--add_topN_complementary <integer>            # Inserts complementary ions corresponding to the top N 
                                              # most intense fragments in each experimental spectra. 
                                              # Useful for recovery of modified peptides near C-terminal 
                                              # in open search. Should be set to 0 (disabled) otherwise. 
                                              # Default: 0
--minimum_peaks <integer>                     # Minimum number of peaks in experimental spectrum for 
                                              # matching. Default: 15
--use_topN_peaks <integer>                    # Pre-process experimental spectrum to only use top N 
                                              # peaks. Default: 150
--deisotope <integer>                         # Perform deisotoping or not (0=no, 1=yes). Default: 0 
--min_fragments_modelling <integer>           # Minimum number of matched peaks in PSM for inclusion in 
                                              # statistical modeling. Default: 2
--min_matched_fragments <integer>             # Minimum number of matched peaks for PSM to be reported. 
                                              # Default: 4
--minimum_ratio <float>                       # Filters out all peaks in experimental spectrum less 
                                              # intense than this multiple of the base peak intensity. 
                                              # Default: 0.01
--clear_mz_range <string>                     # Removes peaks in this m/z range prior to matching. 
                                              # Useful for iTRAQ/TMT experiments (i.e. 0.0 150.0). 
                                              # Default: 0.0_0.0
--remove_precursor_peak 0/1/2                 # Remove precursor peaks from tandem mass spectra.
                                              # 0 = not remove; 1 = remove the peak with precursor charge;
                                              # 2 = remove the peaks with all charge states. Default: 0
--remove_precursor_range <string>             # m/z range in removing precursor peaks. Unit: Da.
                                              # Default: -1.5,1.5
--intensity_transform 0/1                     # Transform peaks intensities with sqrt root.
                                              # 0 = not transform; 1 = transform using sqrt root.
                                              # Default: 0
--add_Cterm_peptide <float>                   # Statically add mass to C-terminal of peptide. Default: 0.0
--add_Nterm_peptide <float>                   # Statically add mass to N-terminal of peptide. Default: 0.0
--add_Cterm_protein <float>                   # Statically add mass to C-terminal of protein. Default: 0.0
--add_Nterm_protein <float>                   # Statically add mass to N-terminal of protein. Default: 0.0
--add_G_glycine <float>                       # Statically add mass to glycine. Default: 0.0
--add_A_alanine <float>                       # Statically add mass to alanine. Default: 0.0
--add_S_serine <float>                        # Statically add mass to serine. Default: 0.0
--add_P_proline <float>                       # Statically add mass to proline. Default: 0.0
--add_V_valine <float>                        # Statically add mass to valine. Default: 0.0
--add_T_threonine <float>                     # Statically add mass to threonine. Default: 0.0
--add_C_cysteine <float>                      # Statically add mass to cysteine. Default: 57.021464
--add_L_leucine <float>                       # Statically add mass to leucine. Default: 0.0
--add_I_isoleucine <float>                    # Statically add mass to isoleucine. Default: 0.0
--add_N_asparagine <float>                    # Statically add mass to asparagine. Default: 0.0
--add_D_aspartic_acid <float>                 # Statically add mass to aspartic acid. Default: 0.0
--add_Q_glutamine <float>                     # Statically add mass to glutamine. Default: 0.0
--add_K_lysine <float>                        # Statically add mass to lysine. Default: 0.0
--add_E_glutamic_acid <float>                 # Statically add mass to glutamic acid. Default: 0.0
--add_M_methionine <float>                    # Statically add mass to methionine. Default: 0.0
--add_H_histidine <float>                     # Statically add mass to histidine. Default: 0.0
--add_F_phenylalanine <float>                 # Statically add mass to phenylalanine. Default: 0.0
--add_R_arginine <float>                      # Statically add mass to arginine. Default: 0.0
--add_Y_tyrosine <float>                      # Statically add mass to tyrosine. Default: 0.0
--add_W_tryptophan <float>                    # Statically add mass to tryptophan. Default: 0.0
--add_B_user_amino_acid <float>               # Statically add mass to B. Default: 0.0
--add_J_user_amino_acid <float>               # Statically add mass to J. Default: 0.0
--add_O_user_amino_acid <float>               # Statically add mass to O. Default: 0.0
--add_U_user_amino_acid <float>               # Statically add mass to U. Default: 0.0
--add_X_user_amino_acid <float>               # Statically add mass to X. Default: 0.0
--add_Z_user_amino_acid <float>               # Statically add mass to Z. Default: 0.0

```