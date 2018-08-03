If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?Linkid=852157" -OutFile "C:\Temp\VSCodeSetup-x64-1.25.1.exe"
$installerArguments = "/silent /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"
Start-Process  -FilePath 'C:\Users\%Username%\Downloads\VSCodeSetup-x64-1.25.1.exe' -ArgumentList $installerArguments -Wait
