# Minecraft Server
Previously the server was set up manually, but that's far too much work when we can automate the infrastructure provisioning and have Minecraft up and running with only a few keyboard strokes. The following guide uses Terraform and Bash scripts to provision infrastructure and a Docker container to run Minecraft on AWS. 
<br>
## Background and Setup
Before running any of the provided scripts, it's important to properly configure your directory and AWS credentials; otherwise none of the provisioning will work as intended. There are a couple of dependencies needed for the scripts, which can be installed manually or by running the `dependencies.sh` script provided in the repository; both require interacting with the terminal or command-line interface. It is recommended to use the setup script; but the manual installation is as follows:
1. Open terminal
2. Install Terraform (the instructions are for a Debian-based distribution of Linux. Alternative installation instructions can be found [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) Run the following commands:
	- `sudo apt-get update && sudo apt-get install -y gnupg software-properties-common` to update your system and install the dependencies as needed by the rest of the setup commands.
	- `wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null` This command installs HashiCorp's GPG key, which is then used to verify the integrity of your installation. 
	- `gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint` This will verify the key's fingerprint and ensure that you're downloading the correct binaries.
	- `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list` This command adds HashiCorp's official repository to your system, allowing your package manager to find their products to install (such as Terraform).
	- `sudo apt update` to update your package manager to reflect the changes we made in the previous few commands.
	- Install the package we want by running `sudo apt-get install terraform`
	- Verify the installation by running `terraform -help`. It should output the syntax and command options that terraform accepts.
	- Run `terraform init` 
	- For any troubleshooting, please refer to Terraform's [installation and troubleshooting guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
3. Install AWS CLI
	- Ensure that curl and a way to unzip packages is installd on your system. If they are not, curl can be installed via `sudo apt install curl` and an eqivalent unzipping tool for your operating system can be installed according to documentation of that tool. Many operating systems come with one pre-installed, however.
	- Fetch the package by running `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
	- Unzip the package: `unzip awscliv2.zip` For other unzipping tools, use the appropriate commands and options according to documentation.
	- Install the package: `sudo ./aws/install`
	- Verify your installation by running `aws --version`
4. Create SSH keys
	- Run `ssh-keygen -t rsa -b 4096`
	- When it asks for a filename, type `minecraft-automation`. This is important for the scripts to work properly. 
	- When prompted for a password, hit Enter. Hit it again as it re-prompts. 
	- Run `mv minecraft-automation minecraft-automation.pem`
	- Run `chmod 400 minecraft-automation.pem` to ensure correct permissions on the key. 
<br>
The next steps are required for both manual installation and script installation, since they help you set up your AWS credentials such that the provisioning scripts function correctly.

1. In the AWS Learner Lab, start the lab
2. When it starts, click on AWS Details
3. Click on `Show CLI`
4. Copy all three tokens: there should be `aws_access_key_id`, `aws_secret_access_key` and `aws_session_token`
5. In your terminal, run `mkdir ~/.aws` if the directory is not already present.
6. Run `touch ~/.aws/credentials`
7. Edit the file: `vim ~/.aws/credentials`
8. Ensure the first line says `[default]` then paste the three tokens we copied earlier underneath. the file should look something like this:
```
[default]
aws_access_key_id=AAAAAAAAAAAAAAAAAA
aws_secret_access_key=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
aws_session_token=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaverylongstring
```

Now we can begin to run scripts to set up our Minecraft Server!

## Creating and Starting the Minecraft Server
Running the `./spin-up-server.sh` script will provision all necessary AWS infrastructure, configure the instances, and launch the server. Upon execution, it will print out the public IP that users can connect to the server with. The first time you run this script, it will require several user interactions:

	- To provision infrastructure, Terraform will ask if you are sure: type `yes` and hit enter.
	- On the first SSH login to the EC2 instance, it will ask if you recognize the key: type `yes` and hit enter. 

### Run-down on the Provisioning Pipeline
1. Create VPC
2. Create Subnet
3. Create routing table and add routes between the subnet and the public internet
4. Create a security group to allow inbound SSH and port 25565 connections and all outbound connections
5. Create an EC2 instance
6. Connect the security group and VPC to the instance
7. Celebrate your new Infrastructure
8. Run configuration script

### Run-down on configuration Pipeline (run automatically)
1. Connect to the instance using SSH to configure the Minecraft server
2. Install Java and create appropriate working directories for the server
3. Create Minecraft user
4. Fetch server jar file
5. Run server to create all neccesary files and accept EULA
6. Create service to start server on system restart/reboot
7. Create service to stop server on system shutdown 
8. Print public IP of the server

### Connecting to the Server
To connect to the server, open the Minecraft client, and select version 1.20.6 (latest version at the time of me writing this). Click `Play`. Once the client loads, select `Multiplayer`. There are two options: Direct Connect, or Create New Server. Both work, but Direct Connect is less steps so that's the one I will describe.
1. Select `Direct Connect`
2. Enter the public IP from the script output
3. Click `Join Server`
4. Enjoy your Minecraft Experience. 

## Shutting Down the Minecraft Server
To shut down the server and all the infrastructure, run `./shut-down-server.sh`. Terraform will prompt you again: type `yes` and hit enter. It might take a few minutes to shut down completely.  


#### Sources
1. [Minecraft Server on AWS EC2](https://aws.amazon.com/blogs/gametech/setting-up-a-minecraft-java-server-on-amazon-ec2/)
2. [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/) I visited this site many....many...times.
3. [SSH via Terraform](https://medium.com/@akilblanchard09/creating-aws-ec2-instances-with-ssh-access-using-terraform-f9c3c2996cbd)
4. [Terraform and Security Groups](https://spacelift.io/blog/terraform-security-group)
5. [More on Security Groups](https://stackoverflow.com/questions/58998659/how-to-attach-a-security-group-to-aws-instance-in-terraform)
6. [Ansible Documentation](https://docs.ansible.com/ansible/latest/collections/amazon/aws/) I didn't end up using Ansible, but I tried for a while.
7. [Minecraft Docker container](https://hub.docker.com/r/itzg/minecraft-server)
8. [More Ansible](https://medium.datadriveninvestor.com/devops-using-ansible-to-provision-aws-ec2-instances-3d70a1cb155f)
9. [EC2 Credentials](https://docs.aws.amazon.com/singlesignon/latest/userguide/howtogetcredentials.html)
10. [Bash package installed one-liner](https://stackoverflow.com/questions/1298066/how-can-i-check-if-a-package-is-installed-and-install-it-if-not) 
