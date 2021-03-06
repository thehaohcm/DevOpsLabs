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

## License

**Author: Hao Nguyen**
