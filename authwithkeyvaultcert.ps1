#This is a sample script that downloads a Key Vault Certificate locally to use for authentication with a service principal to Azure

Connect-AzAccount

$keyVaultName = "KeyVaultName"
$certificateName = "samplecert"
$pfxPassword = "InsertSecurePassword"
$exportPath = ".\Scripts\KeyVault"

#downloads certificate to local store
$kvSecret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $certificateName
$kvSecretBytes = [System.Convert]::FromBase64String($kvSecret.SecretValueText)
$certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$certCollection.Import($kvSecretBytes,$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$protectedCertificateBytes = $certCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $pfxPassword)
$pfxPath = $exportPath.TrimEnd("\") + "\$($certificateName).pfx"
[System.IO.File]::WriteAllBytes($pfxPath, $protectedCertificateBytes)

#once downloading the cert to your local store you can script getting the thumbprint or simply insert it below
$certthumb = "Insertcertthumbprint"
$tenantid = "TenantID"
$appid = "AppIDforSP"  

#authenticating with appid, tenantid, and cert.thumbprint
Connect-AzAccount -ApplicationId $appId -Tenant $tenantId -CertificateThumbprint $certthumb
