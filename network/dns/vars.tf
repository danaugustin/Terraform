variable "region" {
  description = "The AWS region to create the DNS record in"
  type        = string
  default     = "us-east-1"
}

variable "zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

variable "name" {
  description = "The name (URL) of the DNS record"
  type        = string
}

variable "type" {
  description = "The type of record (CNAME, A, etc)"
  type        = string
}

variable "ttl" {
  description = "The TTL of the DNS record"
  type        = number
  default     = 300
}

variable "record" {
  description = "The target (destination) of the record"
  type        = string
}