variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `keanu`)"
}

variable "stage" {
  type        = string
  description = "Environment (e.g. `hard`, `soft`, `unified`, `dev`)"
}

variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `database`)"
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g., `one', or `two')"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`Visibility`,`Public`)"
}
