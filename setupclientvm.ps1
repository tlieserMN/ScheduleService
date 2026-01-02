if (-Not (Test-Path -Path "C:\Temp")) {
    Write-Host "Creating C:\Temp"
    New-Item -Path "C:\Temp" -ItemType Directory | Out-Null
}

# if self contained app, don't need .net installed
#Write-Host "Installing .NET 8 Hosting Bundle..."
#$dotnetHostingUrl = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/dotnet-hosting-8.0.22-win.exe"
#$dotnetPath = "C:\Temp\dotnet-hosting.exe"
#Invoke-WebRequest -Uri $dotnetHostingUrl -OutFile $dotnetPath
#Start-Process -FilePath $dotnetPath -ArgumentList "/quiet", "/norestart" -Wait

# Verify installation
#Write-Host ".NET Hosting Bundle installed"


Write-Host "Installing Firefox..."
$firefoxInstaller = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
$firefoxPath = "C:\Temp\firefox.exe"
Invoke-WebRequest -Uri $firefoxInstaller -OutFile $firefoxPath
Start-Process $firefoxPath -ArgumentList "/S" -Wait


$PAT=$args[0]
$ErrorActionPreference="Stop";If(-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() ).IsInRole( [Security.Principal.WindowsBuiltInRole] "Administrator")){ throw "Run command in an administrator PowerShell prompt"};If($PSVersionTable.PSVersion -lt (New-Object System.Version("3.0"))){ throw "The minimum version of Windows PowerShell that is required by the script (3.0) does not match the currently running version of Windows PowerShell." };If(-NOT (Test-Path $env:SystemDrive\'azagent')){mkdir $env:SystemDrive\'azagent'}; cd $env:SystemDrive\'azagent'; for($i=1; $i -lt 100; $i++){$destFolder="A"+$i.ToString();if(-NOT (Test-Path ($destFolder))){mkdir $destFolder;cd $destFolder;break;}}; $agentZip="$PWD\agent.zip";$DefaultProxy=[System.Net.WebRequest]::DefaultWebProxy;$securityProtocol=@();$securityProtocol+=[Net.ServicePointManager]::SecurityProtocol;$securityProtocol+=[Net.SecurityProtocolType]::Tls12;[Net.ServicePointManager]::SecurityProtocol=$securityProtocol;$WebClient=New-Object Net.WebClient; $Uri='https://download.agent.dev.azure.com/agent/4.266.2/vsts-agent-win-x64-4.266.2.zip';if($DefaultProxy -and (-not $DefaultProxy.IsBypassed($Uri))){$WebClient.Proxy= New-Object Net.WebProxy($DefaultProxy.GetProxy($Uri).OriginalString, $True);}; $WebClient.DownloadFile($Uri, $agentZip);Add-Type -AssemblyName System.IO.Compression.FileSystem;[System.IO.Compression.ZipFile]::ExtractToDirectory( $agentZip, "$PWD");.\config.cmd --environment --environmentname "Production" --agent $env:COMPUTERNAME --unattended --acceptteeeula --runasservice --work '_work' --url 'https://dev.azure.com/tliesermn/' --projectname 'ScheduleService' --auth PAT --token $PAT; Remove-Item $agentZip;
