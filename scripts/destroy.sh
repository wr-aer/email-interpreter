export $(grep -v '^#' .env | xargs)

cd terraform

terraform destroy "$PLAN_FILENAME"
