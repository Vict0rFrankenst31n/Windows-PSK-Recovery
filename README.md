# Windows Wi-Fi Password (PSK) Recovery Script

A simple and fast PowerShell script that displays **all saved Wi-Fi network names and their passwords** stored on a Windows machine.

Useful for:
- Recovering forgotten Wi-Fi passwords
- Migrating to a new PC
- Auditing saved wireless networks
- Troubleshooting network issues

---

## ⚠️ Important Notes

- **Requires Administrator privileges** (Run PowerShell as Administrator)
- Only works on **Windows 10 / Windows 11**
- Shows passwords for all Wi-Fi profiles that Windows has saved
- Open networks (no password) will be clearly marked

---

## Usage

1. Open **PowerShell as Administrator**
2. Paste the following script and press Enter:

```powershell
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
```
## Expected Output Example

```
PROFILE_NAME                  PASSWORD
------------                  --------
HomeWiFi                      MySecretPass123
Office-Guest                  No password (Open network)
Starbucks-Free                No password (Open network)
Neighbor-5G                   Summer2025!
```

## Export to TXT

```powershell
$results | Format-Table -AutoSize | Out-File "$env:USERPROFILE\Desktop\WiFi_Passwords.txt"
Write-Host "Passwords saved to Desktop\WiFi_Passwords.txt" -ForegroundColor Green
```

## Export to CSV 

```powershell
$results | Export-Csv -Path "$env:USERPROFILE\Desktop\WiFi_Passwords.csv" -NoTypeInformation
```
## Disclaimer

This tool is for educational and personal recovery purposes only.
Use responsibly and only on devices you own or have explicit permission to access.
