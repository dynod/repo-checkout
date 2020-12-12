# repo-checkout
Github action to setup a workspace using repo

## Usage

To use this action, just declare a step like this in your workflow file:
```yaml
- name: My step
  uses: dynod/repo-checkout@1.3.0
  with:
      url: https://github.com/user/repo
      manifest: some-manifest.xml
      group: some-group
```

Input parameters are:

### url (mandatory)
URL to repository holding the repo manifest

### manifest
File name of the repo manifest to be used (default: *manifest.xml*)

### branch
Branch to use on the manifest repository (default: *master*)

### group
Project group name to be used with repo (default: empty)

### env
Comma separated list of environment variables to be set before calling make.
