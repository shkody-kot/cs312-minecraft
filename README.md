# Minecraft Server
Previously the server was set up manually, but that's far too much work when we can automate the infrastructure provisioning and have Minecraft up and running with only a few keyboard strokes. The following guide uses Terraform and Bash scripts to provision infrastructure and a Docker container to run Minecraft on AWS. 
<br>
## Background and Setup
Before running any of the provided scripts, it's important to properly configure your directory and AWS credentials; otherwise none of the provisioning will work as intended. There are a couple of dependencies needed for the scripts, which can be installed manually or by running the `dependencies.sh` script provided in the repository; both require interacting with the terminal or command-line interface. The manual installation is as follows:
1. Open terminal
2. Install Terraform (the instructions are for a Debian-based distribution of Linux. Alternative installation instructions can be found [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
	- Run `sudo apt-get update && sudo apt-get install -y gnupg software-properties-common` to update your system and install the dependencies as needed by the rest of the setup commands.
	- Run `wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null` This command installs HashiCorp's GPG key, which is then used to verify the integrity of your installation. 
	- Run `gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint` This will verify the key's fingerprint and ensure that you're downloading the correct binaries.
	- Run `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list` This command adds HashiCorp's official repository to your system, allowing your package manager to find their products to install (such as Terraform).
	- Run `sudo apt update` to update your package manager to reflect the changes we made in the previous few commands.
	- Install the package we want by running `sudo apt-get install terraform`
	- Verify the installation by running `terraform -help`. It should output the syntax and command options that terraform accepts. 
	- For any troubleshooting, please refer to Terraform's [installation and troubleshooting guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
3. Install AWS CLI
	- Ensure that curl and a way to unzip packages is installd on your system. If they are not, curl can be installed via `sudo apt install curl` and an eqivalent unzipping tool for your operating system can be installed according to documentation of that tool. Many operating systems come with one pre-installed, however.
	- Fetch the package by running `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
	- Unzip the package: `unzip awscliv2.zip` For other unzipping tools, use the appropriate commands and options according to documentation.
	- Install the package: `sudo ./aws/install`
	- Verify your installation by running `aws --version`
<br>
The next steps are required for both manual installation and script installation, since they help you set up your AWS credentials such that the provisioning scripts function correctly. 

## Creating and Starting the Minecraft Server
Running the `spin-up-server.sh` script will provision all necessary AWS infrastructure, configure the instances, and launch the server. Upon execution, it will print out the public IP that users can connect to the server with.
### Run-down on the Provisioning Pipeline
1. Create VPC
2. Create Subnet
3. Create routing table and add routes between the subnet and the public internet
4. Create a security group to allow inbound SSH and port 25565 connections and all outbound connections
5. Create an EC2 instance
6. Connect the security group and VPC to the instance
7. Celebrate your new Infrastructure
8. Connect to the instance using SSH to configure the Minecraft server
9. haven't gotten there yet

### Connecting to the Server

## Shutting Down the Minecraft Server



