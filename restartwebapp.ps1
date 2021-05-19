#restart a webapp using azure automation 
Connect-AzAccount -Identity
stop-azwebapp -resourcegroup 'az-dev-rg-01' -name  'kamyasapp'
start-azwebapp -resourcegroup 'az-dev-rg-01' -name 'kamyasapp'

