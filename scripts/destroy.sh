export $(grep -v '^#' .env | xargs)

cd terraform

terraform apply -destroy "$PLAN_FILENAME"
