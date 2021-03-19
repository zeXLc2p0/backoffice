# REDCap data dictionary manipulations

Use the scripts in this directory for programmatically manipulating a project's REDCap data dictionary to include specified HTML attributes.

This workflow is used for injecting `<span lang="{ISO-code}"></span>` HTML attributes into our data dictionaries in translations of a REDCap project.
Declaring the language of translated text is an important accessibility feature for people who access our services using a screen reader.
The variable `{ISO-code}` refers to a language's ISO 639-1 code.
Commonly used in SCAN are the languages:
* es - Spanish
* ru - Russian
* vi - Vietnamese
* zh-Hant - traditional Chinese

For SCAN, the list of REDCap field names that will receive the injected HTML tags is described in the file `scan_field_names_for_html_tags.csv` in this directory.
For the Snohomish Schools projects, the REDCap field names are listed in `snohomish_schools_field_names_for_html_tags.csv` in this directory.

In order to create a new `field names` CSV file for a different project, from REDCap download the project's data dictionary. This process will be easiest if you download the dictionary of a project that has already been translated into a text like Russian so it's easier to see which fields contain translated text. Open the data dictionary in a spreadsheet program. Look at the `section_header`, `field_label`, `field_note`, and `Choices, Calculations, OR Slider Labels` columns to identify which fields contain translated participant facing text. These are the fields that you should include in the CSV.

Note that because of the destructive operation of overwriting a REDCap project's metadata, this action can only be performed when the project is in DEVELOPMENT Mode.


## Usage

1. Export data dictionary

This is useful for inspecting the current data dictionary and saving it as a backup in case anything goes awry in uploading the new, altered data dictionary.
Because of possible mistakes that could occur, we recommend **saving the exported data dictionary**.

    ./bin/redcap-data-dictionary/download-data-dictionary --project-id {PID}

Output is a JSON object, by default, printed to stdout, which you can redirect to a new file.
You can also use the `--output` option to specify a destination file.


2. Upload data dictionary

    ./bin/redcap-data-dictionary/upload-data-dictionary --project-id {PID} \
        --html-attributes lang:{ISO-code}
        --exported-data-dictionary {JSON file from step 1}
        --field-names {The project specific field names CSV}

Note that you must use the `--import-to-redcap` option to actually upload the data dictionary to REDCap.
Exclusion of this option is equivalent to a dry-run that goes through the motions but does not make any changes to the target REDCap project.
