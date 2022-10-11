# win-toolset
Windows box toolset installation script

## How to run:

Currently Zscaler blocks downloading of setup script, so it needs to be copied from Github, pasted into Notepad and stored locally.

- copy setup.ps1 script from https://github.com/citadelo/win-toolset/blob/main/setup.ps1
- paste into Notepad and save onto disk
- open PowerShell as admin (support user)
- run script via `.\setup.ps1` with admin privileges

## Current list of installed tools:
- ffuf (1.5.0)
- sslscan (2.0.15)
- nmap (7.92)
- SysinternalsSuite (Aug 16 2022)
- BurpSuite Professional (2022.8.4)
- Wireshark (3.6.8)
- npcap (1.71)
- WSL 2
- nuclei (2.7.8)

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