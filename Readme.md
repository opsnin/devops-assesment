## Before Running you need to have:

- AWS CLI configured with appropriate credentials
- Terraform installed
- Docker installed (for local testing if needed)

## 1. Deploy Infrastructure with Terraform

1. Clone git repo & Go to to directory.
   ```
    git clone https://github.com/opsnin/devops-assesment.git
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

## 2. Retrieve API Information

1. Get the API endpoint URL from Terraform output:
   ```
   terraform output api_endpoint
   ```

2. Get the API ID:
   ```
   API_ID=$(aws apigateway get-rest-apis --query 'items[?name==`GameRESTAPI`].id' --output text)
   ```

3. Get the API key ID:
   ```
   API_KEY_ID=$(aws apigateway get-api-keys --query 'items[?name==`GameAPIKey`].id' --output text)
   ```

4. Retrieve the API key (this will display the actual key):
   ```
   API_KEY=$(aws apigateway get-api-key --api-key $API_KEY_ID --include-value --query 'value' --output text)
   ```

## 3. Test API Endpoints

 Use curl to test endpoints:

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

Replace `<api-endpoint>` and `<api-key>` with actual api endpoint and api key from step 2.
Here default is the stage , i have used default stage, if you update any other stage then default update it accordingly.

## Notes

- Ensure you have the necessary permissions to create and manage AWS resources.
- The API is secured with an API key. Always include the `x-api-key` header in your requests.
- For any issues, check the CloudWatch logs for the Lambda function and API Gateway.