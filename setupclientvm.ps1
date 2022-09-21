md -Path $env:temp\firefoxinstall -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\firefoxinstall firefox_installer.exe
Invoke-WebRequest 'https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US' -OutFile $Download
Invoke-Expression "$Download /S"




Invoke-WebRequest -Uri https://download.visualstudio.microsoft.com/download/pr/6deb2f82-9fe4-4453-a30a-ef4b780ad3d6/9f90355e0576949a5d605aae01376f65/dotnet-hosting-3.1.28-win.exe -OutFile dotnet-hosting-3.0.1-win.exe
Start-Process -FilePath ./dotnet-hosting-3.0.1-win.exe -Wait -ArgumentList /passive
net stop was /y
net start w3svc


$license=$args[0]
New-Item -Path "C:\JL Media" -ItemType Directory
New-Item "C:\JL Media\License.txt"
Set-Content "C:\JL Media\License.txt" $license