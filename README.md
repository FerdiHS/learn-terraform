# learn-terraform

This repository is used personally to learn and test how to use Terraform.

Current example:
- Uses the `hashicorp/google` provider
- Targets `us-central1` with zone `us-central1-c`
- Creates a simple GCP VPC network named `terraform-network`
- Creates a small GCP VM instance named `terraform-instance` using `e2-micro`
- Reads the GCP project ID from a Terraform variable
- Includes a small Go API with a `/health` endpoint

Quick start:
1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Set `project_id` to your GCP project ID
3. Copy `backend/dev.hcl.example` to `backend/dev.hcl`
4. Update `backend/dev.hcl` with your GCS bucket name and state prefix
5. Run `terraform init -backend-config=backend/dev.hcl`
6. Run `terraform plan`
7. Run `terraform apply`

Pre-commit:
1. Run `pre-commit install`
2. Run `terraform init` before using the hooks
3. Hooks will run before each commit
4. To check everything manually, run `pre-commit run --all-files`

Current hook:
- `terraform fmt -check -recursive`
- `terraform validate`
- `cd go-api && go test ./...`

CI:
- GitHub Actions runs `terraform fmt -check -recursive`
- GitHub Actions runs `terraform init -backend=false`
- GitHub Actions runs `terraform validate`
- The workflow runs on both `push` and `pull_request`

Notes:
- `terraform.tfvars` is ignored and should stay local
- `backend/dev.hcl` is ignored and should stay local
- `backend/dev.hcl.example` shows the expected backend config format
- `.terraform.lock.hcl` is kept so provider versions stay reproducible

Go API:
1. Change into `go-api`
2. Run `go test ./...`
3. Run `go run .`
4. Open `http://localhost:8080/health`
