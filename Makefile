LAMBDA_FUNCTION_NAME_PROD=action-test
LAMBDA_HANDLER=core::handler
LAMBDA_RUNTIME=java11
LAMBDA_MEMORY=512
LAMBDA_TIMEOUT=10
LAMBDA_ROLE=arn:aws:iam::140131123595:role/lambda-s3-sqs
LAMBDA_ENV_PROD='Variables={FARM_PRODUCT_MARKET_PRICE_API_KEY="",AWS_S3_BUCKET_NAME="farmmorning-market-price-v2"}'

build:
	$(MAKE) clean
	$(MAKE) aot
	$(MAKE) pack

clean:
	rm -rf classes
	rm -f lambda.zip

aot:
	mkdir -p classes
	clojure -M:aot

pack:classes
	clojure -M:pack mach.pack.alpha.aws-lambda -C:aot lambda.zip

# Production
prod-deploy:
	$(MAKE) build
	$(MAKE) prod-update

prod-create:lambda.zip
	aws lambda --profile me create-function \
	--function-name $(LAMBDA_FUNCTION_NAME_PROD) \
	--handler $(LAMBDA_HANDLER) \
	--runtime $(LAMBDA_RUNTIME) \
	--memory $(LAMBDA_MEMORY) \
	--timeout $(LAMBDA_TIMEOUT) \
	--role $(LAMBDA_ROLE) \
	--environment ${LAMBDA_ENV_PROD} \
	--zip-file fileb://./lambda.zip \
	--no-cli-pager

prod-update:lambda.zip
	aws lambda --profile me  update-function-code \
	--function-name $(LAMBDA_FUNCTION_NAME_PROD) \
	--zip-file fileb://./lambda.zip \
	--no-cli-pager
	aws lambda --profile me update-function-configuration \
	--function-name $(LAMBDA_FUNCTION_NAME_PROD) \
	--handler $(LAMBDA_HANDLER) \
	--runtime $(LAMBDA_RUNTIME) \
	--memory $(LAMBDA_MEMORY) \
	--timeout $(LAMBDA_TIMEOUT) \
	--role $(LAMBDA_ROLE) \
	--no-cli-pager

prod-update-env:lambda.zip
	aws lambda --profile me  update-function-configuration \
	--function-name $(LAMBDA_FUNCTION_NAME_PROD) \
	--environment ${LAMBDA_ENV_PROD} \
	--no-cli-pager

# Development
LAMBDA_FUNCTION_NAME_DEV=market-price-collector-dev
LAMBDA_ENV_DEV='Variables={FARM_PRODUCT_MARKET_PRICE_API_KEY="",AWS_S3_BUCKET_NAME="farmmorning-market-price-dev"}'

dev-deploy:
	$(MAKE) build
	$(MAKE) dev-update

dev-create:lambda.zip
	aws lambda --profile me  create-function \
	--function-name $(LAMBDA_FUNCTION_NAME_DEV) \
	--handler $(LAMBDA_HANDLER) \
	--runtime $(LAMBDA_RUNTIME) \
	--memory $(LAMBDA_MEMORY) \
	--timeout $(LAMBDA_TIMEOUT) \
	--role $(LAMBDA_ROLE) \
	--environment ${LAMBDA_ENV_DEV} \
	--zip-file fileb://./lambda.zip \
	--no-cli-pager

dev-update:lambda.zip
	aws lambda --profile me update-function-code \
	--function-name $(LAMBDA_FUNCTION_NAME_DEV) \
	--zip-file fileb://./lambda.zip \
	--no-cli-pager
	aws lambda --profile me update-function-configuration \
	--function-name $(LAMBDA_FUNCTION_NAME_DEV) \
	--handler $(LAMBDA_HANDLER) \
	--runtime $(LAMBDA_RUNTIME) \
	--memory $(LAMBDA_MEMORY) \
	--timeout $(LAMBDA_TIMEOUT) \
	--role $(LAMBDA_ROLE) \
	--no-cli-pager

dev-update-env:lambda.zip
	aws lambda --profile me update-function-configuration \
	--function-name $(LAMBDA_FUNCTION_NAME_DEV) \
	--environment ${LAMBDA_ENV_DEV} \
	--no-cli-pager

dev-delete:
	aws lambda --profile me delete-function
	--function-name $(LAMBDA_FUNCTION_NAME_DEV)
	--no-cli-pager

