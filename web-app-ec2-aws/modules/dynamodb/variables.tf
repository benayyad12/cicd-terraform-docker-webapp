variable "dynamodb_name" {
  type        = string
  description = "name of dynamodb table"
}
variable "pay_mode" {
  type        = string
  description = "billing mode"
}

variable "hkey" {
  type        = string
  description = "Attribute to use as the hash (partition) key."
}