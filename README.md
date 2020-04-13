# repo-checkout
Github action to setup a workspace using repo

## Usage

To use this action, just declare a step like this in your workflow file:
```yaml
- name: My step
  uses: dynod/repo-checkout@v1
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

### group
Project group name to be used with repo (default: empty)
