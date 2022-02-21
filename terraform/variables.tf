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
# AppEngine                                                   #
###############################################################
variable "remote_subnet_list" {
  type        = list(string)
  description = "List of private IP addresses that are authorized to access the Cloud Run through the VPN."
  default = [
    "192.168.215.0/28",   # "dev gcp proxy"
    "192.168.214.128/28", # "preprod gcp proxy"
    "192.168.213.128/28", # "prod gcp proxy"
    "10.107.0.0/21",      # "VDI"
    "10.98.128.0/17",     # "Gitlab SPH"
    "10.234.0.0/16"       # "Gitlab BGL"
  ]
}

###############################################################
# Cloud Run                                                   #
###############################################################
variable "services_configuration" {
  type        = map(any)
  description = "Service specific configuration"
}

###############################################################
# Custom variables                                            #
###############################################################

# Add here some custom / additional variables