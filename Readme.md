## Before Running you need to have:

- AWS CLI configured with appropriate credentials
- Terraform installed
- Docker installed (for local testing if needed)

## 1. Deploy Infrastructure with Terraform

1. Go to to directory.
   ```
    cd devops-assessment
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Plan the deployment:
   ```
   terraform plan
   ```

4. Apply the changes:
   ```
   terraform apply
   ```

5. Type 'yes' when prompted to confirm.

This process will:
- Create the ECR repository
- Build and push the Docker image
- Set up the Lambda function
- Configure the API Gateway

Note: Image Build is triggered in each terraform apply.

## 2. Test API Endpoints

1. Get your API key and endpoint URL from Terraform outputs:
   ```
   terraform output api_endpoint
   terraform output api_key
   ```

2. Use curl to test endpoints:

   List Games:
   ```
   curl -X GET 'https://<api-endpoint>/default/list-games' \
   -H 'x-api-key: <api-key>'
   ```

   Create Game:
   ```
   curl -X POST 'https://<api-endpoint>/default/create-game' \
   -H 'x-api-key: <api-key>' \
   -H 'Content-Type: application/json' \
   -d '{"name": "New Game"}'
   ```

   Update Game:
   ```
   curl -X PUT 'https://<api-endpoint>/default/update-game' \
   -H 'x-api-key: <api-key>' \
   -H 'Content-Type: application/json' \
   -d '{"name": "Updated Game"}'
   ```

   External Call:
   ```
   curl -X GET 'https://<api-endpoint>/default/external-call' \
   -H 'x-api-key: <api-key>'
   ```

Replace `<api-endpoint>` and `<api-key>` with the values from the Terraform outputs.

## Notes

- Ensure you have the necessary permissions to create and manage AWS resources.
- The API is secured with an API key. Always include the `x-api-key` header in your requests.
- For any issues, check the CloudWatch logs for the Lambda function and API Gateway.