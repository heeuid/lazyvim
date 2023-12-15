# Setting for Windows

##### required
`Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak`

##### optional but recommended
`Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak`

##### Clone the starter
`git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim`

##### Remove the .git folder, so you can add it to your own repo later
`Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force`  
`Remove-Item $env:LOCALAPPDATA\nvim\.gitignore -Recurse -Force`

##### Copy my lazyvim settings
`Copy-Item lua $env:LOCALAPPDATA\nvim -Recurse -Force`

##### Start Neovim!
`nvim`
