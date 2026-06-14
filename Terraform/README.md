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

data: reads existing external data, retrieve exsting data resources

variable: parameterizes configuration
+ map(string) { key = value }
+ list [item1, item2,...]
+ string
+ number

output: exposes values after apply

locals: computed intermediate values

terraform: settings, backend & required_providers

module: consume repeatable packages

import: bring an existing resources to terminal screen

### Essential commands
terraform init: intialize working directory

terraform fmt: format files to cannonical types

terraform validate: check config syntax & logic

terraform plan: preview execution plan

terraform apply: apply changes to infrastrcuture

terraform destroy: destroy managed resources

terraform destroy -target=[resource_name]

Notice: if you only need to move a specific resource by above cmd withou eliminate it in the terraform file, in the next apply state, this resources will be comeback again

terraform output: read output values

terraform console: interactive expression evaluation

terraform graph: generate dependency graph

terraform providers: show required providers

terraform show: read info in *.tfstate file (entire)

terraform state show [resource id]: read info about the specific resource


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

ex: terraform plan: update the current state from provider's resources (aws, azure,...) to .tfstate file, then check the new change in tf file with the .tfstate file. Whereas `terraform plan -refresh-only` only check and update the current state of provider's resource to .tfstate file.

-out=plan.out: save plan to file (ex: tfplan)

tfplan can be used to push to vcs (git...), review and apply after confidence. Ex: # terraform apply plan.out

-generate-config-out=[tf file] : use together with teraform plan and import block to allow terraform automatically generate & write down an existing resources from cloud providers to local ts file.

ex: terraform plan -generate-config-out=generated_resources.tf

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

Notice: how to distingue among terraform public, private, and local by `source`: 

local: start with `./`

public: format `[org]/[name]/[provider]`

private: `[company.domain]/[company-org]/....`

Run trigger: when the previous wordspace runsuccessfully, it automatically start and run the next wordspace

## Others
.terraform/ folder: list
  + provider folder: downloaded providers libraries
  + terraform.tfstate file: backend metadata
  + modules/ folder: backup of modules

"alias" keyword: use together with `provider` that allow to separate a same provider (ex: aws) which has difference region (for instance)

drift: conflict/error between current infrastructures and terraform code

terraform data source: retrieve and read info from cloud providers to use in .tf file

Terraform default manage 10 operations in parallel but can be modified using -parallism flag. ex:
terraform apply -parallism=5

Besides Terraform (acquired by IBM), OpenTofu is a opensource of Terraform (folk). We can download and use it with cmd tofu

## License

**Author: Hao Nguyen**
