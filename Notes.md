# we learn every day
1. To get the latest ami ID, you need to use following commands and resources
    - aws ec2 describe-images --images-id 
    resource: https://letslearndevops.com/2018/08/23/terraform-get-latest-centos-ami/

## Date: 03.10.2021
* Launch configuration uses same parameters as EC2 Instance
    - ami is here image_id
    - security_groups_id is here security_groups

## Build blocks to build load balancer

* Target groups
* Listener rules
    - Path based (e.g. /marketing or /sales)
    - Host based (basically domain based)

### Launch Templates/Configuration

* Allows you define
  * AMI
  * Instance Type
  * Networking and security groups
  * user data and IAM Role
  * Lifecycle ist **must** and I should remember the purpose and need of it.
  * Storage and Key Pair
> Most important, LC is non-editable and old. LC has future and has versions

### Auto Scaling Groups

* They need Input from Launch configuration. Remember launch configuration defines what to provision and where and when to provisioned is defined in ASG
  * name
  * launch configuration
  * vpc
  * health check type

### Load Balancer creation

1. type of load balancer (internet facing or internal)
2. name of the load balancer
3. subnets
4. Security groups


### Listerners - is port and protocol LB is listening. But it is different resource

1. Protocol
2. Port

### Target group

1. name
2. target type (instance, IP or Lambda function)
3. Port and Protocol (this is same as listener but ports can be different)
4. health check

On Monday nothing was done.