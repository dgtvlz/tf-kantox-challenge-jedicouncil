# tf-kantox-challenge-jedicouncil

## Architecture

![Architecture Diagram](docs/kantox-jedi.drawio.png)

The solution follows a serverless architecture pattern leveraging various AWS services:

- **API Gateway**: Serves as the entry point for client (The Council) requests and manages API traffic. It exposes two endpoints: one for updating jedi's information and another for retrieving jedi's information.
  
- **Lambda Functions**: Responsible for processing API requests and interacting with DynamoDB. Two Lambda functions are deployed:
  - `update-location`: Handles update requests from the API Gateway. It validates incoming data and updates records in the DynamoDB table.
  - `get-location`: Processes get requests from the API Gateway. It retrieves data from DynamoDB based on the Jedi's ID.

- **DynamoDB**: A NoSQL database service used to store and manage data. It stores records in a structured format, allowing for efficient retrieval and querying.

- **KMS**: A Customer Managed Key is used to encrypt the DynamoDB table in order to securely preserve Jedi's information.

- **Cloudwatch**: Cloudwatch is used to log the Council update requests.

- **IAM**: IAM Roles and Policies are used to manage the permissions between services.


## Prerequisites

- **Terraform**: Version 1.5.5 or higher. (It may work with previous versions if needed)
- **AWS Credentials**: You need valid AWS credentials to authenticate with AWS programmatically.

## Setup

Follow these steps to set up the solution:

1. **Clone the Repository**: Clone the repository to your local machine:

    ```bash
    git clone https://github.com/dgtvlz/tf-kantox-challenge-jedicouncil
    ```

2. **Adjust Configuration**: Adjust the `terraform/dev.auto.tfvars` file as needed.

3. **Prepare Terraform Backend**: Comment out or delete the current `terraform/backend.tf` file.

4. **Initialize Terraform**: Initialize Terraform in the `terraform` directory:

    ```bash
    cd terraform
    terraform init
    ```

5. **Apply Terraform Configuration**: Apply the Terraform configuration to deploy the solution:

    ```bash
    terraform apply
    ```

6. **Migrate Terraform State**: Migrate from a local Terraform state to a remote backend, reinitialize Terraform after deploying the solution:

    ```bash
    terraform init
    ```

    Follow the prompts to migrate the existing local state to the remote backend.

Once these steps are completed, the solution will be deployed in your AWS account, including a bucket and a DynamoDB table to manage the Terraform state remotely.

## Usage

## Terraform

The solution leverages several Terraform modules to provision and manage resources on AWS:

1. **KMS (Key Management Service)**:
   - Module: [cloudposse/kms-key/aws](https://registry.terraform.io/modules/cloudposse/kms-key/aws)
   - Description: This module provisions a customer-managed KMS key on AWS, which is used to encrypt sensitive data.

2. **Lambda Functions**:
   - Module: [terraform-aws-modules/lambda/aws](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws)
   - Description: This module simplifies the creation of AWS Lambda functions, which are used to execute code in response to API Gateway events.

3. **Terraform State Backend**:
   - Module: [cloudposse/tfstate-backend/aws](https://registry.terraform.io/modules/cloudposse/tfstate-backend/aws)
   - Description: This module sets up a remote backend for storing Terraform state files on AWS, enabling collaboration and state management.

## Future Improvements