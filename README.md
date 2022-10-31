# Tracee Test Infra PoC

The point of this repository is to serve as a proof of concept of the test infrastructure
that we will integrate into [tracee](github.com/aquasecurity/tracee).

### Goal

To have [self-hosted github actions runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners) running
in Aqua's AWS environment. Also, to make it easy for Tracee contributors to add new machines that tests will be run on.

### Design

- When a Tracee contributor adds a new packer file under `infra/packer`, or modifies an exist one, a webhook will hit a service in Aqua's cloud environment that will run the packer file
    - The packer file calls the script `infra/gh-action-runner-configure.sh`
    - This script installs the github actions runner and authenticates with the API using a personal access token associated with the `aqua-penguin-bot` user (this can be changed to a different account later).
    - The script also names the runner by hostname which is set in the packer file, this is also how Tracee contributors would identify the machine for running tests on it (see `.github/workflows/blank.yml`)
- Once the machine image has been created, it should be available for when they would be triggered via opening pull requests or scheduled tests in Tracee. They would serve requests for running workloads by running the `./actions-runner/run.sh` (which is pulled down via the configure script).

### Secrets

- `GH_ACTIONS_TOKEN` - this is the environment variable that's passed to the `./gh-action-runner-configure.sh` script. It's a personal access token associated with the `aqua-penguin-bot` user. It should be made available to the script when running the packer file. **NOTE** that the current logic for passing the environment variable may be incorrect and has to be tested.