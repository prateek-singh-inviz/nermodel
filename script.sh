touch temp.json
echo $gcp_credential > temp.json
sudo snap install google-cloud-cli --classic
export SERVICE_ACCOUNT='naveen-mid-access@inviz-gcp.iam.gserviceaccount.com'
export REGION='asia-south1'
export ENDPOINT_NAME='spellcheck-vertex-ai-ep-mr-2'
export MODEL_NAME1='spellcheck-model-demo-v32'
export MODEL1_ID='spellcheck-model-id-finalbf2'
# export MODEL_NAME2='Model_3'
# export MODEL2_ID='MY_Model_03'
export ENDPOINT_ID='11903123'
export CONTAINER_IMAGE='gcr.io/inviz-gcp/spellcheck-vi-automation:latest'
export PROJECT='inviz-gcp'
gcloud auth activate-service-account $SERVICE_ACCOUNT --key-file=temp.json --project=$PROJECT

gcloud ai models upload --region=$REGION \
            --display-name=$MODEL_NAME1 \
            --container-image-uri=$CONTAINER_IMAGE \
            --model-id=$MODEL1_ID \
            --container-predict-route=/predict \
            --container-health-route=/live \
            --container-env-vars=DEVICE=cpu,TOPK=1    
          

# gcloud ai endpoints create --region=$REGION \
#              --display-name=$ENDPOINT_NAME \
#              --endpoint-id=$ENDPOINT_ID
             
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
