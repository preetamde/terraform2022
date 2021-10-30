data "terraform_remote_state" "dbinstance" {
  backend = "local"
  config = {
    path = "/Users/preetamzare/Documents/Terraform/terraformdays/11_Day/Data/terraform.tfstate"
   }
}
output "dbstring" {
  value = data.terraform_remote_state.dbinstance.outputs.dbstring
}