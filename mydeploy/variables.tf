variable "site_prefix" {
  description = "Prefix for the Netlify site name (a random suffix will be added)"
  type        = string
  default     = "hug-ibadan-demo"
}


variable "netlify_token" {
  description = "Netlify Personal Access Token (prefer env var NETLIFY_TOKEN)"
  type        = string
  sensitive   = true
  default =   "nfp_vnwUHvFouaKwcXZLLWF8i2vhE6mRfYmd26ab"
}
