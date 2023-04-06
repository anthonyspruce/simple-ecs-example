# simple-ecs-example
This repository contains a simple example of an ECS setup with a simple pipeline.

## Overview
The repository uses VPC configuration and Load Balancing in order to deploy a simple ECS service.

The ECS Service leverages AWS Fargate for hosting.

Blue/Green is not configured in this sample, albeit it is recommended.

## Additional Notes & Security Tips
- Because this is a sample, please note that a NAT GATEWAY is enabled, and could result in fairly high costs if this is left active for an extended period of time.
- It's recommended to adjust the terraform to support a Remote State provider, and Locking provider such as AWS (S3/DynamoDB) before using it in production to ensure that state isn't localised to your machine.
- This configuration uses HTTP Only for the ALB. This is because creating an ALB Listener requires an SSL, which isn't able to be automatically procured within this example. (see aws_acm_certificate, and aws_acm_certificate_validation)
- Egress is unrestricted outbound for this example, it's advised to lock egress down where possible.
- Access logs are disabled on the ALB, but it's recommended that you may offload these to an S3 bucket or similar.

## Demo Notes
This environment is built as a very simple ECS demonstration, and can be expanded on by adding in additional features such as:
- Integration with CodePipeline, which sources from something like a Github or CodeCommit repository. This could allow you to build the image dynamically and push into an ECR repo which is then sourced within the pipeline.
- Integration with CodeDeploy in order to add a full blue/green deployment scenario.
- Implementation of SSL on the ALB endpoint.