param keyVaultName string 
param keyName string 
param storageName string 
param keyUri string 


// Create a key vault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

// Create a key in the key vault
resource key 'Microsoft.KeyVault/vaults/keys@2021-06-01-preview' existing = {
  name: keyName
}



module updateStorageAccount 'module/storageaccount-keyvault-encryption.bicep' = {
  name: 'storageaccount-keyvault-encryption'
  params: {
    keyVaultName: keyVaultName
    storageName: storageName
    keyName: keyName
    keyUri: keyUri
    keyversion: last(split(key.properties.keyUriWithVersion, '/'))
  }
  dependsOn: [
    key
    keyVault
  ]
}
