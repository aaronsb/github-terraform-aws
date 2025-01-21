# AWS Terraform Hello World

This project demonstrates a simple "Hello World" application deployed on AWS using Terraform and Docker. It creates an EC2 instance that runs a Docker container which writes "Hello World" to `/tmp/hello.txt`.

## Step-by-Step Setup Guide

### 1. Initial Setup

#### 1.1 Create a GitHub Account
1. Go to [GitHub.com](https://github.com)
2. Click "Sign up"
3. Follow the registration process
4. Verify your email address

#### 1.2 Create an AWS Account
1. Go to [AWS Console](https://aws.amazon.com)
2. Click "Create an AWS Account"
3. Follow the registration process
   - You'll need a credit card
   - Choose the free tier option
   - Complete the verification process

#### 1.3 Install Required Software
1. **Git**
   - Windows: Download and install from [git-scm.com](https://git-scm.com)
   - Mac: Install via Homebrew: `brew install git`
   - Linux: `sudo apt-get install git` or `sudo yum install git`

2. **Terraform**
   - Download from [Terraform Downloads](https://www.terraform.io/downloads.html)
   - Extract the binary
   - Add to your system PATH:
     - Windows: Edit system environment variables
     - Mac/Linux: Move to `/usr/local/bin`
   - Verify installation: `terraform --version`

3. **AWS CLI**
   - Install from [AWS CLI Install Guide](https://aws.amazon.com/cli/)
   - Windows: Download and run the installer
   - Mac: `brew install awscli`
   - Linux: `sudo apt-get install awscli` or `sudo yum install awscli`
   - Verify installation: `aws --version`

### 2. AWS Configuration

#### 2.1 Create AWS IAM User
1. Log into AWS Console
2. Go to IAM (Identity and Access Management)
3. Click "Users" → "Add user"
4. Set username (e.g., "terraform-deployer")
5. Enable "Programmatic access"
6. Click "Next: Permissions"
7. Click "Attach existing policies directly"
8. Search and select:
   - AmazonEC2FullAccess
   - AmazonVPCFullAccess
   - AmazonS3FullAccess
9. Click "Next" until user creation is complete
10. **IMPORTANT**: Download or copy the Access Key ID and Secret Access Key
    - These will only be shown once
    - Keep them secure and never commit them to git

#### 2.2 Configure AWS CLI
1. Open terminal/command prompt
2. Run: `aws configure`
3. Enter the following when prompted:
   ```
   AWS Access Key ID: [Your Access Key]
   AWS Secret Access Key: [Your Secret Key]
   Default region name: us-west-2
   Default output format: json
   ```

### 3. Repository Setup

#### 3.1 Create New Repository
1. Go to GitHub
2. Click "+" → "New repository"
3. Name it "terraform-aws-hello-world"
4. Make it public or private
5. Don't initialize with README
6. Click "Create repository"

#### 3.2 Clone and Setup Project
1. Clone this repository
   ```bash
   git clone [original-repo-url]
   ```
2. Change to project directory
   ```bash
   cd [project-directory]
   ```
3. Set your repository as remote
   ```bash
   git remote set-url origin [your-repo-url]
   ```
4. Push code
   ```bash
   git push -u origin main
   ```

#### 3.3 Configure GitHub Secrets
1. Go to your repository on GitHub
2. Click "Settings" → "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Add the following secrets:
   - Name: `AWS_ACCESS_KEY_ID`
     Value: [Your AWS Access Key]
   - Name: `AWS_SECRET_ACCESS_KEY`
     Value: [Your AWS Secret Key]
   - Name: `AWS_REGION`
     Value: us-west-2

### 4. Deployment

#### 4.1 Local Deployment (Optional)
1. Initialize Terraform
   ```bash
   terraform init
   ```
2. Check deployment plan
   ```bash
   terraform plan
   ```
3. Apply changes
   ```bash
   terraform apply
   ```
4. Type "yes" when prompted

#### 4.2 GitHub Actions Deployment
1. Make a change to any file (e.g., add a comment)
2. Create a new branch
   ```bash
   git checkout -b feature/my-change
   ```
3. Commit and push
   ```bash
   git add .
   git commit -m "My change description"
   git push origin feature/my-change
   ```
4. Go to GitHub repository
5. Click "Pull requests" → "New pull request"
6. Select your branch
7. Create pull request
8. Wait for GitHub Actions to complete
9. Review the plan in PR comments
10. Merge PR to deploy changes

### 5. Verification

#### 5.1 Check Deployment
1. Go to AWS Console
2. Navigate to EC2 Dashboard
3. Find your instance (named "hello-world-instance")
4. Copy the Public IPv4 address

#### 5.2 Connect and Verify
1. SSH into instance:
   ```bash
   ssh ec2-user@[public-ip]
   ```
2. Check hello world output:
   ```bash
   cat /tmp/hello.txt
   ```
3. Verify Docker container:
   ```bash
   docker ps -a
   ```

### 6. Cleanup

#### 6.1 Destroy Infrastructure
1. If using GitHub Actions:
   - Create PR with changes to destroy
   - Review and merge
2. If using local Terraform:
   ```bash
   terraform destroy
   ```
3. Type "yes" when prompted

#### 6.2 Verify Cleanup
1. Check AWS Console
2. Verify EC2 instance is terminated
3. Check VPC has been removed

### 7. Troubleshooting

#### 7.1 Common Issues and Solutions

1. **Terraform Init Fails**
   - Check internet connection
   - Verify AWS credentials are set
   - Clear .terraform directory and retry

2. **AWS Authentication Fails**
   - Verify secret names in GitHub match workflow file
   - Check AWS credential values
   - Ensure IAM user has correct permissions

3. **Instance Connection Fails**
   - Wait 2-3 minutes for instance to fully initialize
   - Check security group allows SSH access
   - Verify you're using correct IP address

4. **Docker Container Issues**
   - SSH into instance
   - Check Docker service: `systemctl status docker`
   - View container logs: `docker logs $(docker ps -aq)`
   - Check cloud-init logs: `cat /var/log/cloud-init-output.log`

## Project Structure

```
.
├── main.tf         # Main Terraform configuration file
├── variables.tf    # Variable definitions
├── outputs.tf      # Output definitions
├── hello.sh        # Script that writes "Hello World"
├── Dockerfile      # Docker container definition
└── README.md       # This documentation
```

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer)
2. [AWS CLI](https://aws.amazon.com/cli/) installed and configured
3. AWS credentials configured with appropriate permissions
4. GitHub account for CI/CD workflow

## GitHub Actions CI/CD

This project includes a GitHub Actions workflow that automates the Terraform deployment process. The workflow:

1. Runs on pull requests to `main` branch:
   - Checks Terraform formatting
   - Initializes Terraform
   - Validates Terraform configuration
   - Runs `terraform plan` and posts the result as a PR comment

2. Runs on push to `main` branch:
   - Performs all above checks
   - Automatically applies the Terraform changes

### Required GitHub Secrets

Set up the following secrets in your GitHub repository (Settings -> Secrets and variables -> Actions):

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `AWS_REGION`: Your preferred AWS region (e.g., "us-west-2")

### CI/CD Security Considerations

- The AWS credentials used in GitHub Actions should have the minimum required permissions
- Consider using OpenID Connect (OIDC) for AWS authentication instead of long-lived credentials
- Review Terraform plans carefully before merging pull requests
- Consider adding required PR approvals before merging

## AWS Credentials Setup

1. Create an AWS account if you don't have one
2. Create an IAM user with programmatic access
3. Configure AWS credentials using one of these methods:
   ```bash
   # Method 1: AWS CLI
   aws configure

   # Method 2: Environment variables
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   export AWS_REGION="us-west-2"
   ```

## Infrastructure Components

The Terraform configuration creates the following AWS resources:

- VPC with CIDR block 10.0.0.0/16
- Public subnet with CIDR block 10.0.1.0/24
- Internet Gateway
- Route Table with public route
- Security Group allowing SSH access
- EC2 instance (t2.micro by default)

## Deployment Instructions

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the deployment plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```
   Type `yes` when prompted to confirm.

4. After successful deployment, Terraform will output:
   - `instance_public_ip`: Public IP of the EC2 instance
   - `instance_id`: ID of the EC2 instance

## Verification

1. Wait a few minutes for the instance to initialize and the Docker container to run

2. SSH into the instance:
   ```bash
   ssh ec2-user@<instance_public_ip>
   ```

3. Verify the output:
   ```bash
   cat /tmp/hello.txt
   ```
   You should see "Hello World"

4. Check Docker container status:
   ```bash
   docker ps -a
   ```

## Customization

### Region
Change the AWS region in `variables.tf`:
```hcl
variable "aws_region" {
  default = "your-preferred-region"
}
```

### Instance Type
Modify the EC2 instance type in `variables.tf`:
```hcl
variable "instance_type" {
  default = "your-preferred-instance-type"
}
```

## Cleanup

To avoid ongoing charges, destroy the infrastructure when no longer needed:

```bash
terraform destroy
```
Type `yes` when prompted to confirm.

## Security Considerations

This is a demonstration project and includes:
- Public SSH access (port 22) from any IP (0.0.0.0/0)
- A public subnet with internet access

For production use, consider:
- Restricting SSH access to specific IP ranges
- Implementing additional security groups
- Using private subnets with a bastion host
- Enabling AWS CloudWatch monitoring
- Implementing proper key management

## Troubleshooting

1. **SSH Connection Issues**
   - Verify the security group allows SSH access
   - Ensure you're using the correct key pair
   - Check the instance status in AWS Console

2. **Docker Issues**
   - Check Docker service status: `systemctl status docker`
   - View Docker logs: `docker logs <container_id>`
   - Check user_data script logs: `cat /var/log/cloud-init-output.log`

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
