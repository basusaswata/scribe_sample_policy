# Sample Policies

You can use Scribe to apply policies at different points along your SDLC.
For example, at the end of a build or at the admission control point to the production cluster. Use cases for example:

- Images must be signed, and they must have a matching CycloneDX SBOM.
- Images must be built by a CircleCI workflow and produce a signed SLSA provenance.
- Tagged sources must be signed and verified by a set of individuals or processes.
- Released binaries must be built by Azure DevOps from a specific git repository and have unsigned SLSA provenance.

For the detailed policy description, see **[policies](../valint/policies)** section.

## Sample Rule Bundle

The following is a description of a sample rule bundle (*please note that the feature is in early availability*) that can be used to build a policy for your SDLC.

## Quickstart

1. Install `valint`:

   ```bash
   curl -sSfL https://get.scribesecurity.com/install.sh  | sh -s -- -t valint
   ```

2. Create an SBOM of a type you want to verify

   ```bash
   valint bom busybox:latest -o statement
   ```
   
   Additional options:
   * To explore other evidence types, use commands like `valint slsa` or `valint evidence`.
   * Specify `-o attest` for signed evidence.

3. Verify the SBOM against a policy. The current catalogue will be used as a default bundle for `valint`.

   ```bash
   valint verify busybox:latest --rule sbom/complete-licenses@v1 # path within a repo
   ```

   If you want to use a specific (say, early-access version or outdated) of this catalogue, use `--git-tag` flag for `valint`:

   ```bash
   valint verify busybox:latest --git-tag v1.0.0 --rule sbom/complete-licenses@v1
   ```

### Targetless Run

   All of the policy rules in this catalogue can also be run in "targetless" mode, meaning that the evidence will be looked up based on the product name and version. To do so, first create an SBOM providing these values:

   ```bash
   valint bom busybox:latest -o statement --product-name busybox --product-version v1.36.1
   ```

   Then, run

   ```bash
   valint verify --rule sbom/complete-licenses@v1 --product-name busybox --product-version v1.36.1
   ```

   Valint will use the latest evidence for the specified product name and version that meets the other rule requirements.

## Modifying Rules in This Catalogue

Each rule in this catalogue consists of a `rego` script and `yaml` configuration file.
In order to run a rule, its script file should be referred by a rule config. Each `.yaml` represents such a config and is ready for use. If you modify or add your own rules, don't forget to fulfill this requirement.

If you fork this ruleset or create your own, in order to use it you need to specify its location in `valint` flag `--bundle` either in cmd args or a `valint.yaml` config file:

```bash
valint verify busybox:latest --bundle https://github.com/scribe-public/sample-policies --rule sbom/complete-licenses@v1
```

## Policy Rule Catalogue

