module "vault_policy" {
  source      = "../../../modules/vault/policy"
  policy_name = var.vault_policy_name
  secret_path = var.vault_secret_path
}
