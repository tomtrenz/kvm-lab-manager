# Pass this file to `terraform init -backend-config=...`; it is not loaded automatically.
# Backend type and key are selected by the deployment environment, never by this module.
address = "${TERRAFORM_BACKEND_ADDRESS}"
lock_address = "${TERRAFORM_BACKEND_LOCK_ADDRESS}"
unlock_address = "${TERRAFORM_BACKEND_UNLOCK_ADDRESS}"
username = "${TERRAFORM_BACKEND_USER}"
password = "${TERRAFORM_BACKEND_PASSWORD}"
lock_method = "POST"
unlock_method = "DELETE"
retry_wait_min = "${TERRAFORM_BACKEND_RETRY_SECONDS}"
