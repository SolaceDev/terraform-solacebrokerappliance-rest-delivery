# Copyright 2024 Solace Corporation. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Input variable definitions

# Required variables

variable "msg_vpn_name" {
  description = "The name of the Message VPN"
  type        = string
}

variable "url" {
  description = "The URL that the messages should be delivered to. The path portion of the URL may contain substitution expressions"
  type        = string
  validation {
    condition     = can(regex("https?://.*", lower(var.url)))
    error_message = "The URL must be a valid URL"
  }
}

variable "rest_delivery_point_name" {
  description = "The name of the REST Delivery Point"
  type        = string
}

variable "queue_name" {
  description = "The name of the queue to bind to. The REST Delivery Point must have permission to consume messages from the queue — to achieve this, the queue’s owner must be set to #rdp/<rdp-name> or the queue’s permissions for non-owner clients must be set to at least `consume` level access"
  type        = string
}

# Optional variables

variable "enabled" {
  description = "Enable or disable the REST Delivery Point and the underlying REST Consumer"
  type        = bool
  default     = true
}

variable "rest_consumer_name" {
  description = "The name of the REST Consumer"
  type        = string
  default     = null
}

variable "authentication_aws_access_key_id" {
  description = "The AWS access key id"
  type        = string
  default     = null
}

variable "authentication_aws_region" {
  description = "The AWS region id"
  type        = string
  default     = null
}

variable "authentication_aws_secret_access_key" {
  description = "The AWS secret access key"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_aws_service" {
  description = "The AWS service id"
  type        = string
  default     = null
}

variable "authentication_client_cert_content" {
  description = "The PEM formatted content for the client certificate that the REST Consumer will present to the REST host"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_client_cert_password" {
  description = "The password for the client certificate"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_http_basic_password" {
  description = "The password for the username"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_http_basic_username" {
  description = "The username that the REST Consumer will use to login to the REST host"
  type        = string
  default     = null
}

variable "authentication_http_header_name" {
  description = "The authentication header name"
  type        = string
  default     = null
}

variable "authentication_http_header_value" {
  description = "The authentication header value"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_oauth_client_id" {
  description = "The OAuth client ID"
  type        = string
  default     = null
}

variable "authentication_oauth_client_proxy_name" {
  description = "The name of the proxy to use"
  type        = string
  default     = null
}

variable "authentication_oauth_client_scope" {
  description = "The OAuth scope"
  type        = string
  default     = null
}

variable "authentication_oauth_client_secret" {
  description = "The OAuth client secret"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_oauth_client_token_endpoint" {
  description = "The OAuth token endpoint URL that the REST Consumer will use to request a token for login to the REST host"
  type        = string
  default     = null
}

variable "authentication_oauth_client_token_expiry_default" {
  description = "The default expiry time for a token, in seconds"
  type        = number
  default     = null
}

variable "authentication_oauth_jwt_proxy_name" {
  description = "The name of the proxy to use"
  type        = string
  default     = null
}

variable "authentication_oauth_jwt_secret_key" {
  description = "The OAuth secret key used to sign the token request JWT"
  type        = string
  default     = null
  sensitive   = true
}

variable "authentication_oauth_jwt_token_endpoint" {
  description = "The OAuth token endpoint URL that the REST Consumer will use to request a token for login to the REST host"
  type        = string
  default     = null
}

variable "authentication_oauth_jwt_token_expiry_default" {
  description = "The default expiry time for a token, in seconds"
  type        = number
  default     = null
}

variable "authentication_scheme" {
  description = "The authentication scheme used by the REST Consumer to login to the REST host"
  type        = string
  default     = null
}

variable "client_profile_name" {
  description = "The Client Profile of the REST Delivery Point"
  type        = string
  default     = null
}

variable "gateway_replace_target_authority_enabled" {
  description = "Enable or disable whether the authority for the request-target is replaced with that configured for the REST Consumer remote"
  type        = bool
  default     = null
}

variable "http_method" {
  description = "The HTTP method to use (POST or PUT)"
  type        = string
  default     = null
}

variable "local_interface" {
  description = "The interface that will be used for all outgoing connections associated with the REST Consumer"
  type        = string
  default     = null
}

variable "max_post_wait_time" {
  description = "The maximum amount of time (in seconds) to wait for an HTTP POST response from the REST Consumer"
  type        = number
  default     = null
}

variable "outgoing_connection_count" {
  description = "The number of concurrent TCP connections open to the REST Consumer"
  type        = number
  default     = null
}

variable "proxy_name" {
  description = "The name of the proxy to use"
  type        = string
  default     = null
}

variable "request_target_evaluation" {
  description = "The type of evaluation to perform on the request target"
  type        = string
  default     = null
}

variable "retry_delay" {
  description = "The number of seconds that must pass before retrying the remote REST Consumer connection"
  type        = number
  default     = null
}

variable "service" {
  description = "The name of the service that this REST Delivery Point connects to"
  type        = string
  default     = null
}

variable "tls_cipher_suite_list" {
  description = "The colon-separated list of cipher suites the REST Consumer uses in its encrypted connection"
  type        = string
  default     = null
}

variable "vendor" {
  description = "The name of the vendor that this REST Delivery Point connects to"
  type        = string
  default     = null
}


variable "request_headers" {
  description = "Request headers to be added to the HTTP request"
  type = set(object({
    header_name  = string
    header_value = optional(string)
  }))
  default = []
}

variable "protected_request_headers" {
  description = "Request headers to be added to the HTTP request"
  type = set(object({
    header_name  = string
    header_value = optional(string)
  }))
  default   = []
  sensitive = true
}

