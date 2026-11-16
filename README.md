# AWS 3-Tier Architecture using Terraform

## Project Overview

Designed and provisioned a 3-Tier Architecture on AWS using Terraform (Infrastructure as Code), following a modular approach to automate infrastructure deployment.

The architecture separates networking, application, and database resources into different layers to improve isolation, security, and scalability.

The infrastructure is deployed in the AWS Mumbai region (`ap-south-1`) across two Availability Zones.

## Architecture

The project consists of three tiers:

**1. Presentation Tier**
- Application Load Balancer deployed in public subnets.
- Receives HTTP requests from users on port 80.
- Forwards incoming traffic to healthy application instances.

**2. Application Tier**
- Amazon EC2 instances deployed in private subnets.
- Apache web server installed using EC2 user data.
- Auto Scaling Group manages the desired number of application instances.
- Launch Template defines the EC2 configuration.
- Application instances receive traffic only from the ALB Security Group.

**3. Database Tier**
- Amazon RDS for MySQL deployed in private database subnets.
- Database instance configured as `db.t3.micro`.
- Database access restricted to the Application Security Group on port 3306.
- Public accessibility disabled.

## AWS Services Implemented

- **Amazon VPC:** Created an isolated network with CIDR `10.0.0.0/16`.
- **Public and Private Subnets:** Created six subnets across two Availability Zones.
- **Internet Gateway:** Provides internet connectivity to public subnets.
- **NAT Gateway:** Enables outbound internet access from private application subnets.
- **Route Tables:** Configured routing between public and private network layers.
- **Application Load Balancer:** Distributes incoming HTTP traffic across application instances.
- **Amazon EC2:** Hosts the Apache web server.
- **Auto Scaling Group:** Maintains the desired application instance capacity.
- **Launch Template:** Defines EC2 instance settings.
- **Amazon RDS:** Provisions a managed MySQL database.
- **Security Groups:** Restrict communication between the architecture layers.
- **Terraform:** Automates infrastructure provisioning through reusable modules.

## Network Configuration

Created a VPC with CIDR block `10.0.0.0/16` and distributed resources across two Availability Zones.

The network contains:

- Two public subnets for the internet-facing load balancer and NAT Gateway.
- Two private application subnets for EC2 instances.
- Two private database subnets for RDS network placement.

Configured an Internet Gateway for public subnet connectivity and a NAT Gateway to allow outbound internet access from private application subnets.

Database subnets are isolated from direct internet access.

## Security Implementation

Configured separate Security Groups for the Load Balancer, Application, and Database layers.

- ALB Security Group allows public HTTP traffic on port 80.
- Application Security Group allows HTTP traffic only from the ALB Security Group.
- Database Security Group allows MySQL traffic on port 3306 only from the Application Security Group.

The RDS instance is configured as non-publicly accessible.

## Terraform Module Structure

Organized the Terraform configuration into three reusable modules to separate infrastructure responsibilities.

**Networking Module**
- VPC and subnet creation.
- Internet Gateway and NAT Gateway.
- Route tables and associations.
- Network configuration across two Availability Zones.

**Compute Module**
- Application Load Balancer.
- Target Group and HTTP Listener.
- EC2 Launch Template.
- Auto Scaling Group.
- Load Balancer and Application Security Groups.

**Database Module**
- RDS DB Subnet Group.
- MySQL database instance.
- Database Security Group.

The root module connects these components by passing required resource IDs and configuration values between modules.

## Deployment Workflow

Used Terraform to provision the complete infrastructure.

The deployment workflow includes:

1. Configured the AWS provider for the Mumbai region.
2. Initialized Terraform and downloaded the required providers and modules.
3. Validated the Terraform configuration.
4. Reviewed the execution plan before provisioning.
5. Deployed the networking infrastructure.
6. Provisioned the load balancer and application compute resources.
7. Deployed the MySQL database in private subnets.
8. Verified the infrastructure and application endpoint.

## Application Testing

Deployed an Apache web server on the EC2 instances using a Launch Template and user data.

The Application Load Balancer forwards HTTP requests to the registered application instances through the Target Group.

Verified the application by accessing the ALB DNS endpoint through a web browser and checking the returned Hello World page.

**Implementation note:** The current application serves a static Apache web page. The RDS MySQL instance is provisioned as the database tier, but application-to-database integration has not yet been implemented.

## Terraform Commands

Initialize the working directory:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Preview infrastructure changes:

```bash
terraform plan
```

Provision AWS resources:

```bash
terraform apply
```

View Terraform outputs:

```bash
terraform output
```

Destroy the infrastructure after testing:

```bash
terraform destroy
```

## Key Learnings

- Designed a multi-tier AWS network architecture across two Availability Zones.
- Implemented public and private subnet routing.
- Configured ALB traffic distribution to private EC2 instances.
- Used Launch Templates and Auto Scaling Groups for application infrastructure.
- Provisioned Amazon RDS in private database subnets.
- Applied Security Group restrictions between architecture layers.
- Used Terraform modules to organize and automate AWS infrastructure.
- Practiced the complete infrastructure lifecycle, from initialization and deployment to resource cleanup.


