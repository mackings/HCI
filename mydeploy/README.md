# Terraform Challenge – Netlify Site + HCP Terraform Remote State

A tiny but complete example that:
- Deploys a static website to **Netlify** using **Terraform** + **Netlify CLI**
- Stores Terraform state remotely in **HCP Terraform** (Terraform Cloud)
- Generates a unique Netlify site name on each run
- Keeps secrets out of the repo and inside HCP Workspace Vars

> Live demo will be the output of `site_url` after `terraform apply`.

---

## Prerequisites
- **Terraform** v1.7+
- **Netlify** account and **Personal Access Token**
- **HCP Terraform** (Terraform Cloud) account, an **Organization**, and a **Workspace**
- **Netlify CLI** installed locally or in your runner: `npm i -g netlify-cli`

## HCP Terraform (Remote State)
This project uses a `cloud` block (not interpolated) that targets:
- Organization: **`hug-ibadan-demo`**
- Workspace: **`netlify-static`**

You can either create these names in HCP Terraform, **or edit** `versions.tf` and set them to your own.
> Note: The `cloud` block cannot use variables; it's a Terraform limitation.

Add the following **Workspace variables** (Sensitive 🔒):
- `NETLIFY_TOKEN` = your Netlify Personal Access Token
- (Optional) `NETLIFY_AUTH_TOKEN` if you prefer that name for the CLI

## Provider Auth
The Netlify provider will pick the token from the environment (recommended). You can also uncomment the `var.netlify_token` in `providers.tf` and pass it as a variable, but prefer environment variables to avoid it ending up in state.

## Variables
- `site_prefix` (default: `hug-ibadan-demo`) — a random suffix is appended to ensure unique subdomains on each run.

## How it Works
1. `random_pet` creates a unique suffix.
2. A `null_resource` calls **Netlify CLI** to:
   - Create the site (`netlify sites:create --name <prefix-suffix> --manual`)
   - Deploy the `./site` folder (`netlify deploy --prod --dir site ...`)
3. We **read back** the new site using `data "netlify_site"` and output the live URL.
4. Bonus: we set a site-level environment variable via the Netlify provider.

Why CLI? The current Netlify provider focuses on managing existing sites (build settings, env vars). Site creation is not consistently supported as a first-class resource, so using the **official Netlify CLI** keeps this workflow reliable and fully Terraform-driven.

## Run
```bash
# 1) Clone
git clone <your-fork-url>.git
cd terraform-netlify-hcp-challenge

# 2) (Once) Set tokens locally if running via CLI directly
export NETLIFY_TOKEN=xxxxxxxxxxxxxxxxxxxx
export NETLIFY_AUTH_TOKEN=$NETLIFY_TOKEN

# 3) Initialize with HCP Terraform
terraform init

# 4) Plan/apply (unique site name will be generated)
terraform apply -auto-approve

# 5) Grab the outputs
terraform output
```

## Outputs
- `site_name` — Netlify site name (with random suffix)
- `site_url` — Live URL (preferred SSL URL)
- `admin_url` — Link to Netlify dashboard for the site

## Re-runnable
The random suffix avoids name collisions; applying again will create a fresh site. State is in HCP, so you can reproduce the workflow on any machine with valid credentials.

## Secrets
No secrets are committed. Use HCP workspace variables for:
- `NETLIFY_TOKEN` (Sensitive)
- (Optional) `NETLIFY_AUTH_TOKEN` (Sensitive)

## Optional: Environment Variables via Terraform
This example includes `netlify_environment_variable` which sets `WELCOME_MESSAGE`. You can add more by duplicating that resource.

## Minimal Site
The site is a simple HTML page under `/site`. Update it freely or replace with your own app. A `netlify.toml` is included to set the publish directory.

## Screenshot
Add a screenshot of your successful `terraform apply` to `screenshots/` and link it here.

![apply screenshot](./screenshots/apply.png)

## Troubleshooting
- **403/Team access**: Ensure your token has access to the correct Netlify team.
- **CLI not found**: Install Netlify CLI (`npm i -g netlify-cli`) or run from an environment that has it.
- **Cloud block**: If init fails, double-check the org/workspace in `versions.tf` exist in HCP.

## Resources
- Netlify Terraform provider usage and token via `NETLIFY_TOKEN`. 
- Netlify environment variables docs.
- Terraform `cloud` block docs.

---

**License:** MIT
