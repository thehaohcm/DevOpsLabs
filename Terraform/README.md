# Devops Labs - Terraform Lab
## Setup

1. Follow the below link to download and install Terraform:
- https://spacelift.io/blog/terraform-version-upgrade
2. Follow the below link to download and install AWS CLI:
- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
3. Create IAM User with Access Key ID and Secret Access Key
4. Add new Policy with only Creating EC2 Instance Roles, follow this link:
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-policies-ec2-console.html#ex-launch-wizard
5. Add IAM User to the above Policy
6. Configurate the AWS CLI with your IAM User by using below cmd:
- aws config
7. Create new file "main.tf" with a content like below link:
- https://www.middlewareinventory.com/blog/terraform-aws-example-ec2/
5. Add IAM User to the above Policy
6. Configurate the AWS CLI with your IAM User by using below cmd:
- aws config
7. Create new file "main.tf" with a content like below link:
- https://www.middlewareinventory.com/blog/terraform-aws-example-ec2/
8. run command for initializing terraform: terraform init
9. run command to see what changes: terraform plan
10. run command to apply all changes: terraform apply
11. run command to destroy all created resource: terraform destroy
Notice: add parameter "-auto-approve" if you don't want to wait and type "yes" for the next step
--Done--

## Reference
- https://www.youtube.com/watch?v=XxTcw7UTues

## Concepts 
### Wordflow
Core Terraform worldflow:
write -> init -> plan -> apply -> destroy

### HCL block types
resource: create & manages infra objects
data: reads existing external data
variable: parameterizes configuration
output: exposes values after apply
locals: computed intermediate values
terraform: settings, backend & required_providers
module: consume repeatable packages

### Essential commands
terraform init: intialize working directory
terraform fmt: format files to cannonical types
terraform validate: check config syntax & logic
terraform plan: preview execution plan
terraform apply: apply changes to infrastrcuture
terraform destroy: destroy managed resources
terraform output: read output values
terraform console: interactive expression evaluation
terraform graph: generate dependency graph
terraform providers: show required providers

### Variable definition precendence (from top to bottom)
-var flag

-var-file flag

*.auto.tfvars

terraform.tfvars

ENV (TF_VAR_[VARNAME]

*Notice:* CLI -var and -var-file always override file-based and environment definitions. Auto-loaded files are processed in alphabetical order

### Useful flags
-auto-approve: skip confirmation prompt

-target= : apply to specific resource

-var= : set variable inline

-var-file= : load variable files

-refresh-only: update- state, no changes

-out=plan.out: save plan to file

### Enviroment variables
TF_LOG: TRACE, DEBUG, etc.

TF_LOG_PATH: write logs to file

TP_VAR_[name]: set input variable

### HCP Terraform
```
terraform {
  cloud {
    organization="org"
    workspaces {
      name="my-app"
    }
  }
}
```
## License

**Author: Hao Nguyen**
