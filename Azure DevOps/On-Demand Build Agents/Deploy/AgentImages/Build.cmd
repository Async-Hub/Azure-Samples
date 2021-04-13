docker build -t xxx.azurecr.io/azure-devops/agent/dotnet/sdk:5.0 .

docker run -e AZP_URL=https://dev.azure.com/xxx -e AZP_TOKEN=6tswj7dleqy6bbcsvjfamochb7jn5rhwgcey3speowxzcmitv3hq -e AZP_AGENT_NAME=OnDemandAgent xxx.azurecr.io/azure-devops/agent/dotnet/sdk:5.0