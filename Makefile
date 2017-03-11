STACK_NAME = s3strm-settings
STACK_TEMPLATE = file://./cfn.yaml
SETTINGS_BUCKET_NAME = $(shell ./bin/setting SETTINGS_BUCKET_NAME)
OMDB_API_KEY = $(shell ./bin/setting OMDB_API_KEY)

deploy:
	$(eval ACTION ?= $(shell ./bin/cloudformation_action $(STACK_NAME)))
	@aws cloudformation ${ACTION}-stack                                       \
	  --stack-name "${STACK_NAME}"                                            \
	  --template-body "${STACK_TEMPLATE}"                                     \
	  --parameters                                                            \
	    ParameterKey=SettingsBucketName,ParameterValue=${SETTINGS_BUCKET_NAME} \
	    ParameterKey=OMDbAPIKey,ParameterValue=${OMDB_API_KEY}                \
	  --capabilities CAPABILITY_IAM                                           \
	  2>&1
	@aws cloudformation wait stack-${ACTION}-complete \
	  --stack-name ${STACK_NAME}

