export $(grep -v '^#' .env | xargs)

cd terraform

terraform plan \
    -var "project_name=email-interpreter" \
    -var "domain_name=$DOMAIN_NAME" \
    -var "email_address=$EMAIL_ADDRESS" \
    -out="$PLAN_FILENAME"
