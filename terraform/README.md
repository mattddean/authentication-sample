# Authentication Sample Terraform

## Terraform shell

Assuming you already have an AWS credentials file at ~/.aws/credentials:

```bash
export UID && docker-compose run terraform
```

## Deploying to AWS

1. Create a new version of the backend container

```bash
docker build -t mattddean/auth_sample-backend .
docker login
docker push mattddean/auth_sample-backend
```

2. Copy secret.tfvars.example as secret.tfvars and fill in all of the variables

3. Run terraform commands to build the app's infrastructure in AWS

From within the [Terraform Shell](#terraform-shell):

```bash
terraform init
terraform plan -var-file="secret.tfvars" -out plan.tfplan
terraform apply "plan.tfplan"
```

## Destroying from AWS

```bash
terraform destroy -var-file="secret.tfvars"
```