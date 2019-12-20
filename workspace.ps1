(az webapp show -g chacra-t-rg01 -n chacra-t-afunc-api --query '[possibleOutboundIpAddresses, outboundIpAddresses]' --output tsv) -join ',' -split ',' | ForEach-Object -Begin {$i = 1} {
    az webapp config access-restriction add -g chacra-t-rg01 -n chacra-t-afunc-ingest --rule-name "ip_$($_)" --action Allow --ip-address "$($_)/32" -p $i
}