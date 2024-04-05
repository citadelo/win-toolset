$citadelo_path = "C:\Program Files\citadelo"
$toolset_path = "$citadelo_path\win-toolset-main"
$burp_path = "C:\Users\USR\AppData\Roaming\BurpSuite"
$ErrorActionPreference = "Stop"

echo "Asking for domain credentials"
$cred = Get-Credential -UserName "domain\user" -Message "Enter your VDI credentials to continue in the domain\user format."

if (!(Test-Path $citadelo_path)) {
    echo "Setting up citadelo dir..."
    mkdir $citadelo_path | Out-Null
}
cd $citadelo_path
echo "Downloading tools and extracting..."

$user=$cred.username.split("\")[1]
Start-Process 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -Credential $cred -ArgumentList 'https://portswigger-cdn.net/burp/releases/download?product=pro&version=2024.2.1.3&type=WindowsX64'
$downloaded = $false
do {
    $downloaded = (Test-Path "C:\Users\$user\Downloads\burpsuite_pro_windows*.exe")
    Start-Sleep -s 5
} while (!$downloaded)

Start-Process 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -Credential $cred -ArgumentList 'https://github.com/citadelo/win-toolset/archive/refs/heads/main.zip'
$downloaded = $false
do {
    $downloaded = (Test-Path "C:\Users\$user\Downloads\win-toolset-main.zip")
    Start-Sleep -s 5
} while (!$downloaded)

cp "C:\Users\$user\Downloads\burpsuite_pro_windows*.exe" .\burpsuite_pro.exe
Expand-Archive "C:\Users\$user\Downloads\win-toolset-main.zip" -DestinationPath .\ -Force

cd $toolset_path\tools
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
Start-Process "$citadelo_path.\burpsuite_pro.exe" -NoNewWindow -Wait
$burp_support = $burp_path.replace("USR", "support")
$burp_regular = $burp_path.replace("USR", $user)
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
cd $citadelo_path

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