# Solace PubSub+ Appliance REST Delivery Terraform Module

This Terraform module supports the setup of a [REST consumer](https://docs.solace.com/API/REST/REST-Consumers.htm) on the [Solace PubSub+ Appliance](https://solace.com/products/event-broker/).

Given a queue on the broker, as a destination for messages to be forwarded to a REST consumer application, this module configures a [REST delivery point](https://docs.solace.com/API/REST/REST-Consumers.htm#_Toc433874658) between the queue and the application.

Specific use case details are provided in the [Examples](#examples) section.

## Limitations

This module only supports one queue binding per REST delivery point. Configure a new REST delivery point using the module for an additional queue.

Adding extra OAuth JWT claims to the REST consumer is not supported in the current module. Support will be added in a later release.

## Module input variables

### Required

* `msg_vpn_name` - REST delivery points are specific to a Message VPN on the broker.
* `rest_delivery_point_name` - The name of the REST delivery point to be created.
* `url` - The REST consumer destination URL including base URL and endpoint path. The path portion of the URL may contain [substitution expressions](https://docs.solace.com/Messaging/Substitution-Expressions-Overview.htm). To specify an IPv6 address with port, the required format is the address to be [enclosed in square brackets](https://www.rfc-editor.org/rfc/rfc3986.html#section-3.2.2).
* `queue_name` - The name of the queue to bind to.

Important: The REST delivery point must have permission to consume messages from the queue — to achieve this, the queue’s owner must be set to `#rdp/<rest_delivery_point_name>` or the queue’s permissions for non-owner clients must be set to at least `consume` level access. Queue ingress and egress must also be enabled.

### Optional

* `client_profile_name` - The [client profile associated](https://docs.solace.com/Services/Managing-RDPs.htm#associating-client-profiles-with-REST-delivery-points). If not provided, the `default` client profile for the Message VPN will be associated.
* `request_headers` - A set of request headers to be added to the HTTP request.
* `protected_request_headers` - A set of protected request headers with sensitive value to be added to the HTTP request.
* `rest_consumer_name` - The name of the REST consumer to be created. The default is `consumer`.

Additional optional module variables names are the same as the underlying resource attributes. To determine the variable name mappings, we recommend that you look for matching attribute names in the documentation for the resource:

| Resource name |
|---------------|
|[solacebroker_msg_vpn_rest_delivery_point](https://registry.terraform.io/providers/SolaceProducts/solacebrokerappliance/latest/docs/resources/msg_vpn_rest_delivery_point#optional)|
|[solacebroker_msg_vpn_rest_delivery_point_rest_consumer](https://registry.terraform.io/providers/SolaceProducts/solacebrokerappliance/latest/docs/resources/msg_vpn_rest_delivery_point_rest_consumer#optional)|
|[solacebroker_msg_vpn_rest_delivery_point_queue_binding](https://registry.terraform.io/providers/SolaceProducts/solacebrokerappliance/latest/docs/resources/msg_vpn_rest_delivery_point_queue_binding#optional)|
|[solacebroker_msg_vpn_rest_delivery_point_queue_binding_request_header](https://registry.terraform.io/providers/SolaceProducts/solacebrokerappliance/latest/docs/resources/msg_vpn_rest_delivery_point_queue_binding_request_header#optional)|
|[solacebroker_msg_vpn_rest_delivery_point_queue_binding_protected_request_header](https://registry.terraform.io/providers/SolaceProducts/solacebrokerappliance/latest/docs/resources/msg_vpn_rest_delivery_point_queue_binding_protected_request_header#optional)|

The default value for most of the optional variables is `null`, meaning that if you don’t provide a value then the default value of the resource is provisioned on the event broker.

-> The module default for the `enabled` optional variable is `true`, which differ from the resource attribute default.

## Module outputs

[Module outputs](https://developer.hashicorp.com/terraform/language/values/outputs) provide reference to created resources. Any reference to a resource that has not been created will be set to `(null)`.

Note that the "rest consumer" and the "protected request headers" outputs are [sensitive](https://developer.hashicorp.com/terraform/language/values/outputs#sensitive-suppressing-values-in-cli-output).

## Providers

| Name | Version |
|------|---------|
| <a name="provider_solacebrokerappliance"></a> [solacebrokerappliance](https://registry.terraform.io/providers/SolaceProducts/solacebrokerappliance/latest) | >= 1.1 |

## Resources

The following table shows the resources created. "X" denotes a resource that is always created, "O" denotes a resource that you have the option to create.  

| Name | |
|------|------|
| solacebroker_msg_vpn_rest_delivery_point | X |
| solacebroker_msg_vpn_rest_delivery_point_rest_consumer | X |
| solacebroker_msg_vpn_rest_delivery_point_queue_binding | X |
| solacebroker_msg_vpn_rest_delivery_point_queue_binding_request_header | O |
| solacebroker_msg_vpn_rest_delivery_point_queue_binding_protected_request_header | O |

## Examples

The following examples demonstrate several specific use cases for this module:

- [Basic](examples/basic)
- [Substitution expressions](examples/using-substitution-expressions)
- [Adding headers](examples/adding-headers)

## Module use recommendations

This module is expected to be used primarily by application teams. It supports provisioning rest delivery required by a specific application. It may be forked and adjusted with private defaults.

## Resources

For more information about Solace technology in general please visit these resources:

- Solace [Technical Documentation](https://docs.solace.com/)
    - [Managing REST Delivery Points](https://docs.solace.com/Services/Managing-RDPs.htm)
- The Solace Developer Portal website at: [solace.dev](//solace.dev/)
- Understanding [Solace technology](//solace.com/products/platform/)
- Ask the [Solace community](//dev.solace.com/community/).
