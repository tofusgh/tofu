#restart a webapp using azure automation 
stop-azwebapp -resourcegroup 'az-dev-rg-01' -name  'kamyasapp'
start-azwebapp -resourcegroup 'az-dev-rg-01' -name 'kamyasapp'

