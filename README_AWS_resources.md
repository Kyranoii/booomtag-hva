# AWS resources starting point

VPC stands for virtual private cloud this is a isolated virtual network inside your aws cloud. it gives you control over everything it is basicly your own data center with the benefits of the scaling infrastructure of AWS.
A VPC has one subnet in a availabilty zone, ec2 instances in each subnet and a internet gateaway for communication between your resources and in your vpc and the internet. 

There are 3 tiers of vpc network infrastructure patterns, Tier 1, 2 and 3 the differnces lay in the amount and type of subnets used. Tier 1 has one subnet and everythings lays within it this makes it the easiest and quickest to setup but there is no scalability and security because of the lack of isolation. Tier 2 has a public subnet for the webapp and a private one for the database with a NAT gateway for internet access. It is a bit more complex and cost more because of the NAT gateway and the extra subnet but there is isolation which equals security and is easily scalable with load balancers and autoscaling groups. Tier 3 is used by big companies it has a public subnet for load balancers and two private subnets. One for application containers and another for the databases This has the strongest security supports compliance like ISO and is higly fault tolarant and has multi AZ. It is very complex to manage though and is expensive.

Subnet is a range of IP adresses inside the VPC. A public subnet has direct route to a internet gateway,
resources in a public subnet can access the public internet. A private subnet doesn't have that direct route and needs a NAT (network acces translation) device to acces the public internet.

A subnet must be associated with a route table which specifies the allowed routes for outbound traffic leaving the subnet. Every subnet created is automaticly associated with the main route, you can change this and also the contents of the main route.

Route tables serves as the traffic controller of your VPC. Each route table contains a set of rules called routes, these determine where your traffic from your subnet or gateway is directed. You can add additional route tables to specify which on premise networks or other VPC's your VPC can communicate with this can create complex networking architectures. each route specifies a destination and a target like a internet gateway.

Aurora is a database that is compatible with MySQL. An Aurora cluster volume can grow to a maximum size of 128 tebibytes. It also automates and standardizes database clustering and replication. An Aurora DB cluster is a team of
databases that share the same data. You have two types of database instances inside a cluster, a Primary (writer) and a Replica (reader) there also recides a cluster volume inside the DB cluster. Cluster volume is the data inside the DB that is spread over different availability zones with each zone having a copy of the DB cluster data. This means if one zone goes down the data is still running and safe because there are other zones with the exact same data. The Primary (writer) instance
supports write operations and performs all data modifications to the cluster volume. Each DB cluster has a primary instance. The Replica (reader) instance connects to the same storage volume as the Primary DB but supports only read operations. Each DB cluster can have upto 15 Replicas instances in addition of the Primary instance. Maintain high availability by locating Replicas in seperate Availabilty zones. Aurora automaticlly fails over to a Replica when the Primary DB instance becomes unavailable. Replicas can also offload read workloads from the Primary DB instance.

Aurora Serverless is a autoscaling configuration that automates the capacity needed based on the applications demand. Your only charged for the resources that the DB cluster consumes. It can help you stay within budget and avoid payments for computer resources you don't use.

## Links
https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html
https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.html
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html
https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.how-it-works.html
https://medium.com/@ugot4daniel/deploy-a-dynamic-web-app-on-aws-with-terraform-docker-amazon-ecr-ecs-c785aa0f8dc7
