# learn-terraform

This repository is used personally to learn and test how to use Terraform.

Current example:
- Uses the `hashicorp/google` provider
- Creates a simple GCP VPC network named `terraform-network`
- Reads the GCP project ID from a Terraform variable

Quick start:
1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Set `project_id` to your GCP project ID
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`

Pre-commit:
1. Run `pre-commit install`
2. Run `terraform init` before using the hooks
3. Hooks will run before each commit
4. To check everything manually, run `pre-commit run --all-files`

Current hook:
- `terraform fmt -check -recursive`
- `terraform validate`

Notes:
- `terraform.tfvars` is ignored and should stay local
- `.terraform.lock.hcl` is kept so provider versions stay reproducible
