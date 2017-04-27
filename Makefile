STACK_NAME = s3strm-settings
STACK_TEMPLATE = file://./cfn.yaml
SETTINGS_BUCKET = $(shell ./bin/setting SETTINGS_BUCKET)
MOVIES_BUCKET = $(shell ./bin/setting MOVIES_BUCKET)
OMDB_API_KEY = $(shell ./bin/setting OMDB_API_KEY)
API_GATEWAY_DOMAIN = $(shell ./bin/setting API_GATEWAY_DOMAIN)
API_GATEWAY_DOMAIN_HOSTED_ZONE_ID = $(shell ./bin/setting API_GATEWAY_DOMAIN_HOSTED_ZONE_ID)

deploy:
	$(eval ACTION ?= $(shell ./bin/cloudformation_action $(STACK_NAME)))
	aws cloudformation ${ACTION}-stack                                       \
	  --stack-name "${STACK_NAME}"                                            \
	  --template-body "${STACK_TEMPLATE}"                                     \
	  --parameters                                                            \
	    ParameterKey=SettingsBucket,ParameterValue=${SETTINGS_BUCKET}         \
	    ParameterKey=OMDbAPIKey,ParameterValue=${OMDB_API_KEY}                \
	    ParameterKey=APIGatewayDomain,ParameterValue=${API_GATEWAY_DOMAIN}    \
	    ParameterKey=APIGatewayDomainHostedZoneId,ParameterValue=${API_GATEWAY_DOMAIN_HOSTED_ZONE_ID}    \
	    ParameterKey=MoviesBucket,ParameterValue=${MOVIES_BUCKET}             \
	  --capabilities CAPABILITY_IAM                                           \
	  2>&1
	@aws cloudformation wait stack-${ACTION}-complete \
	  --stack-name ${STACK_NAME}

