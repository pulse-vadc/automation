# Shell Scripts

## Installation (install.sh)

| Variable | Description | Possible Answers | Notes |
| -------- | ----------- | ---------------- | ----- |
| **accept-license** | Whether or not to accept the End-User license agreement.  This value needs to **accept** in order to complete the installation. | **accept** | (Installation will fail for anything else) |
| **zeushome** | The directory that Stingray should be installed to. | Any directory. |  The default value is **/usr/local/zeus**. |
| **zxtm!perform_initial_config** | Whether or not the initial configuration should be performed immediately after the **zinstall** script completes. |
| **zxtm!perform_initial_config** | Whether or not the initial configuration should be performed immediately after the **zinstall** script completes. | **y**,**n** | For cloud deployments, the answer for this would typically be **n** (or no), as you would invoke the configure script later on. |


## Example: configure.sh

| Variable | Description | Possible Answers | Notes |
| -------- | ----------- | ---------------- | ----- |


## Example: post-install.sh

| Variable | Description | Possible Answers | Notes |
| -------- | ----------- | ---------------- | ----- |
