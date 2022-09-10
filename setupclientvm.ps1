$LocalTempDir = $env:TEMP; 
$ChromeInstaller = "ChromeInstaller.exe"; 
(new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; 
$Process2Monitor =  "ChromeInstaller"; 

Do { 
	$ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; 
	If ($ProcessesFound) { 
		"Still running: $($ProcessesFound -join ', ')" | Write-Host; 
		Start-Sleep -Seconds 2 
	} else { 
		rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose 
	} 
} Until (!$ProcessesFound)




Invoke-WebRequest -Uri https://download.visualstudio.microsoft.com/download/pr/6deb2f82-9fe4-4453-a30a-ef4b780ad3d6/9f90355e0576949a5d605aae01376f65/dotnet-hosting-3.1.28-win.exe -OutFile dotnet-hosting-3.0.1-win.exe
Start-Process -FilePath ./dotnet-hosting-3.0.1-win.exe -Wait -ArgumentList /passive
net stop was /y
net start w3svc


$license=$args[0]
New-Item -Path "C:\JL Media" -ItemType Directory
New-Item "C:\JL Media\License.txt"
Set-Content "C:\JL Media\License.txt" $license