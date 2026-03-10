# learn-terraform

This repository is used personally to learn and test how to use Terraform.

Current example:
- Uses the `hashicorp/google` provider
- Targets `us-central1`
- Creates an Artifact Registry Docker repository named `learn-terraform`
- Deploys a public Cloud Run service named `go-api`
- Reads the GCP project ID from a Terraform variable
- Reads the Go API image URL from a Terraform variable
- Includes a small Go API with a `/health` endpoint

Quick start:
1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Set `project_id` to your GCP project ID
3. Set `go_api_image` to the Artifact Registry image you want Cloud Run to deploy
4. Copy `backend/dev.hcl.example` to `backend/dev.hcl`
5. Update `backend/dev.hcl` with your GCS bucket name and state prefix
6. Run `terraform init -backend-config=backend/dev.hcl`
7. Bootstrap Artifact Registry with `terraform apply -target=google_project_service.artifact_registry_api -target=google_artifact_registry_repository.docker_repo`
8. Build and push the Go API image to Artifact Registry
9. Run `terraform apply`
10. Run `terraform output -raw go_api_url`

Pre-commit:
1. Run `pre-commit install`
2. Run `terraform init` before using the hooks
3. Hooks will run before each commit
4. To check everything manually, run `pre-commit run --all-files`

Current hook:
- `terraform fmt -check -recursive`
- `terraform validate`
- `cd go-api && gofmt -l .`
- `cd go-api && go vet ./...`
- `cd go-api && go test ./...`

CI:
- GitHub Actions runs `terraform fmt -check -recursive`
- GitHub Actions runs `terraform init -backend=false`
- GitHub Actions runs `terraform validate`
- The workflow runs on both `push` and `pull_request`
- GitHub Actions also runs Go `fmt`, `vet`, and `test` for `go-api`

Notes:
- `terraform.tfvars` is ignored and should stay local
- `backend/dev.hcl` is ignored and should stay local
- `backend/dev.hcl.example` shows the expected backend config format
- `.terraform.lock.hcl` is kept so provider versions stay reproducible
- `go_api_url` is a public Cloud Run URL because the service grants `roles/run.invoker` to `allUsers`

Go API:
1. Change into `go-api`
2. Run `go test ./...`
3. Run `go run .`
4. Open `http://localhost:8080/health`

Go API Docker:
1. Run `docker build --platform linux/amd64 -t learn-terraform-go-api ./go-api`
2. Run `docker run --rm -p 8080:8080 learn-terraform-go-api`
3. Open `http://localhost:8080/health`

Artifact Registry push:
1. Run `gcloud auth configure-docker us-central1-docker.pkg.dev`
2. Tag the image with `docker tag learn-terraform-go-api us-central1-docker.pkg.dev/YOUR_PROJECT_ID/learn-terraform/go-api:v0.1.0`
3. Push the image with `docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/learn-terraform/go-api:v0.1.0`
