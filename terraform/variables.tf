###############################################################
# Default variables                                           #
###############################################################

# GCP PROJECT
variable "project_id" {
  type        = string
  description = "The project ID to host resources."
}

variable "region" {
  type        = string
  description = "The region to host the resources in."
}

variable "env" {
  type        = string
  description = "Pipeline environment."
  default     = ""
}

# variable "zone" {
#   type        = string
#   description = "The zone for monosite ressource."
# }

# SERVICE ACCOUNT
# variable "service_account" {
#  type        = string
#  description = "The name of the provisioning service account."
#}

###############################################################
# Custom variables                                            #
###############################################################

# Add here some custom / additional variables