# email-interpreter

This is a training project for learning how to integrate & deploy AWS services with Terraform from scratch to build a web app.

Plan is to build an email interpreter & sorter/tagger with potential use case being for sorting support queries to projects/products.

[Architecture with build stages.](https://drive.google.com/file/d/1Yp1ow8AeuAys3vMkmIVngSQfRvdKRS_f/view?usp=sharing)

## Prerequisites

- Install aws CLI of version 2.17.21 or above.
- Install tfenv CLI of version 3.0.0 or above.
- Install matching terraform version:

```sh
tfenv install
```

## Setup

- Create & populate a `.env` in the project root following the [template](.env.template).
- Initialise terraform:

```sh
cd terraform
terraform init
```

## Scripts

From project root:

### `./scripts/plan.sh`

Run local terraform plan.

### `./scripts/apply.sh`

Run local terraform apply.

## Important Notes

For cost saving purposes this setup uses an already owned domain for receiving emails.
Therefore, the domain & email address in SES must be verified manually following the instructions on these identities.
