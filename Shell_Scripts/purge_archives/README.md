# Purge Archives script
_This script is used for periodic removal/purging of archived files to clear up space.
The retention period for archival file might vary depending on type of the files stored in the directory.
That can be configured using config files_

## Design
This script is designed to purge archives from following locations
* Source File Archive
* Target File Archive
* Reject File Archive
* Audit Log Archive
* Purge Script Archive

Retention period for each of these folders can be set seprately in the config file _[Purge_Script.config](https://github.com/binilvj/test_code_repo2/blob/master/Shell_Scripts/purge_archives/config/Purge_Script.config)_

This folder structure is assumed to be same for Multiple projects
Each of such projects names are listed in _[Purge_Script_Interface_Names](https://github.com/binilvj/test_code_repo2/blob/master/Shell_Scripts/purge_archives/config/Purge_Script_Interface_Names)_ file
The script will try to delete the files from the archive directories from each of the Project folders

## Installation
1. Download the scripts and config directory to a Unix/Linux/Mac environment
2. Adjust the dates and paths as needed in file _[paths.config](https://github.com/binilvj/test_code_repo2/blob/master/Shell_Scripts/purge_archives/config/paths.config)_

