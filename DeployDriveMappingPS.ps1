# Edit the URL to your blob storage path
$PSurl= "https://drive06.blob.core.windows.net/cont01/MapDrives.ps1"

# Don't change anything below this line

# Location where we will add the script to run on logon
$regKeyLocation="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

# Command for the registry
$psCommand= "PowerShell.exe -ExecutionPolicy Bypass -Windowstyle hidden -command $([char]34)& {(Invoke-RestMethod '$PSurl').Replace('�','').Replace('�','').Replace('�','') | Invoke-Expression}$([char]34)"


# Check if the registry location exist, if not create it.
if (-not(Test-Path -Path $regKeyLocation)){

    New-ItemProperty -Path $regKeyLocation -Force

}

# Create / Update the registry to reflect the powershell command.
Set-ItemProperty -Path $regKeyLocation -Name "PowerShellDriveMapping" -Value $psCommand -Force

# Deploy PowerShell script inmidiatly
Invoke-Expression $psCommand