| Rule | Description | Additional Info |
| --- | --- | --- |
| [Forbid Unsigned Artifacts](#forbid-unsigned-artifacts) | Verify the artifact's authenticity and signer identity. | [SBOM](#sbom) |
| [Blocklist Packages](#blocklist-packages) | Prevent risky packages in the artifact. | [SBOM](#sbom) |
| [Required Packages](#required-packages) | Ensure mandatory packages/files in the artifact. | [SBOM](#sbom) |
| [Banned Licenses](#banned-licenses) | Restrict inclusion of certain licenses in the artifact. | [SBOM](#sbom) |
| [Complete Licenses](#complete-licenses) | Guarantee all packages have valid licenses. | [SBOM](#sbom) |
| [Fresh Artifact](#fresh-artifact) | Verify an artifact's freshness. | [SBOM](#sbom) |
| [Fresh Image](#fresh-image) | Ensure an image freshness. | [Image SBOM](#images) |
| [Restrict Shell Image Entrypoint](#restrict-shell-image-entrypoint) | Prevent shell as image entrypoint. | [SBOM](#sbom) |
| [Blocklist Image Build Scripts](#blocklist-image-build-scripts) | Restrict build scripts in image build. | [Image SBOM](#images) |
| [Verify Image Lables/Annotations](#verify-image-lablesannotations) | Ensure image has required labels (e.g., git-commit). | [SBOM](#sbom)  |
| [Forbid Huge Images](#forbid-large-images) | Limit image size. | [Image SBOM](#images) |
| [Coding Permissions](#coding-permissions) | Control file modifications by authorized identities. | [Git SBOM](#git) |
| Merging Permissions | Ensure authorized identities merge to main. | Counterpart to [Forbid Commits To Main](#forbid-commits-to-main)? |
| [Forbid Unsigned Commits](#forbid-unsigned-commits) | Prevent unsigned commits in evidence. | [Git SBOM](#git) |
| [Forbid Commits To Main](#forbid-commits-to-main) | Verify there were no commits to the main branch. | [Git SBOM](#git) |
| [Verify Use of Specific Builder](#builder-name) | Enforce use of a specific builder for artifact. | [SLSA-Prov](#slsa) |
| [Banned Builder Dependencies](#banned-builder-dependencies) | Restrict banned builder dependencies. | [SLSA-Prov](#slsa) |
| [Verify Build Time](#build-time) | Validate build time within window. | [SLSA-Prov](#slsa) |
| [Verify Byproducts Produced](#produced-byproducts) | Ensure that specific byproducts are produced. | [SLSA-Prov](#slsa) |
| [Verify That Field Exists](#verify-that-field-exists) | Ensure that specific field exists in the SLSA statement. | [SLSA-Prov](#slsa) |
| [No Critical CVEs](#no-critical-cves) | Prohibit ANY critical CVEs. | [SARIF](#sarif-reports) |
| [Limit High CVEs](#limit-high-cves) | Limit high CVEs. | [SARIF](#sarif-reports) |
| [Do Not Allow Specific CVEs](#do-not-allow-specific-cves) | Prevent specific CVEs in the artifact. | [SARIF](#sarif-reports) |
| [No Static Analysis Errors](#no-static-analysis-errors) | Prevent static analysis errors in the artifact. | [SARIF](#sarif-reports) |
| [Limit Static Analysis Warnings](#limit-static-analysis-warnings) | Restrict static analysis warnings count. | [SARIF](#sarif-reports) |
| [Do Not Allow Specific Static Analysis Rules](#do-not-allow-specific-static-analysis-rules) | Restrict specific static analysis warnings. | [SARIF](#sarif-reports) |
| [Do Not Allow Vulnerabilities Based On Specific Attack Vector](#do-not-allow-vulnerabilities-based-on-specific-attack-vector) | Restrict vulnerabilities based on specific attack vector. | [SARIF](#sarif-reports) |
| [Report IaC Configuration errors](#report-iac-configuration-errors) | Check if there are any IaC configuration errors. | [SARIF](#sarif-reports) |
| [Verify Semgrep SARIF report](#verify-semgrep-sarif-report) | Check for specific violations in a semgrep report. | [SARIF](#sarif-reports) |
| [Verify Scanner Tool Evidence](#verify-tool-evidence) | Check the existance of an evidence of SARIF report created by specified tool | [SARIF](#sarif-reports) |
| [Forbid Accessing Host](#forbid-accessing-host) | Do not allow images with detected vulnerabilities giving access to the host system. | Generic Evidence | [Generic](#generic) |
| No Package Downgrading | Restrict package downgrades. | src and dst [SBOM](#sbom) |
| No License Modification | Prevent license modifications. | src and dst [SBOM](#sbom) |
| Verify Source code Integrity | Verify that the artifact source code has not been modified | src and dst [Git SBOM](#git) |
| Verify Dependencies Integrity | Verify that specific files or folders have not been modified | src and dst [SBOM](#sbom) |
| [Verify Github Branch Protection](https://github.com/scribe-public/sample-policies/tree/main/v1/api/github-branch-protection.md) | Verify that the branch protection rules are compliant to required | None |
| [Verify GitLab Push Rules](https://github.com/scribe-public/sample-policies/tree/main/v1/api/gitlab-push-rules.md) | Verify that the push rules are compliant to required. GitLabs push rules overlap some of GitHub's branch protection rules | None |

### General Information

Most of the policy rules in this bundle consist of two files: a `.yaml` and a `.rego`.

The first is a rule configuration file that should be referenced by on runtime or merged to the actual `valint.yaml`.
The second is a rego script that contains the actual verifyer code. It can be used as is or merged to the `.yaml` using `script` option.

### SBOM

An example of creating an SBOM evidence:

```bash
valint bom ubuntu:latest -o statement
```

To verify the evidence against the rule, run:

```bash
valint verify ubuntu:latest -i statement-cyclonedx-json --rule sbom/rule_config@v1
```

#### Forbid Unsigned Artifacts

This rule ([artifact-signed.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/artifact-signed.yaml)) verifies that the SBOM is signed and the signer identity equals to a given value.

If you have not created an SBOM yet, create an sbom attestation, for example:

In [artifact-signed.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/artifact-signed.yaml) file,
edit policy parameters ```attest.cocosign.policies.rules.input identity``` to reflect the expected signers identity.

You can also edit `target_type` to refelct the artifact type.

> Optional target types are `git`,`directory`, `image`, `file`, `generic`.

```yaml
evidence:
   target_type: container
with:
   identity:
      emails:
         - example@company.com
```

#### Blocklist Packages

This rule ([blocklist-packages.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/blocklist-packages.yaml), [blocklist-packages.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/blocklist-packages.rego)) verifies an SBOM does not include packages in the list of risky packages.

`rego` code for This rule can be found in the [blocklist-packages.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/blocklist-packages.rego) file.

Edit the list of the risky licenses in the `input.rego.args` parameter in file [blocklist-packages.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/blocklist-packages.yaml):

```yaml
with:
   blocklist:
      - "pkg:deb/ubuntu/tar@1.34+dfsg-1ubuntu0.1.22.04.1?arch=arm64&distro=ubuntu-22.04"
      - "log4j"
   blocklisted_limit: 0
```

#### Required Packages

This rule ([required-packages.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/required-packages.yaml), [required-packages.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/required-packages.rego)) verifies that the SBOM includes packages from the list of required packages.

Edit the list of the required packages in the `input.rego.args` parameter in file [required-packages.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/required-packages.yaml):

```yaml
with:
   required_pkgs:
      - "pkg:deb/ubuntu/bash@5.1-6ubuntu1?arch=amd64\u0026distro=ubuntu-22.04"
   violations_limit: 1
```

The rule checks if there is a package listed in SBOM whose name contains the name of a required package as a substring. For example, if the package name is ```pkg:deb/ubuntu/bash@5.1-6ubuntu1?arch=amd64\u0026distro=ubuntu-22.04```, it will match any substring, like just ```bash``` or ```bash@5.1-6ubuntu1```.

#### Banned Licenses

This rule ([banned-licenses.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/banned-licenses.yaml), [banned-licenses.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/banned-licenses.rego)) verifies that the SBOM does not include licenses from the list of risky licenses.

Edit the list of the risky licenses in the `input.rego.args` parameter in file [banned-licenses.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/banned-licenses.yaml):

```yaml
rgs:
   blocklist:
      - GPL
      - MPL
   blocklisted_limit : 10
```

#### Complete Licenses

This rule ([complete-licenses.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/complete-licenses.yaml), [complete-licenses.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/complete-licenses.rego)) verifies that every package in the SBOM has a license.

It doesn't have any additional parameters.

#### Fresh Artifact

This rule ([fresh-sbom.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/fresh-sbom.yaml), [fresh-sbom.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/fresh-sbom.rego)) verifies that the SBOM is not older than a given number of days.

Edit the config `input.rego.args` parameter in file [fresh-sbom.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sbom/fresh-sbom.yaml):

```yaml
with:
   max_days : 30
```

### Images

An example of creating an evidence:

```bash
valint bom ubuntu:latest -o statement
```

To verify the evidence against the rule:

```bash
valint verify ubuntu:latest -i statement --rule images/rule_config@v1
```

#### Restrict Shell Image Entrypoint

This rule ([restrict-shell-entrypoint.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/restrict-shell-entrypoint.yaml), [restrict-shell-entrypoint.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/images/restrict-shell-entrypoint.rego)) verifies that the image entrypoint does not provide shell access by default. It does so by verifying that both `Entrypoint` and `Cmd` don't contain `sh` (there's an exclusion for `.sh` though).

This rule is not configurable.

#### Blocklist Image Build Scripts

This rule ([blocklist-build-scripts.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/blocklist-build-scripts.yaml), [blocklist-build-scripts.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/images/blocklist-build-scripts.rego)) verifies that the image did not run blocklisted scripts on build.

Edit the list of the blocklisted scripts in the `input.rego.args` parameter in file [blocklist-build-scripts.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/no-build-scripts.yaml):

```yaml
with:
   blocklist:
      - curl
```

#### Verify Image Lables/Annotations

This rule ([verify-labels.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/verify-labels.yaml), [verify-labels.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/images/verify-labels.rego)) verifies that image has labels with required values.

Edit the list of the required labels in the config object in file [verify-labels.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/verify-labels.yaml):

```yaml
with:
   labels:
      - label: "org.opencontainers.image.version"
        value: "22.04"
```

#### Fresh Image

This rule ([fresh-image.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/fresh-image.yaml), [fresh-image.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/images/fresh-image.rego)) verifies that the image is not older than a given number of days.

Edit the config `input.rego.args` parameter in file [fresh-image.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/fresh-image.yaml):

```yaml
with:
   max_days: 183
```

#### Forbid Large Images

This rule ([forbid-large-images.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/forbid-large-images.yaml), [forbid-large-images.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/images/forbid-large-images.rego)) verifies that the image is not larger than a given size.

Set max size in bytes in the `input.rego.args` parameter in file [forbid-large-images.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/images/forbid-large-images.yaml):

```yaml
with:
   max_size: 77808811
```

### Git

An example of creating a Git evidence:

```bash
valint bom git:https://github.com/golang/go -o statement
```

To verify the evidence against the rule:

```bash
valint verify git:https://github.com/golang/go -i statement --rule git/rule_config@v1
```

#### Coding Permissions

This rule ([coding-permissions.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/git/coding-permissions.yaml), [coding-permissions.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/git/coding-permissions.rego)) verifies that files from the specified list were modified by authorized users only.

For This rule be able to run, the evidence must include a reference to the files that were modified in the commit. This can be done by adding parameter `--components commits,files` to the `valint bom` command.

For specifying the list of files and identities, edit the `input.rego.args` parameter in file [coding-permissions.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/git/coding-permissions.yaml).
This example for repository [Golang Build](https://github.com/golang/build) verifies that files `build.go` and `internal/https/README.md` were modified only by identities containing `@golang.com` and `@golang.org`:

```yaml
with:
   ids:
      - "@golang.com"
      - "@golang.org"
   files:
      - "a.txt"
      - "somedir/b.txt"
```

#### Forbid Unsigned Commits

This rule ([no-unsigned-commits.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/git/no-unsigned-commits.yaml), [no-unsigned-commits.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/git/no-unsigned-commits.rego)) verifies that evidence has no unsigned commits. It does not verify the signatures though.

#### Forbid Commits To Main

This rule ([no-commit-to-main.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/git/no-commit-to-main.yaml), [no-commit-to-main.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/git/no-commit-to-main.rego)) verifies that evidence has no commits made to main branch.

### SLSA

Example of creating a SLSA statement:

```bash
valint slsa ubuntu:latest -o statement
```

Example of verifying a SLSA statement:

```bash
valint verify ubuntu:latest -i statement-slsa --rule slsa/rule_config@v1
```

#### Builder Name

This rule ([verify-builder.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/verify-builder.yaml), [verify-builder.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/verify-builder.rego)) verifies that the builder name of the SLSA statement equals to a given value.

Edit config `input.rego.args` parameter in file [verify-builder.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/verify-builder.yaml):

```yaml
with:
   id: "local"
```

#### Banned Builder Dependencies

This rule ([banned-builder-deps.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/banned-builder-deps.yaml), [banned-builder-deps.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/banned-builder-deps.rego)) verifies that the builder used to build an artifact does not have banned dependencies (such as an old openSSL version).

Edit config `input.rego.args` parameter in file [banned-builder-deps.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/banned-builder-deps.yaml):

```yaml
with:
   blocklist:
      - name: "valint"
         version: "0.0.0"
```

#### Build Time

This rule ([build-time.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/build-time.yaml), [build-time.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/build-time.rego)) verifies that the build time of the SLSA statement is within a given time window The timezone is derived from the timestamp in the statement.

Edit config `input.rego.args` parameter in file [build-time.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/build-time.yaml):

```yaml
with:
   start_hour: 8
   end_hour: 20
   workdays:
      - "Sunday"
      - "Monday"
      - "Tuesday"
      - "Wednesday"
      - "Thursday"
```

#### Produced Byproducts

This rule ([verify-byproducts.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/verify-byproducts.yaml), [verify-byproducts.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/verify-byproducts.rego)) verifies that the SLSA statement contains all the required byproducts.
According to the SLSA Provenance [documentation](https://slsa.dev/spec/v1.0/provenance), there are no mandatory fields in the description of a byproduct, but at least one of `uri, digest, content` should be specified.
So, the rule checks if each byproduct specified in the configuration is present in one of those fields of any byproduct in the SLSA statement. It does so by calling the `contains` function, so the match is not exact.

Before running the rule, specify desired byproducts in the `input.rego.args` parameter in file [verify-byproducts.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/verify-byproducts.yaml):

```yaml
with:
   byproducts:
      - 4693057ce2364720d39e57e85a5b8e0bd9ac3573716237736d6470ec5b7b7230
```

#### Verify That Field Exists

This rule ([field-exists.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/field-exists.yaml), [field-exists.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/field-exists.rego)) verifies that the SLSA statement contains a field with the given path.

Before running the rule, specify desired paths in the `input.rego.args` parameter in file [field-exists.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/slsa/field-exists.yaml):

```yaml
with:
   paths:
      - "predicate/runDetails/builder/builderDependencies"
   violations_threshold: 0
```

### Sarif Reports

#### Generic SARIF Rule

This rule ([verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml), [verify-sarif.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.rego)) allows to verify any SARIF report against a given rule. The rule has several parameters to check against:

* ruleLevel: the level of the rule, can be "error", "warning", "note", "none"
* ruleIds: the list of the rule IDs to check against
* precision: the precision of the check, can be "exact", "substring", "regex"
* ignore: the list of the rule IDs to ignore
* maxAllowed: the maximum number of violations allowed

These values can be changed in the `input.rego.args` section in the [verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file.

##### Creating a BOM out of a SARIF report

Create a trivy sarif report of the vulnerabilities of an image:

```bash
trivy image ubuntu:latest -f sarif -o ubuntu-cve.json
```

Create an evidence from this report:

```bash
valint evidence ubuntu-cve.json  -o statement
```

Verify the attestation against the rule:

```bash
valint verify ubuntu-cve.json -i statement-generic --rule sarif/verify-sarif@v1
```

###### Running Trivy On Docker Container Rootfs

As an alternative, one can run `trivy` against an existing Docker container rootfs:

```bash
docker run --rm -it alpine:3.11
```

Then, inside docker run:

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
trivy rootfs / -f sarif -o rootfs.json
```

Then, outside docker run this to copy the report from the container:

```bash
docker cp $(docker ps -lq):/rootfs.json .
```

After that create the evidence and verify it as described above.

##### No Critical CVEs

To verify that the SARIF report does not contain any critical CVEs, set the following parameters in the `rego.args` section in the[verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file:

```yaml
with:
   rule_level:
      - critical
   precision: []
   rule_ids: []
   ignore: []
   max_allowed: 0
```

##### Limit High CVEs

To verify that the SARIF report does not contain more than specified number of CVEs with high level (let's say 10), set the following parameters in the `rego.args` section in the[verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file:

```yaml
with:
   rule_level: high,
   precision: []
   rule_ids: []
   ignore: []
   max_allowed: 10
```

##### Do Not Allow Specific CVEs

To verify that the SARIF report does not contain certain CVEs (let's say CVE-2021-1234 and CVE-2021-5678), set the following parameters in the `rego.args` section in the[verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file:

```yaml
with:
   rule_level:
      - "error"
      - "warning"
      - "note"
      - "none"
   precision: []
   rule_ids:
      - "CVE-2021-1234"
      - "CVE-2021-5678"
   ignore: []
   max_allowed: 0
```

##### No Static Analysis Errors

To verify that the SARIF report does not contain any static analysis errors, set the following parameters in the `rego.args` section in the[verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file:

```yaml
with:
   rule_level:
      - "error"
   precision: []
   rule_ids: []
   ignore: []
   max_allowed: 0
```

##### Limit Static Analysis Warnings

To verify that the SARIF report does not contain more than specified number of static analysis warnings (let's say 10), set the following parameters in the `rego.args` section in the[verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file:

```yaml
with:
   rule_level:
      - "warning"
   precision: []
   rule_ids: []
   ignore: []
   max_allowed: 10
```

##### Do Not Allow Specific Static Analysis Rules

To verify that the SARIF report does not contain static analysis warnings from the following rules: "rule1", "rule2", "rule3", set the following parameters in the `rego.args` section in the[verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) file:

```yaml
with:
   rule_level:
      - "error"
      - "warning"
      - "note"
      - "none"
   precision: []
   rule_ids:
      - "rule1"
      - "rule2"
      - "rule3"
   ignore: []
   max_allowed: 0
```

##### Do Not Allow Vulnerabilities Based On Specific Attack Vector

Trivy/grype reports usually contain descriptions for some CVEs, like impact and attack vector.
This rule ([verify-attack-vector.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-attack-vector.yaml), [verify-attack-vector.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-attack-vector.rego)) is meant to restrict number of vulnerabilities with specific attack vectors.
For example, to restrict vulnerabilities with attack vector "stack buffer overflow", set the following parameters in the `rego.args` section in the [verify-attack-vector.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-attack-vector.yaml) file:

```yaml
with:
   attack_vectors:
      - "stack buffer overflow"
   violations_threshold: 0
```

Then run the rule against the SARIF report as described above.

#### Report IaC Configuration errors

This rule ([report-iac-errors.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/report-iac-errors.yaml), [report-iac-errors.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/report-iac-errors.rego)) allows to verify a Trivy IaC report and check if there are any errors in the configuration.

First, create a trivy report of the misconfigurations of a Dockerfile:

```bash
trivy config <dir_containing_dockerfile> -f sarif -o my-image-dockerfile.json
```

Create an evidence from this report:

```bash
valint evidence my-image-dockerfile.json -o statement
```

Verify the attestation against the rule:

```bash
valint verify my-image-dockerfile.json -i statement-generic --rule sarif/report-iac-errors@v1
```

The only configurable parameter in [report-iac-errors.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/report-iac-errors.yaml) is `violations_threshold`, which is the maximum number of errors allowed in the report:

```yaml
with:
   violations_threshold: 0
```

#### Verify Semgrep SARIF report

`semgrep`, a code analysis tool, can produce SARIF reports, which later can be verified by `valint` against a given rule.

This rule ([verify-semgrep-report.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-semgrep-report.yaml), [verify-semgrep-report.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-semgrep-report.rego)) allows to verify that given SARIF report does not contain specific rules violations.

First, one needs to create a semgrep report (say, for the `openvpn` repo):

```bash
cd openvpn/
semgrep scan --config auto -o semgrep-report.sarif --sarif
```

Then, create an evidence from this report:

```bash
valint evidence semgrep-report.sarif -o statement
```

Configuration of This rule is done in the file [verify-semgrep-report.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-semgrep-report.yaml). In this example we forbid any violations of the `use-after-free` rule:

```yaml
with:
   rule_ids:
      - "use-after-free"
   violations_threshold: 0
```

Then, run `valint verify` as usual:

```bash
valint verify semgrep-report.sarif -i statement-generic --rule sarif/verify-semgrep-report@v1
```

If any violations found, the output will contain their description, including the violated rule and the file where the violation was found.

#### Verify Tool Evidence

This rule ([verify-tool-evidence.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-tool-evidence.yaml)) allows to verify the existence of an evidence of SARIF report created by a specified tool. By default, the rule checks for an evidence created out of _any_ SARIF report. To specify a tool, use the `tool` parameter in the `evidence` section of the rule configuration. For example, to verify that there is an evidence of a SARIF report created by `trivy`, use the following configuration:

```yaml
uses: sarif/verify-tool-evidence@v1
evidence:
   tool: "Trivy Vulnerability Scanner"
```

### Forbid Accessing Host

Trivy k8s analysis can highlight some misconfigurations which allow container to access host filesystem or network. The goal of This rule is to detect such misconfigurations.

To run this rule one has to create a Trivy k8s report and create a generic statement with `valint` from it. Then, simply verify the statement against this rule. No additional configuration required.

## Writing Rule Files

Rego policy rules can be written either as snippets in the yaml file, or as separate rego files.

An example of such a rego script is given in the [verify-sarif.rego](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.rego) file, that is consumed by the [verify-sarif.yaml](https://github.com/scribe-public/sample-policies/tree/main/v1/sarif/verify-sarif.yaml) configuraion. To evaluate the rule, run

```bash
valint verify ubuntu-cve.json -i statement-generic --rule sarif/verify-sarif@v1
```
