$WebResponse = Invoke-WebRequest https://raw.githubusercontent.com/datacuber/Powershell_Intune/master/startlayout.bin -UseBasicParsing
$path = "C:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
$WebResponse.Content | Out-File -Force -filepath C:\temp\startlayout.bin 
Import-StartLayout -layoutpath C:\temp\startlayout.bin -mountpath C:\
