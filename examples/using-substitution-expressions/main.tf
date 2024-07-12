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

provider "solacebroker" {
  username = "admin"
  password = "admin"
  url      = "http://localhost:8080" # adjust to your appliance management host and SEMP port
}

# The RDP requires a queue to bind to.
# Option: Use the queue-endpoint module to create the queue. If using this option then also uncomment the queue_name in module "testrdp" below.
# module "rdp_queue" {
#   source = SolaceProducts/queue-endpoint/solacebroker
#
#   msg_vpn_name  = "default"
#   endpoint_type = "queue"
#   endpoint_name = "rdp_queue"
#
#   # The REST delivery point must have permission to consume messages from the queue
#   # — to achieve this, either the queue’s owner must be set to `#rdp/<rest_delivery_point_name>`
#   # owner = "#rdp/basic_rdp"
#   #   or the queue’s permissions for non-owner clients must be set to at least `consume` level access
#   permission = "consume"
#
#   # The queue must also be enabled for ingress and egress, which is the default for the rdp_queue module
# }
resource "solacebroker_msg_vpn_queue" "rdp_queue" {
  msg_vpn_name    = "default"
  queue_name      = "rdp_queue"
  permission      = "consume"
  ingress_enabled = true
  egress_enabled  = true
}

module "testrdp" {
  source = "../.."

  msg_vpn_name             = "default"
  rest_delivery_point_name = "basic_rdp"
  url                      = "http://example.com/$${msgId()}"
  # queue_name              = module.rdp_queue.queue.queue_name
  queue_name = solacebroker_msg_vpn_queue.rdp_queue.queue_name
  request_headers = [
    {
      header_name  = "header1"
      header_value = "$${uuid()}"
    }
  ]
}

output "rdp" {
  value = module.testrdp.rest_delivery_point
}

output "consumer" {
  value     = module.testrdp.rest_consumer
  sensitive = true
}

output "queue_binding" {
  value = module.testrdp.queue_binding
}
