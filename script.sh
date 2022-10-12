touch temp.json
echo $gcp_credential > temp.json
sudo snap install google-cloud-cli --classic
export SERVICE_ACCOUNT='nermodelfull@test-project-365213.iam.gserviceaccount.com'
export REGION='us-central1'
export ENDPOINT_NAME='ner-testing-v5'
export MODEL_NAME1='ner-v01-m5'
export MODEL1_ID='new-testing-5'
# export MODEL_NAME2='Model_3'
# export MODEL2_ID='MY_Model_03'
export ENDPOINT_ID='11908235'
export CONTAINER_IMAGE='gcr.io/test-project-365213/ner-model-inference-v2:latest'
export PROJECT='test-project-365213'
export GOOGLE_APPLICATION_CREDENTIALS=temp.json
gcloud auth activate-service-account $SERVICE_ACCOUNT --key-file=temp.json --project=$PROJECT

gcloud ai models upload --region=$REGION \
            --display-name=$MODEL_NAME1 \
            --container-image-uri=$CONTAINER_IMAGE \
            --model-id=$MODEL1_ID \
            --container-predict-route=/predict \
            --container-health-route=/live \
            --container-env-vars=INFERENCE_DEVICE=gpu,TOPK=1 \
            --container-ports=[5000]
          

gcloud ai endpoints create --region=$REGION \
              --display-name=$ENDPOINT_NAME \
              --endpoint-id=$ENDPOINT_ID
             
 #gcloud ai endpoints delete $ENDPOINT_ID --region=$REGION -q

gcloud ai endpoints deploy-model $ENDPOINT_ID --region=$REGION \
          --project=$PROJECT \
          --model=$MODEL1_ID \
          --display-name=$MODEL_NAME1 \
          --machine-type=n1-highmem-2 \
          --min-replica-count=1 \
          --max-replica-count=2 \
          --traffic-split=0=100

#gcloud ai models delete $MODEL1_ID --region=$REGION
