data "terraform_remote_state" "dboutputs" {
  backend = "local"
  config = {
    path = "/Users/preetamzare/Documents/Terraform/terraformdays/11_Day/Data/terraform.tfstate"
   }
}

output "dbstring" {
  value = data.terraform_remote_state.dboutputs.outputs.dbstring
}

output "dbarn" {
  value = data.terraform_remote_state.dboutputs.outputs.dbarn
}