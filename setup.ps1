$citadelo_path = "C:\Program Files\citadelo"
$toolset_url = "https://github.com/citadelo/win-toolset/archive/refs/heads/main.zip"
$burp_url = "https://github.com/citadelo/win-toolset/releases/download/v0.1/burpsuite_pro.exe"
$toolset_path = "$citadelo_path\win-toolset-main"
if (!(Test-Path $citadelo_path)) {
    echo "Setting up citadelo dir..."
    mkdir $citadelo_path | Out-Null
}
cd $citadelo_path
echo "Downloading tools and extracting..."
wget $toolset_url -outfile .\main.zip
Expand-Archive .\main.zip -DestinationPath .\ -Force
cd $toolset_path\tools
wget $burp_url -outfile .\burpsuite_pro.exe
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
echo "Set the installation path to $citadelo_path\BurpSuitePro"
echo "Starting BurpSuite installer..."
Start-Process .\burpsuite_pro.exe -NoNewWindow -Wait
echo "BurpSuite installed!"
echo "You can find many extensions in $toolset_path\tool\burp_extensions"
echo "Jython can be found in $toolset_path\bin"
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
rm $toolset_url\tools\*.zip
rm $toolset_url\tools\*.exe
rm $citadelo_path\*.zip
icacls $citadelo_path /inheritancelevel:e /q /c /t /grant Users:F
echo "All done!"
