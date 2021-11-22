
# Welcome to DevOpsDayTLV 2021 workshop

## Intro

  

This workshop designed to show the basics of zero trust with Hashicorp Terraform, Vault, Consul and Boundary.

During this workshop we provision HCP consul and HCP Vault, VPC, Boundary server, EKS.

Later we deploy mysql, vault injector, consul catalog sync, consul terraform sync and configure boundary.

  

This guide assumes you're on linux/Mac, you have github and AWS accounts.

  

## Steps

  

### AWS + Terraform Cloud Setup

<details>
  <summary>Click to expand!</summary>
  
0. Copy the following lines to your favorite editor

```sh

export TF_VAR_tfc_organization_name=""

export TF_VAR_oauth_token_id=""

export TF_VAR_github_username=""

export TF_VAR_tfc_token=""

export AWS_ACCESS_KEY_ID=""

export AWS_SECRET_ACCESS_KEY=""

```

1. Login to your AWS account and switch to Frankfurt region

2. Go to IAM service

3. Create user / use existing user

4. Create new access key

5. Copy and insert your access key and secret access keys to the proper values

6. Go to EC2 service

7. Click on Launch Instances

8. Click on Community AMIs

9. Type in a searchbar devopsdays

10. Choose devopsdays2021-hashicorp-terasky ami and click select

11. Choose t3.medium instance and click "Next: Configure instance details"

12. Ensure you deploy in to default VPC / subnet with access to the internets and Public IP assignment

13. Click Next until you reach "step 6: configure security group"

