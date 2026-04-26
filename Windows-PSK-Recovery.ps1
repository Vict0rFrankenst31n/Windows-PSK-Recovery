$profiles = netsh wlan show profiles | Select-String ":\s*(.+?)\s*$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }

$results = foreach ($name in $profiles) {  
    $password = (netsh wlan show profile name="$name" key=clear |  
                 Select-String "Key Content\W+:\s*(.+?)\s*$" |  
                 ForEach-Object { $_.Matches.Groups[1].Value.Trim() })

&nbsp;   [PSCustomObject]@{  
        PROFILE_NAME = $name  
        PASSWORD = if ($password) { $password } else { "No password (Open network)" }  
    }  
}

$results | Format-Table -AutoSize

# Comment out above and uncomment below for Text File
# $results | Format-Table -AutoSize | Out-File "$env:USERPROFILE\Desktop\WiFi_Passwords.txt"
# Write-Host "Passwords saved to Desktop\WiFi_Passwords.txt" -ForegroundColor Green

# Comment out above and uncomment below for CSV
#$results | Export-Csv -Path "$env:USERPROFILE\Desktop\WiFi_Passwords.csv" -NoTypeInformation
