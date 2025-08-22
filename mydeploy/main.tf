resource "random_pet" "suffix" {
  length = 2
}

locals {
  site_name = "hug-ibadan-demo"
}



resource "null_resource" "netlify_site_create" {
  triggers = {
    name = local.site_name
  }

  provisioner "local-exec" {
    environment = {
      NETLIFY_AUTH_TOKEN = var.netlify_token
    }

    command = <<EOT
echo Creating Netlify site: ${local.site_name}
netlify sites:create --name "${local.site_name}" || echo "Site may already exist, continuing..."
EOT

    interpreter = ["cmd", "/c"]
  }
}


resource "null_resource" "netlify_deploy" {
  depends_on = [null_resource.netlify_site_create]

  triggers = {
    name = local.site_name
  }

  provisioner "local-exec" {
    environment = {
      NETLIFY_AUTH_TOKEN = var.netlify_token
    }

    command = <<EOT
echo Deploying site: ${local.site_name}
netlify deploy --prod --dir "site" --site "${local.site_name}"
EOT

    interpreter = ["cmd", "/c"]
  }
}



data "netlify_site" "this" {
  depends_on = [null_resource.netlify_site_create]
  name       = local.site_name
  team_slug  = "kingsleyudoma2018"  
}


resource "netlify_environment_variable" "message" {
  site_id = "f682ae93-7d1d-40c9-a19c-7e2728d8349a"
  team_id = "kingsleyudoma2018"
  key     = "WELCOME_MESSAGE"

  values = [
    {
      context = "production"
      value   = "Hello from Terraform at ${local.site_name}!"
    }
  ]
}



# Outputs
output "site_name" {
  value       = local.site_name
  description = "The unique Netlify site name that was created."
}

output "site_url" {
  value       = "https://${local.site_name}.netlify.app"
  description = "The live URL of the deployed site."
}

output "admin_url" {
  value       = "https://app.netlify.com/sites/${local.site_name}"
  description = "Link to the Netlify admin UI for this site."
}
