# Load Testing Aurora Serverless v2

This directory contains load tests used to validate the scalability of the Aurora Serverless v2 Database. The load tests are written in JavaScript and executed using k6. When executed, these scripts generate HTTP traffic toward the Application, driving realistisch load through both the application layer and database. 

K6 execution -> Application Load Balancer (ALB) -> ECS Fargate service (application) -> Aurora Serverless v2

## purpose of the tests

these load tests are used to:
- Validate Aurora Serverless v2 Sacling behavior (ACUs)
- Observe latency and error rates under load
- Possibly identify bottlenecks in:
    - Database performance
    - Application behavior
    - (ALB / ECS configuration)

## Prerequisites

before running the load tests, ensure the following prerequisites are met:

- K6 installed locally
    - Installation guide: https://grafana.com/docs/k6/latest/set-up/install-k6/
    - Verify the installation: k6 version
- A deployed and running environment:
    - ALB
    - ECS Fargate service
    - Aurora Serverless v2 database
- Stable network connection

## Available load tests in the directory

### 'check_loadtest.js'
    - lightweight validation tests
    - Gradual ramp-up and ramp-down
    - Used for:
        - Basic load Testing
        - Connectivity verification
        - Post-deployment verification

### 'stresstest_10k_3min.js'
    - short (3 minutes), High intensity stress test 
    - Used for:
        - Trigger Aurora Serverless v2 ACU Scaling
        - Observe behavior under sudden spikes

### 'stresstest_10k_10min.js'
    - Constant stress test (10 minutes)
    - Progressive ramp-up and ramp-down to 10000 requests
    - Used to:
        - Validate stability for a longer time with ramp up
        - Observe sustained ACU scaling behavior

### 'stresstest_20k.js'
    - High load stress test (~16 minutes)
    - Progressive ramp up and ramp down to 20.000 requests per minute
    - Used to:
        - Validate stability under higher sustained load
        - Observe Aurora Serverless v2 ACU scaling behavior
        - Identify latency increases or error rates at elevated traffic levels

### 'stresstest_50k.js'
    - Extreme load stress test (~16 minutes)
    - Progressive ramp up and ramp down to 50.000 requests per minute
    - Used to:
        - Validate stability under higher sustained load
        - Observe Aurora Serverless v2 ACU scaling behavior
        - Identify latency increases or error rates at elevated traffic levels


## Running a test

Tests are executed locally using K6, make sure to have read the prerequisites so you can follow this explanation. 

1. Make sure to copy the link of the deployed ALB (EC2 - Load Balancing - Load Balancers)

2. In the terminal (bash), navigate to the following directory: booomtag_cloud_1-main/AwsMultiContainer/loadtest (k6) 

3. Use k6 run 'file' to execute the file, for example: k6 run check_loadtest.js

4. Validate that the script is working by checking AWS metrics and test results in the terminal

5. Save important metrics after the test has ended and load has decreased