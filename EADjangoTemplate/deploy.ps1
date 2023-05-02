# read params
param([switch]$noBuild, [switch]$noPush, [switch]$noDeploy, [switch]$escapeJson)

# get branch
$git_branch = git rev-parse --abbrev-ref HEAD

if ($git_branch -eq "master")
{
    # Change for production
    $CONTAINER_SERVICE_NAME = "{app_name}-sandbox-cont-01"
    $ENDPOINT_NAME = "production"
}
else
{
    $CONTAINER_SERVICE_NAME = "{app_name}-sandbox-cont-01"
    $ENDPOINT_NAME = "sandbox"
}


# build the docker image
if (-not $noBuild)
{
    docker build -t {app_name}-image:latest --build-arg APP_ENV=$ENDPOINT_NAME .
}



$REGION = "us-west-2"

if (-not $noPush)
{
    # upload the docker image for this pipeline
    aws lightsail push-container-image --region $REGION --service-name $CONTAINER_SERVICE_NAME --label "{app_name}-$ENDPOINT_NAME-deploy" --image {app_name}-image
}

# get uploaded image (its different every time)
$IMAGE_TAG = aws lightsail get-container-images --service-name $CONTAINER_SERVICE_NAME --region $REGION --query "containerImages[0].image"

# get environment variables from previous deployment
$PREVIOUS_DEPLOYMENT_JSON = aws lightsail get-container-service-deployments --service-name $CONTAINER_SERVICE_NAME --region $REGION --query 'deployments[0]'
$ENVIRONMENT_QUERY = "deployments[0].containers.`"$ENDPOINT_NAME`".environment"
$ENVIRONMENT_VARIABLES_JSON = aws lightsail get-container-service-deployments --service-name $CONTAINER_SERVICE_NAME --region $REGION --query $ENVIRONMENT_QUERY

$DEPLOYMENT = $PREVIOUS_DEPLOYMENT_JSON | ConvertFrom-Json
$ENVIRONMENT_VARIABLES = $ENVIRONMENT_VARIABLES_JSON | ConvertFrom-Json
$DEPLOYMENT.containers[0]."$ENDPOINT_NAME".environment = $ENVIRONMENT_VARIABLES
$DEPLOYMENT.containers[0]."$ENDPOINT_NAME".image = $IMAGE_TAG.Trim('"')
$DEPLOYMENT.containers[0]."$ENDPOINT_NAME".PSObject.Properties.Remove("command")

$CONTAINER_JSON = $DEPLOYMENT.containers | ConvertTo-Json
if ($escapeJson)
{
    $CONTAINER_JSON = $CONTAINER_JSON -replace '"', '\"'
}

if (-not $noDeploy)
{
    # create a deployment with uploaded docker image
    aws lightsail create-container-service-deployment --service-name $CONTAINER_SERVICE_NAME --region $REGION `
--containers @"
    $CONTAINER_JSON
"@ `
--public-endpoint "containerName=`"$ENDPOINT_NAME`",containerPort=80,healthCheck={healthyThreshold=2,unhealthyThreshold=2,timeoutSeconds=2,intervalSeconds=5,path=`"/`",successCodes=`"200-499`"}"

}
else
{
    Write-Output $CONTAINER_JSON
}