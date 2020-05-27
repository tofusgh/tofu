#This is a sample script that downloads a key vault certificate locally to use for authentication to Azure with a service principal

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

$certthumb = "insertcertthumbprint"
$tenantid = "tenantID"
$appid = "AppIdforSP"  

#authenticating with appid, tenantid, and cert.thumbprint
Connect-AzAccount -ApplicationId $appId -Tenant $tenantId -CertificateThumbprint $certthumb
