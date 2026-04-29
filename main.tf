resource "azurerm_key_vault" "default" {
  name                = "kv-jacek-12345"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"


  soft_delete_retention_days = 7


  purge_protection_enabled = false


  public_network_access_enabled = true

  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.default.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "List",
    "Update",
    "Purge",
    "Recover",
    "Decrypt",
    "Encrypt",
    "Sign",
    "Verify",
    "WrapKey",
    "UnwrapKey",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover"
  ]
}

resource "azurerm_key_vault_key" "key" {
  name         = "mykey"
  key_vault_id = azurerm_key_vault.default.id

  key_type = "RSA"
  key_size = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]



  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}

resource "random_password" "password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "haslo123"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.default.id



  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}