variable "service_account_key_file" {
  description = "key.json"
}

variable "cloud_id" {
  description = "Cloud"
  default     = "b1ghvq683bg4blgik8rg"
}

variable "folder_id" {
  description = "Folder"
  default     = "b1g8cpnbhc0qkrcblbb8"
}

variable "subnet_id" {
  description = "Subnet"
  default     = "e9b0ucrpq8aebu4b9rqc"
}

variable "zone" {
  description = "Zone"
  default     = "ru-central1-b"
}

variable "login_user" {
  description = "Default user login"
  default     = "centos"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "privat_key_path" {
  description = "Path to the public key used for ssh access"
}

