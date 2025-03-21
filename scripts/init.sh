export $(grep -v '^#' .env | xargs)

cd terraform

terraform init
