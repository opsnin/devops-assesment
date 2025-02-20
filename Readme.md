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

## Note 
- Image Build is triggered in each terraform apply.

## 2. Retrieve API Information

1. Get the API endpoint URL from Terraform output:
   ```
   export API_ENDPOINT=$(API_ID=$(aws apigateway get-rest-apis --region ap-south-1 --query 'items[?name==`GameRESTAPI`].id' --output text) && \
   STAGE=$(aws apigateway get-stages --rest-api-id $API_ID --region ap-south-1 --query 'item[0].stageName' --output text) && \
   echo "https://$API_ID.execute-api.ap-south-1.amazonaws.com/$STAGE") && echo $API_ENDPOINT
  
   ```

2. Get the API ID:
   ```
   export API_ID=$(aws apigateway get-rest-apis --region ap-south-1 --query 'items[?name==`GameRESTAPI`].id' --output text)
   ```

3. Get the API key ID:
   ```
   export API_KEY_ID=$(aws apigateway get-api-keys --region ap-south-1 --query 'items[?name==`GameAPIKey`].id' --output text)
   ```

4. Retrieve the API key (this will display the actual key):
   ```
   export API_KEY=$(aws apigateway get-api-key --region ap-south-1 --api-key $API_KEY_ID --include-value --query 'value' --output text)
   ```

## Notes
- Here GameRESTAPI used above is name of API created, you can update with what-ever name you have provided. You can provide name of Rest API from .tfvars file which i have provided a demo.tfvars. 
- Also please update region to whatever region you are deploying these resources.

## 3. Test API Endpoints

 Use curl to test endpoints:

   List Games:
   ```
   curl -X GET "$API_ENDPOINT/list-games" \           
   -H "x-api-key: "$API_KEY""
   ```

   Create Game:
   ```
   curl -X POST "$API_ENDPOINT/create-game" \
   -H "x-api-key: "$API_KEY"" \
   -H 'Content-Type: application/json' \
   -d '{"name": "New Game"}'
   ```

   Update Game:
   ```
   curl -X PUT "$API_ENDPOINT/update-game" \
   -H "x-api-key: $API_KEY" \
   -H 'Content-Type: application/json' \
   -d '{"name": "Updated Game"}'
   ```

   External Call:
   ```
   curl -X GET "$API_ENDPOINT/external-call" \
   -H "x-api-key: $API_KEY"
   ```

Replace `<api-endpoint>` and `<api-key>` with actual api endpoint and api key from step 2.
Here default is the stage , i have used default stage, if you update any other stage then default update it accordingly.

## Notes

- Ensure you have the necessary permissions to create and manage AWS resources.
- The API is secured with an API key. Always include the `x-api-key` header in your requests.
- For any issues, check the CloudWatch logs for the Lambda function and API Gateway.