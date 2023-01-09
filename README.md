# win-toolset
Windows box toolset installation script

## How to run:

1. Copy content of setup.ps1 from this repo and store it somewhere on disk
2. Open PowerShell with Administrator rights (support) and run the stored script as `.\setup.ps1`
3. Enter your VDI credentials in the `domain\user` format when script asks (don't forget the domain part!)
4. Some programs needs to be installed via GUI, just click it through

## Current list of installed tools:
- ffuf (1.5.0)
- sslscan (2.0.15)
- nmap (7.92)
- SysinternalsSuite (Aug 16 2022)
- BurpSuite Professional (2022.12.5)
- Wireshark (3.6.8)
- npcap (1.71)

## Current list of Burp Suite extensions:
- 403 Bypasser
- Active Scan++
- Autorize
- Backslash Scanner
- Collaborator Everywhere
- Content Type Converter
- Freddy, Deserialization Bug Finder
- J2EE Scan
- JOSEPH
- JS Link Finder
- Param Miner
- Reflected Parameters
- RetireJS
- Turbo Intruder
- ViewState Editor
- HTTP Request Smuggler

## Current wordlists
- combined_directories.txt from SecLists
- combined_words.txt from SecLists