$citadelo_path = "C:\Program Files\citadelo"
$toolset_path = "$citadelo_path\win-toolset-main"
$burp_path = "C:\Users\USR\AppData\Roaming\BurpSuite"
$ErrorActionPreference = "Stop"
echo "Asking for domain credentials"
$cred = Get-Credential -UserName "domain\user" -Message "Enter your VDI credentials to continue in the domain\user format"
if (!(Test-Path $citadelo_path)) {
    echo "Setting up citadelo dir..."
    mkdir $citadelo_path | Out-Null
}
cd $citadelo_path
echo "Downloading tools and extracting..."
Start-Process powershell.exe -Wait -Credential $cred -ArgumentList '-Command "& {Start-BitsTransfer -Source https://github.com/citadelo/win-toolset/archive/refs/heads/main.zip -Destination C:\Temp\main.zip}"'
Expand-Archive C:\Temp\main.zip -DestinationPath .\ -Force
cd $toolset_path\tools
Start-Process powershell.exe -Wait -Credential $cred -ArgumentList '-Command "& {Start-BitsTransfer -Source ''https://portswigger-cdn.net/burp/releases/download?product=pro&version=2022.12.5&type=WindowsX64'' -Destination C:\Temp\burpsuite_pro.exe}"'
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
$burp_support = $burp_path.replace("USR", "support")
$burp_regular = $burp_path.replace("USR", $cred.username.split("\")[1])
if (!(Test-Path $burp_support)) {
    mkdir $burp_support | Out-Null
}
if (!(Test-Path $burp_regular)) {
    mkdir $burp_regular | Out-Null
}
cd $toolset_path\config
cp .\UserConfigPro.json $burp_support\ -Force
cp .\bapps\ $burp_support\ -Recurse -Force
cp .\UserConfigPro.json $burp_regular\ -Force
cp .\bapps\ $burp_regular\ -Recurse -Force
echo "BurpSuite installed!"
# TODO: there are problems with WSL right now, can't download distribution
#echo "Installing WSL2..."
#Start-Process wsl.exe -ArgumentList "--install -d kali-linux" -NoNewWindow -Wait
#echo "WSL2 installed, reboot may be needed!"
cd $citadelo_path
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