14. Ensure your ssh is open from your ip (or anywhere if you're lazy)

15. Click on "Review and Launch"

16. Click on "Launch"

17. Choose existing key pair / create new key pair - download it and chmod the key pair to 600

18. Click that you acknowledge ... and click "Launch Instances"

19. In your browser go to https://terraform.io

20. Click on "Terraform Cloud"

21. Click on Create Account

22. Type your username, email and password, agree and acknowledge T&S and Private Policy (if you agree and acknowledge) and click on "Create account"

23. Check your email and peform email validation

24. Click on "Start from scratch"

25. Type your Terraform Cloud "Organization name"

26. Copy your Terraform Cloud "Organization name" to the value of TF_VAR_tfc_organization_name

27. Instead of creating new workspace click on the Terraform Cloud "Organization name" in the upper left corner.

28. Click on "Settings"

29. Click on "Providers"

30. Click on "Add a VCS Provider"

31. Click on GitHub and choose "Github.com (Custom)"

32. Click on the link "register a new OAuth Application"

33. Copy your "Application Name", "Homepage URL", "Authorization callback URL" from Terraform cloud setup provider page to your github.

34. And click "Register Application" **on your github page**

35.  **On your github page** click on "Generate a new client secret"

36. Copy client ID from github and paste it to Terraform cloud

37. Type Github in the "Name" field on your Terraform cloud add vcs provider page

38. Copy "Client Secret" **from your github page** and paste it Terraform cloud add vcs provider page "Client Secret" field

39. Click on "Connect and Continue"

40. Provde username and password for your github if asked

41. Click on "Authorize <your  github  user>"

42. Click on "Skip and Finish"

43. Copy "OAuth token ID" and paste it in the value of TF_VAR_oauth_token_id in your favorite editor

44. Type your github username in the value of TF_VAR_github_username

45. On Terraform Cloud page click on "API Tokens"

46. Click on "Create an organization token"

47. Copy the token to the value of TF_VAR_tfc_token

</details>

### Setup Hashicorp Cloud Platform

<details>
  <summary>Click to expand!</summary>
  
1. Browse to https://cloud.hashicorp.com

2. Click on "Start a free trial"

3. Click on "Sign up"

4.  **Click on "Sign up"**

5. Type your email address and click "Continue'

6. Type your password and click continue

7. Click on "I Agree and I Accept" (assuming you agree and accept)

8. Click "Continue"

9. Check your email and perform email verification

10. Choose your country and click "Create Organization"

11. Click "Skip for now" to try HCP for free

12. Click on "Access control (IAM)"

13. Click on "Service principals"

14. Click on "+Create service principal"

15. Type a name in the "Name" field

16. Choose "Admin" Role

17. Click on "Save"

18. Click on "Create service principal key"

19. Copy clientID and client secret and **remember which is which** or you will have to do step "Fixing Mistake"

</details>

### TFC seeding

<details>
  <summary>Click to expand!</summary>
  
1. Broswe to "https://github.com/DevOpsDaysTLV/2021-Hashicorp-Terrasky-Workshop"

2. Click on "fork" in right upper corner

3. Choose you personal user as forking destination

4. ** In your AWS console* go to "EC2 service" click on "Instances" and check the box near the instance that was previously started.

5. Copy the "Public IPv4 address"

6. Open terminal and connect to the instance with the key you downloaded/created previously

```sh

ssh -i <some_key.pem> ubuntu@<public_ipv4>

```

7. On the instance perform

```sh

sudo -i

docker pull devopsdaystlv/2021-hashicorp-terashy-workshop:amd64

docker run -it devopsdaystlv/2021-hashicorp-terashy-workshop:amd64 bash

```

8. Inside container run the following commands to avoid accidental exit/logouts

```sh

export IGNOREEOF=4

alias exit='echo "Are you insane?! Over my dead body"'

```

***Note: To leave container press CTRL+D 5 times consecutivly***

9. Inside container run copy and paste all the environment variable you've created earlier in your favorite editor

10. Inside container run

```sh

terraform init

terraform apply

```

11. Open Terraform Cloud browser window. Click on "TerraformCloudSeed" workspace, click on "Variables", locate "TFE_TOKEN".

12. Click on "..." and then click "Edit"

13. Copy the value of "TF_VAR_tfc_token" from your favorite editor to Value of "TFE_TOKEN" in Terraform Cloud window, check "Sensitive" checkbox, then click "Save Variable"

14. Click on "Actions", click on "Start new plan", fill the reason for starting a plan and click on "Start plan"

15. Wait until finished.

16. Click on Organization name in left upper corner and should see 4 workspaces "EKS","HCP","VPC" and "TerraformCloudSeed"

</details>  

### Setup VPC + EKS

<details>
  <summary>Click to expand!</summary>
  
1. In your Terraform Cloud window click on HCP workspace

2. Click on Variables

3. Locate "HCP_CLIENT_ID" variable, click on "...", click on "Edit", replace the text "Provide me and make me sensetive" with value of HCP Client Id that was created earlier, check "Sensetive" checkbox and click on "Save Variable"

4. Locate "HCP_CLIENT_SECRET" variable, click on "...", click on "Edit", replace the text "Provide me and make me sensetive" with value of HCP Client Secret that was created earlier, check "Sensetive" checkbox and click on "Save Variable"

5. Click on "Setting" in the top menu bar

6. Click on "Variables Sets"

7. In your terminal inside container perform the following commands

```sh

bash -x varsets.sh

```

8. In your Terraform Cloud window refresh the "Variable sets" page, you should find newly created "Variable set"

9. Click on "DevOpsDays2021Workshop" variable set

10. Locate "AWS_ACCESS_KEY_ID" and "AWS_SECRET_ACCESS_KEY" edit and replace the placeholders with proper values from your favorite browser, check "Sensetive" checkbox and "Save variable"

11. Locate "Workspaces" section on "Variable sets" Page, ensure "Apply to specific workspaces" selected and type "VPC","EKS","HCP" in "Find workspaces this variable set should be shared with".

12. Click on "Save variable set"

13. Click on "Organization name" to return to the list of workspaces

14. Click on "VPC" workspace, click on "Actions", click on "Start new plan", type the "reason for starting plan" and click on "Start plan"

15. Wait until apply of "VPC" workspace is complete

16. Click on Organization name to see all workspaces. Completion of "VPC" workspace supposed to trigger "HCP" and "EKS" workspaces.

</details>

### Vault demo

1. In your terminal inside container perform the following commands

```sh

./vault-demo.sh

```

2. Click enter everytime promp appears and follow the instructions

### Consul demo

1. In your terminal inside container perform the following commands

```sh

./consul-demo.sh

```

2. Click enter everytime promp appears and follow the instructions

### Cts demo

1. In your terminal inside container perform the following commands

```sh

./cts-demo.sh

```

2. Click enter everytime promp appears and follow the instructions

  

## Videos of demos

Comming soon

All the credentials have been erased (I hope)
