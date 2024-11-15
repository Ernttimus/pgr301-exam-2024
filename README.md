
# README

## Oppgave 1

- **HTTP Endpoint for Lambda Function** (can be tested with Postman):
  - [https://86pufabpl5.execute-api.eu-west-1.amazonaws.com/Prod/generate-image](https://86pufabpl5.execute-api.eu-west-1.amazonaws.com/Prod/generate-image)  <!-- Updated endpoint -->

- **GitHub Actions Workflow Link**:
  - [Workflow Run](https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843678495/job/33008024357)

---

## Oppgave 2

- **GitHub Actions Workflow (Main Branch)**:
  - [Main Workflow Run](https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843678501/job/33005925210)

- **GitHub Actions Workflow (Non-Main Branch)**:
  - [Workflow Run](https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843573878/job/33005973793)

- **SQS Queue URL**:
  - [https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue)

---

## Oppgave 3

- **Tagging Strategy**: 
  - The tagging strategy used is `latest`. This simplifies tracking of the most recent push to my Docker repository. Pulling the latest tag ensures using the most recent version.

- **Container Image and SQS URL**:
  - **Container Image**: `testeksamenkr/java-sqs-client`
  - **SQS URL**: [https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue)

---

## Oppgave 4

- **Subscription Confirmation Messages**:
  
  Confirmation message that I have subscribed to the service:
  
  ![Subscription Confirmation](img/messages.png)
  
- **Successful Message**:

  The message I received confirming successful operation:
  
  ![Operation Successful](img/det_fungerte.png)

---
