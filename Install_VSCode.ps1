$installerArguments = "/silent /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"
Start-Process  -FilePath 'C:\Users\datacuber\Downloads\VSCodeSetup-x64-1.25.1.exe' -ArgumentList $installerArguments -Wait
