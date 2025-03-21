export $(grep -v '^#' .env | xargs)

cd terraform

terraform apply "$PLAN_FILENAME"
