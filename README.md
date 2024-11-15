
# README

## Oppgave 1

- **HTTP Endepunkt for Lambdafunksjonen som sensor kan teste med Postman**:
  - [https://86pufabpl5.execute-api.eu-west-1.amazonaws.com/Prod/generate-image](https://86pufabpl5.execute-api.eu-west-1.amazonaws.com/Prod/generate-image)  <!-- Updated endpoint -->

- **Lenke til kjørt GitHub Actions workflow**:
  - [https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843678495/job/33008024357](https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843678495/job/33008024357)

---

## Oppgave 2

- **Lenke til kjørt GitHub Actions workflow (MAIN)**:
  - [https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843678501/job/33005925210](https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843678501/job/33005925210)

- **Lenke til en fungerende GitHub Actions workflow (ikke main)**:
  - [https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843573878/job/33005973793](https://github.com/Ernttimus/pgr301-exam-2024/actions/runs/11843573878/job/33005973793)

- **SQS-Kø URL**:
  - [https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue)

---

## Oppgave 3

- **Beskrivelse av taggestrategi**: 
  - Taggestrategien jeg har brukt er latest. Det for å gjøre det enkelt for meg å se nyeste eller det siste som har blitt pusha inn i docker repoet mitt. Dersom jeg puller vil nyeste utgave bli brukt.

- **Container image + SQS URL**:
  - **Container Image**: `testeksamenkr/java-sqs-client`
  - **SQS URL**: [https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue](https://sqs.eu-west-1.amazonaws.com/244530008913/image_processing_queue)

---

## Oppgave 4

- **Her ser du meldingene jeg har fått, jeg bekreftet at jeg vill subscribe til tjenesten**:
  
  ![Subscription Confirmation](img/messages.png)
  
- **Her er meldingen jeg fikk**:
  
  ![Operation Successful](img/det_fungerte.png)

---
