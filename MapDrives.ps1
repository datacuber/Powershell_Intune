# Create a log of all results everytime this script runs
Start-Transcript -Path "C:\AzureScriptLogs\DriveMapping.log"

# Fill in your local active directory domain name
$dnsDomainName= "qlab.local"

# Create a loop for all drive maps
$driveMappingConfig=@()

# Drive map 1, copy below 5 lines for additional drive letters
$driveMappingConfig+= [PSCUSTOMOBJECT]@{

    DriveLetter = "G"
    UNCPath= "\\LAB-SRV01\Share"
    Description="SMB01"
}


# Drive map 2, copy below 5 lines for additional drive letters
$driveMappingConfig+=  [PSCUSTOMOBJECT]@{

    DriveLetter = "DRIVELETTER"
    UNCPath= "\\YOURSERVERNAME\FOLDER"
    Description="DRIVENAME"
}





# Don't change anything below this line


$connected=$false
$retries=0
$maxRetries=3


Write-Output "Starting script..."

do {

    if (Resolve-DnsName $dnsDomainName -ErrorAction SilentlyContinue){

    $connected=$true

    } else{
    

        $retries++

        Write-Warning "Cannot resolve: $dnsDomainName, assuming no connection to fileserver"


        Start-Sleep -Seconds 3


        if ($retries -eq $maxRetries){

            Throw "Exceeded maximum numbers of retries ($maxRetries) to resolve dns name ($dnsDomainName)"

        }

    }


}while( -not ($Connected))



#Map drives

$driveMappingConfig.GetEnumerator() | ForEach-Object {

# Check if mapping has already been created
$DriveletterExists = Test-Path -Path "$($PSItem.DriveLetter):\"

# If not, map drive
If (-not ($DriveletterExists)) {
        Write-Output "Mapping network drive $($PSItem.UNCPath) to $($PSItem.DriveLetter)"

        New-PSDrive -PSProvider FileSystem -Name $PSItem.DriveLetter -Root $PSItem.UNCPath -Description $PSItem.Description -Persist -Scope global

        #To make the drive persistent there needs to be a registry key to be added to the drive.
        (New-Object -ComObject Shell.Application).NameSpace("$($PSItem.DriveLetter):").Self.Name=$PSItem.Description

        $registryPath = ("HKCU:\Network\" + $PSItem.DriveLetter)

        $Name = "ConnectionType"

        $value = "1"

        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

# If exists, skip and just log
} else { 
        Write-Output "Drive $($PSItem.DriveLetter) already exist, skipping creation"

}
}



Stop-Transcript