$citadelo_path = "C:\Program Files\citadelo"
$toolset_url = "https://github.com/citadelo/win-toolset/archive/refs/heads/main.zip"
$burp_url = "https://github.com/citadelo/win-toolset/releases/download/v0.1/burpsuite_pro.exe"
if (!(Test-Path $citadelo_path)) {
    echo "Setting up citadelo dir..."
    mkdir $citadelo_path | Out-Null
}
cd $citadelo_path
echo "Downloading tools..."
wget $toolset_url -outfile .\main.zip
echo "Extracting archives..."
Expand-Archive .\main.zip -DestinationPath .\ -Force
rm main.zip
cd win-toolset-main\tools
Expand-Archive .\SysinternalsSuite.zip -DestinationPath .\SysinternalsSuite -Force
Expand-Archive .\nmap-win32.zip -DestinationPath .\ -Force
rm .\nmap-win32.zip
rm .\SysinternalsSuite.zip
mv nmap-* nmap
wget $burp_url -outfile .\burpsuite_pro.exe
echo "BurpSuite needs to be installed manually"
echo "Set the installation path to " + $citadelo_path + "\BurpSuitePro"
echo "Starting BurpSuite installer..."
Start-Process .\burpsuite_pro.exe -NoNewWindow -Wait
if(!(select-string -pattern "citadelo" -InputObject $Env:PATH)) {
    echo "Setting up PATH..."
    $Env:PATH > "C:\Users\Public\Env_Path.bak"
    $Env:PATH += ";C:\Program Files\citadelo\win-toolset-main\bin"
    $Env:PATH += ";C:\Program Files\citadelo\win-toolset-main\tools\nmap"
    $Env:PATH += ";C:\Program Files\citadelo\win-toolset-main\tools\SysinternalsSuite"
    [Environment]::SetEnvironmentVariable("PATH", $Env:PATH, [EnvironmentVariableTarget]::Machine)
}
icacls $citadelo_path /inheritancelevel:e /q /c /t /grant Users:F
echo "All done!"
