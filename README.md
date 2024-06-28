# Job Analyzer
Job Analyzer is a package of VDS definitions which can be created over the sys.projects.history.jobs system table to analyze the jobs that have been processed in Dremio Cloud.

## Usage

### Manual
The VDS definitions can be manually executed Dremio Cloud. Each SQL file in the vdsdefinition folder is numbered and contains a SQL that can be executed in the New Query window in Dremio Cloud, by executing the SQLs in numeric order all dependencies will be taken care of.

NOTE: In order to load the VDS definitions manually it requires the manual creation of a space called JobAnalysis and the manual creation of three folders inside the space called Preparation, Business and Application.

### Automated
The VDS definitions (and all required spaces and folders) can be automatically created by executing the vds-creator.py script in the src folder.

```
cd src
python vds-creator.py [-h] --url URL --org-id ORG_ID --project-id PROJECT_ID --user USER --password PASSWORD  --vds-def-dir VDS_DEF_DIR [--tls-verify]
```

e.g. 
```
python vds-creator.py --url "https://api.dremio.cloud/" --org-id "12345678-123345678" --project-id "abcdef-abcdef-abcdef" --user myuser@mycompany.com --vds-def-dir ../vdsdefinition
```

NOTE: When connecting using a PAT token, the --user parameter **must** be omitted and the value of the PAT token **must** be placed in the --password parameter.

Not specifying the password on the command line will bring up a prompt where you can enter it but keep it hidden.

