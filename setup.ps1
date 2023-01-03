$citadelo_path = "C:\Program Files\citadelo"
$toolset_url = "https://github.com/citadelo/win-toolset/archive/refs/heads/main.zip"
$burp_url = "https://github.com/citadelo/win-toolset/releases/download/v0.1/burpsuite_pro.exe"
$toolset_path = "$citadelo_path\win-toolset-main"
$ErrorActionPreference = "Stop"
if (!(Test-Path $citadelo_path)) {
    echo "Setting up citadelo dir..."
    mkdir $citadelo_path | Out-Null
}
echo "Asking for domain credentials"
$cred = Get-Credential -UserName "domain\user" -Message "Enter your VDI credentials to continue in the format domain\user"
cd $citadelo_path
echo "Downloading tools and extracting..."
Start-Process powershell.exe -Wait -Credential $cred -ArgumentList '-Command "& {Start-BitsTransfer -Source https://github.com/citadelo/win-toolset/archive/refs/heads/main.zip -Destination C:\Temp\main.zip}"'
Expand-Archive C:\Temp\main.zip -DestinationPath .\ -Force
cd $toolset_path\tools
Start-Process powershell.exe -Wait -Credential $cred -ArgumentList '-Command "& {Start-BitsTransfer -Source https://github.com/citadelo/win-toolset/releases/download/v0.1/burpsuite_pro.exe -Destination C:\Temp\burpsuite_pro.exe}"'
mv C:\Temp\burpsuite_pro.exe .\
echo "Installing Sysinternals tools..."
Expand-Archive .\SysinternalsSuite.zip -DestinationPath .\SysinternalsSuite -Force
echo "Installing nmap..."
Expand-Archive .\nmap.zip -DestinationPath .\ -Force
mv nmap-* nmap
echo "Installing wireshark..."
Start-Process .\wireshark-setup.exe -ArgumentList "/S /D=$toolset_path\tools\wireshark" -NoNewWindow -Wait
echo "Installing npcap..."
echo "Npcap needs to be installed via GUI!"
Start-Process .\npcap.exe -NoNewWindow -Wait
echo "BurpSuite needs to be installed via GUI!"
echo "Starting BurpSuite installer..."
Start-Process .\burpsuite_pro.exe -NoNewWindow -Wait
if (!(Test-Path C:\Users\support\AppData\Roaming\BurpSuite)) {
    $burp_path = "C:\Users\support\AppData\Roaming\BurpSuite"
    mkdir $burp_path | Out-Null
}
cd $toolset_path\config
cp .\UserConfigPro.json $burp_path\ -Force
cp .\bapps\ $burp_path\ -Recurse -Force
echo "BurpSuite installed!"
# TODO: there are problems with WSL right now, can't download distribution
#echo "Installing WSL2..."
#Start-Process wsl.exe -ArgumentList "--install -d kali-linux" -NoNewWindow -Wait
#echo "WSL2 installed, reboot may be needed!"
cd $toolset_path/bin
# TODO: there are problems with nuclei, it's flagged by AV
#echo "Installing nuclei templates..."
#Start-Process .\nuclei.exe -Credential $cred -ArgumentList "-ut -silent" -NoNewWindow -Wait
if(!(select-string -pattern "citadelo" -InputObject $Env:PATH)) {
    echo "Setting up PATH..."
    $Env:PATH > "C:\Users\Public\Env_Path.bak"
    $Env:PATH += ";$toolset_path\bin"
    $Env:PATH += ";$toolset_path\tools\nmap"
    $Env:PATH += ";$toolset_path\tools\SysinternalsSuite"
    $Env:PATH += ";$toolset_path\tools\wireshark"
    [Environment]::SetEnvironmentVariable("PATH", $Env:PATH, [EnvironmentVariableTarget]::Machine)
}
echo "Doing clean up..."
rm $toolset_path\tools\*.zip
rm $toolset_path\tools\*.exe
rm $citadelo_path\*.zip
icacls $citadelo_path /inheritancelevel:e /q /c /t /grant Users:F
echo "All done!"
