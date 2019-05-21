CONTAINER_DEFINITIONS=$(aws ecs describe-task-definition --task-definition practice-apache --region us-east-1 | jq ".taskDefinition.containerDefinitions")
echo $CONTAINER_DEFINITIONS
echo "---------------------------------------------------------------------------------------------------------------"
TARGET=$(echo $CONTAINER_DEFINITIONS | jq ".[].image" | grep apache)
echo "target image is  "$TARGET
REPLACEMENT="\"617272699181.dkr.ecr.us-east-1.amazonaws.com/apache-repo:3\""
#CONTAINER_DEFINITIONS="{$CONTAINER_DEFINITIONS/$TARGET/$REPLACEMENT}"
CONTAINER_DEFINITIONS=${CONTAINER_DEFINITIONS//$TARGET/$REPLACEMENT}
echo $CONTAINER_DEFINITIONS
TASK_ARN=$(aws ecs register-task-definition --region us-east-1 --family practice-apache --container-definitions "$CONTAINER_DEFINITIONS" --task-role-arn ecsTaskExecutionRole | jq --raw-output ".taskDefinition.taskDefinitionArn")
aws ecs update-service --region us-east-1 --cluster practice-cluster --service practice-apache-service --task-definition $TASK_ARN --force-new-deployment
echo $TASK_ARN