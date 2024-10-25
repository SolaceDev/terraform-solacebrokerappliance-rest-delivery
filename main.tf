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

locals {
  tls                    = startswith(lower(var.url), "https:")
  slashSplit             = split("/", var.url)
  isIpV6HostWithPort     = length(split("]", local.slashSplit[2])) == 2
  isIpV6NoPort           = local.isIpV6HostWithPort ? false : length(split(":", local.slashSplit[2])) > 2
  address                = local.isIpV6NoPort ? join(local.slashSplit[2], ["[", "]"]) : local.slashSplit[2]
  hostPortSplit          = local.isIpV6HostWithPort || local.isIpV6NoPort ? split("]:", trimprefix(local.address, "[")) : split(":", local.address)
  host                   = trimsuffix(local.hostPortSplit[0], "]")
  port                   = length(local.hostPortSplit) == 2 ? tonumber(local.hostPortSplit[1]) : (local.tls ? 443 : 80)
  path                   = "/${join("/", slice(local.slashSplit, 3, length(local.slashSplit)))}"
  headers_list           = tolist(var.request_headers)
  protected_headers_list = tolist(var.protected_request_headers)
}

resource "solacebroker_msg_vpn_rest_delivery_point" "main" {
  msg_vpn_name             = var.msg_vpn_name
  rest_delivery_point_name = var.rest_delivery_point_name
  enabled                  = var.enabled

  client_profile_name = var.client_profile_name
  service             = var.service
  vendor              = var.vendor
}

resource "solacebroker_msg_vpn_rest_delivery_point_rest_consumer" "main" {
  msg_vpn_name             = solacebroker_msg_vpn_rest_delivery_point.main.msg_vpn_name
  rest_delivery_point_name = solacebroker_msg_vpn_rest_delivery_point.main.rest_delivery_point_name
  enabled                  = solacebroker_msg_vpn_rest_delivery_point.main.enabled
  rest_consumer_name       = var.rest_consumer_name != null ? var.rest_consumer_name : "consumer"
  remote_host              = local.host
  remote_port              = local.port
  tls_enabled              = local.tls

  authentication_aws_access_key_id                 = var.authentication_aws_access_key_id
  authentication_aws_region                        = var.authentication_aws_region
  authentication_aws_secret_access_key             = var.authentication_aws_secret_access_key
  authentication_aws_service                       = var.authentication_aws_service
  authentication_client_cert_content               = var.authentication_client_cert_content
  authentication_client_cert_password              = var.authentication_client_cert_password
  authentication_http_basic_password               = var.authentication_http_basic_password
  authentication_http_basic_username               = var.authentication_http_basic_username
  authentication_http_header_name                  = var.authentication_http_header_name
  authentication_http_header_value                 = var.authentication_http_header_value
  authentication_oauth_client_id                   = var.authentication_oauth_client_id
  authentication_oauth_client_proxy_name           = var.authentication_oauth_client_proxy_name
  authentication_oauth_client_scope                = var.authentication_oauth_client_scope
  authentication_oauth_client_secret               = var.authentication_oauth_client_secret
  authentication_oauth_client_token_endpoint       = var.authentication_oauth_client_token_endpoint
  authentication_oauth_client_token_expiry_default = var.authentication_oauth_client_token_expiry_default
  authentication_oauth_jwt_proxy_name              = var.authentication_oauth_jwt_proxy_name
  authentication_oauth_jwt_secret_key              = var.authentication_oauth_jwt_secret_key
  authentication_oauth_jwt_token_endpoint          = var.authentication_oauth_jwt_token_endpoint
  authentication_oauth_jwt_token_expiry_default    = var.authentication_oauth_jwt_token_expiry_default
  authentication_scheme                            = var.authentication_scheme
  http_method                                      = var.http_method
  local_interface                                  = var.local_interface
  max_post_wait_time                               = var.max_post_wait_time
  outgoing_connection_count                        = var.outgoing_connection_count
  proxy_name                                       = var.proxy_name
  retry_delay                                      = var.retry_delay
  tls_cipher_suite_list                            = var.tls_cipher_suite_list
}

resource "solacebroker_msg_vpn_rest_delivery_point_queue_binding" "main" {
  msg_vpn_name             = solacebroker_msg_vpn_rest_delivery_point.main.msg_vpn_name
  rest_delivery_point_name = solacebroker_msg_vpn_rest_delivery_point.main.rest_delivery_point_name
  queue_binding_name       = var.queue_name
  post_request_target      = local.path

  gateway_replace_target_authority_enabled = var.gateway_replace_target_authority_enabled
  request_target_evaluation                = var.request_target_evaluation
}

resource "solacebroker_msg_vpn_rest_delivery_point_queue_binding_request_header" "main" {
  count = length(local.headers_list)

  msg_vpn_name             = solacebroker_msg_vpn_rest_delivery_point.main.msg_vpn_name
  rest_delivery_point_name = solacebroker_msg_vpn_rest_delivery_point.main.rest_delivery_point_name
  queue_binding_name       = solacebroker_msg_vpn_rest_delivery_point_queue_binding.main.queue_binding_name

  header_name  = local.headers_list[count.index].header_name
  header_value = local.headers_list[count.index].header_value
}

resource "solacebroker_msg_vpn_rest_delivery_point_queue_binding_protected_request_header" "main" {
  count = length(local.protected_headers_list)

  msg_vpn_name             = solacebroker_msg_vpn_rest_delivery_point.main.msg_vpn_name
  rest_delivery_point_name = solacebroker_msg_vpn_rest_delivery_point.main.rest_delivery_point_name
  queue_binding_name       = solacebroker_msg_vpn_rest_delivery_point_queue_binding.main.queue_binding_name

  header_name  = local.protected_headers_list[count.index].header_name
  header_value = local.protected_headers_list[count.index].header_value
}

