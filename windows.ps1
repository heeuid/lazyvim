# Setting for Windows

##### required
if (Test-Path "$env:LOCALAPPDATA\nvim.bak") {
    Remove-Item "$env:LOCALAPPDATA\nvim.bak" -Recurse -Force
}
if (Test-Path "$env:LOCALAPPDATA\nvim") {
    Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak" -Force
}

##### optional but recommended
if (Test-Path "$env:LOCALAPPDATA\nvim-data.bak") {
    Remove-Item "$env:LOCALAPPDATA\nvim-data.bak" -Recurse -Force
}
if (Test-Path "$env:LOCALAPPDATA\nvim-data") {
    Move-Item "$env:LOCALAPPDATA\nvim-data" "$env:LOCALAPPDATA\nvim-data.bak" -Force
}

##### Clone the starter
git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim

##### Remove the .git folder, so you can add it to your own repo later
if (Test-Path "$env:LOCALAPPDATA\nvim\.git") {
    Remove-Item "$env:LOCALAPPDATA\nvim\.git" -Recurse -Force
}
if (Test-Path "$env:LOCALAPPDATA\nvim\.gitignore") {
    Remove-Item "$env:LOCALAPPDATA\nvim\.gitignore" -Force
}
if (Test-Path "$env:LOCALAPPDATA\nvim\lua\example.lua") {
    Remove-Item "$env:LOCALAPPDATA\nvim\lua\example.lua" -Force
}

##### Copy my lazyvim settings
Copy-Item lua "$env:LOCALAPPDATA\nvim" -Recurse -Force

##### Start Neovim!
nvim
