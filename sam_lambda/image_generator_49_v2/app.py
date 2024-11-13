import json
import boto3
import base64
import random
import os

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")
model_id = "amazon.titan-image-generator-v1"
bucket_name = os.getenv("BUCKET_NAME")
candidate_number = os.getenv("CANDIDATE_NUMBER")

def lambda_handler(event, context):
    """Generate an image based on the prompt and store it in S3."""
    try:
        prompt = json.loads(event.get("body", "{}")).get("prompt", "Default prompt")

        seed = random.randint(0, 2147483647)
        s3_image_path = f"{candidate_number}/generated_images/titan_{seed}.png"
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 1024,
                "width": 1024,
                "seed": seed,
            }
        }

        model_response = json.loads(bedrock_client.invoke_model(
            modelId=model_id, body=json.dumps(native_request)
        )["body"].read())
        image_data = base64.b64decode(model_response["images"][0])

        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Image generated successfully for prompt: '{prompt}', maybe try a different prompt?",
                "s3_uri": f"s3://{bucket_name}/{s3_image_path}"
            }),
        }

    except Exception as e:
        print(f"Error generating image: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to generate image", "error": str(e)})
        }
