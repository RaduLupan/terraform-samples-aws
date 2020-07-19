# Remote backend partial configuration. Those arguments are repeated in all modules. 
# The key argument remains in Terraform code as it needs to be unique for each module
bucket         = "terraform-state-dev-us-east-2-fkaymsvstthc"
region         = "us-east-2"
dynamodb_table = "terraform-locks-dev-us-east-2"
encrypt        = true