# Changes

All Changes and lesson learnt will be drafted here

### 28.10.2021

1. Here Module is introduced.
2. But in general here is web server deployed. All Information about
3. VPC is in the module.
4. There is a dedicated .README there
5. Here normal variables (which i learnt earlier) are defined in
6. variables. Small change, I'm directly pulling the ssh key from the AWS
7. How the tag is defined here is interesting
8. As of now web server is good but converted into load balancer. Need a work around to add "instances"
9. variable called "count" is introduced here, it is part of core terraform

### 29.10.2021

1. LB is completed. Only pending is testing. What would be interesting is for or count loop.
2. Next action would be to place them in different AZ and use Target groups