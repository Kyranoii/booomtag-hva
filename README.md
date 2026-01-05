# Deploying with AWS and Terraform

## Getting started

Welcome to booomtags test/work enviorment in this document we will go over the deployment of the webapp inside aws using terraform.

### AWS CLI configuration
- Check your current AWS configuration:`aws configure list`
- If not configured yet, run:`aws confiure`

## Terraform setup
1. Navigate to the project folder

2. Initialize Terraform:  `terraform init`

3. Set DB user and Password if not done yet: 
 ```
  export TF_VAR_db_username="dev"   
  export TF_VAR_db_password="supersecret"
```
4. Preview changes:`terraform plan`

5. Apply changes to deploy resources:`terraform apply`

## Docker & ECS Deployment
Login to ECR so you can push your docker image to it.
HEADS UP put in the region your deploying from:  
```
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 511877958163.dkr.ecr.eu-central-1.amazonaws.com
```

### Build docker images 
(for mac and windows) HEADS UP one is in app folder.    
```
docker buildx build --platform linux/amd64 -t booomtag-app .
```

### Tag Docker Image
```
docker tag booomtag-app:latest 511877958163.dkr.ecr.eu-central-1.amazonaws.com/booomtag-dev-repo:latest
```

### Push the image
```
docker push 511877958163.dkr.ecr.eu-central-1.amazonaws.com/booomtag-dev-repo:latest
```

**tell ECS to pull latest image and update ecs containers. Then redeploys.**
```
aws ecs update-service \
  --cluster booomtag-dev-cluster \
  --service booomtag-dev-service \
  --force-new-deployment
```

**Create the user table for testing in AWS query editor.**
```
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(255),
    birthdate DATE,
    username VARCHAR(100),
    password VARCHAR(255)
);
```

**Insert data for visual front-end.**
```
INSERT INTO users (firstname, lastname, email, birthdate, username, password)
SELECT
    CONCAT('First', FLOOR(RAND() * 100000)) AS firstname,
    CONCAT('Last', FLOOR(RAND() * 100000)) AS lastname,
    CONCAT('user', FLOOR(RAND() * 100000), '@example.com') AS email,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 20000) DAY) AS birthdate,
    CONCAT('user', FLOOR(RAND() * 1000000)) AS username,
    UUID() AS password
FROM
    (SELECT 1 FROM information_schema.COLUMNS LIMIT 10000) AS x;
```

## Cleanup
To destroy all resources: 
`terraform destroy`

** Always destroy after testing ect. or else the costs will ramp up.


**if terraform can't destroy the repo do it manually and destroy again.**
```
aws ecr batch-delete-image \
  --repository-name booomtag-dev-repo \
  --image-ids imageTag=latest
```
