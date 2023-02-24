param keyVaultName string 
param keyName string 
param storageName string 
param keyUri string 
param keyversion string 



// Create a key vault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

// Create a key in the key vault
resource key 'Microsoft.KeyVault/vaults/keys@2021-06-01-preview' existing = {
  name: keyName
}

resource storage_Accounts 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageName
}

resource storageencryption 'Microsoft.Storage/storageAccounts/encryptionScopes@2020-08-01-preview' = {
  name: 'storageaccount-keyvault-encryption'
  parent: storage_Accounts
  properties: {
    keyVaultProperties: {
      keyUri: keyUri
      keyname: keyName
      keyversion: keyversion
    }
    source: 'Microsoft.KeyVault'
    state: 'Enabled'
  }
  dependsOn: [
    key
    keyVault
  ]
}

