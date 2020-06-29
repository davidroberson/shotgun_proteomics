class: Workflow
cwlVersion: v1.0
id: filter_quant_and_report_wf
label: filter_quant_and_report_wf.cwl
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: workspace_in
    type: 'File[]'
    'sbg:x': -463
    'sbg:y': -125
outputs:
  - id: report_outputs
    outputSource:
      - >-
        https:_cgc_api_sbgenomics_com_v2_apps_david_roberson_philosopher_dev_philosopher_report_14_raw_/report_outputs
    type: Directory?
    'sbg:x': 188.26812744140625
    'sbg:y': -33.09174728393555
  - id: script
    outputSource:
      - >-
        https:_cgc_api_sbgenomics_com_v2_apps_david_roberson_philosopher_dev_philosopher_report_14_raw_/script
    type: File?
    'sbg:x': 173
    'sbg:y': -200
steps:
  - id: >-
      https:_cgc_api_sbgenomics_com_v2_apps_david_roberson_philosopher_dev_philosopher_filter_15_raw_
    in:
      - id: workspace_in
        source: workspace_in
    out:
      - id: log_file
      - id: workspace_out
      - id: script
    run: ../tools/filter/filter.cwl
    label: Philosopher Filter
    scatter:
      - workspace_in
    'sbg:x': -224
    'sbg:y': -107
  - id: >-
      https:_cgc_api_sbgenomics_com_v2_apps_david_roberson_philosopher_dev_philosopher_report_14_raw_
    in:
      - id: workspace_in
        source: >-
          https:_cgc_api_sbgenomics_com_v2_apps_david_roberson_philosopher_dev_philosopher_filter_15_raw_/workspace_out
    out:
      - id: report_outputs
      - id: script
    run: ../tools/report/report.cwl
    label: Philosopher Report
    scatter:
      - workspace_in
    'sbg:x': 22
    'sbg:y': -99
requirements:
  - class: ScatterFeatureRequirement
