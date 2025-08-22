# From Zero to Live: Terraforming a Netlify Site with HCP Remote State

I built a tiny reproducible stack that uses **Terraform** to spin up a **Netlify** site and stores state in **HCP Terraform**. The twist: while the official Netlify provider excels at managing existing sites (settings, environment variables), creating a site is still easier via the **Netlify CLI** — so I wired that into Terraform using `null_resource` with `local-exec`.

## What makes it unique
- **Re-runnable**: each run generates a unique site name (`random_pet`) to avoid collisions.
- **Zero secrets in Git**: tokens live in HCP workspace vars.
- **One command to live**: `terraform apply` creates and deploys.

## Architecture
1. `random_pet` → unique suffix.
2. `null_resource` → calls Netlify CLI to create & deploy `./site`.
3. `data "netlify_site"` → reads back the site to get URLs.
4. Optional: `netlify_environment_variable` to manage env vars in code.

## Setup (short version)
- Create a Netlify personal access token.
- In HCP Terraform, create an org + workspace; add `NETLIFY_TOKEN` as a sensitive env var.
- Clone the repo, adjust the `cloud` block org/workspace, then:
  ```bash
  terraform init
  terraform apply -auto-approve
  ```

That’s it — you’ll get the live URL in outputs.

> Shout-out to **HUG Ibadan**! (Will also share this post on LinkedIn and tag the page.)

