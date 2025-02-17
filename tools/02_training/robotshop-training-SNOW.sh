
export APP_NAME=robot-shop
export INDEX_TYPE=changerisk


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



if [[  $WAIOPS_NAMESPACE =~ "" ]]; then
    # Get Namespace from Cluster 
    echo "   ------------------------------------------------------------------------------------------------------------------------------"
    echo "   🔬 Getting Installation Namespace"
    echo "   ------------------------------------------------------------------------------------------------------------------------------"
    export WAIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
    echo "       ✅ CP4WAIOps:         OK - $WAIOPS_NAMESPACE"
else
    echo "       ✅ CP4WAIOps:         OK - $WAIOPS_NAMESPACE"
fi




if [[ $ROUTE =~ "ai-platform-api" ]]; then
    echo "       ✅ OK - Route:         OK"
else
    echo "       🛠️   Creating Route"
    oc create route passthrough ai-platform-api -n $WAIOPS_NAMESPACE  --service=aimanager-aio-ai-platform-api-server --port=4000 --insecure-policy=Redirect --wildcard-policy=None
    export ROUTE=$(oc get route -n $WAIOPS_NAMESPACE ai-platform-api  -o jsonpath={.spec.host})
    echo "        Route: $ROUTE"
    echo ""
fi
echo ""




echo "  ***************************************************************************************************************************************************"
echo "   🛠️   Create Analysis Definiton: Change Risk"
export FILE_NAME=create-analysis-CR.graphql
./tools/02_training/scripts/execute-graphql.sh

echo "  ***************************************************************************************************************************************************"
echo "   🛠️   Create Analysis Definiton: Similar Incidents"
export FILE_NAME=create-analysis-SI.graphql
./tools/02_training/scripts/execute-graphql.sh

echo "  ***************************************************************************************************************************************************"
echo "   🛠️   Run Analysis: Change Risk"
export FILE_NAME=run-analysis-CR.graphql
./tools/02_training/scripts/execute-graphql.sh

echo "  ***************************************************************************************************************************************************"
echo "   🛠️   Run Analysis: Similar Incidents"
export FILE_NAME=run-analysis-SI.graphql
./tools/02_training/scripts/execute-graphql.sh



