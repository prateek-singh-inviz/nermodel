touch temp.json
echo $gcp_credential > temp.json
sudo snap install google-cloud-cli --classic
export SERVICE_ACCOUNT='ner-275@onyx-principle-364411.iam.gserviceaccount.com'
export REGION='us-central1'
export ENDPOINT_NAME='ner-testing-v01'
export MODEL_NAME1='ner-v01-m01'
export MODEL1_ID='new-testing'
# export MODEL_NAME2='Model_3'
# export MODEL2_ID='MY_Model_03'
export ENDPOINT_ID='7879654'
export CONTAINER_IMAGE='gcr.io/onyx-principle-364411/nermodel@sha256:0bc7b2a364ebbe91e01b46bf0e4f7ff11db2e25d1d4b30c89c1bae3d92d62168'
export PROJECT='onyx-principle-364411'
gcloud auth activate-service-account $SERVICE_ACCOUNT --key-file=temp.json --project=$PROJECT

gcloud ai models upload --region=$REGION \
            --display-name=$MODEL_NAME1 \
            --container-image-uri=$CONTAINER_IMAGE \
            --model-id=$MODEL1_ID \
            --container-predict-route=/predict \
            --container-health-route=/live \
            --container-env-vars=DEVICE=cpu,TOPK=1    
          

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
