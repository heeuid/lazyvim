@echo off

:: Setting for Windows

:: required
if exist "%LOCALAPPDATA%\nvim.bak" (
    rmdir /s /q "%LOCALAPPDATA%\nvim.bak"
)
if exist "%LOCALAPPDATA%\nvim" (
    move "%LOCALAPPDATA%\nvim" "%LOCALAPPDATA%\nvim.bak"
) else (
    mkdir "%LOCALAPPDATA%\nvim.bak"
)

:: optional but recommended
if exist "%LOCALAPPDATA%\nvim-data.bak" (
    rmdir /s /q "%LOCALAPPDATA%\nvim-data.bak"
)
if exist "%LOCALAPPDATA%\nvim-data" (
    move "%LOCALAPPDATA%\nvim-data" "%LOCALAPPDATA%\nvim-data.bak"
) else (
    mkdir "%LOCALAPPDATA%\nvim-data.bak"
)

:: Clone the starter
git clone https://github.com/LazyVim/starter "%LOCALAPPDATA%\nvim"

:: Remove the .git folder, so you can add it to your own repo later
if exist "%LOCALAPPDATA%\nvim\.git" (
    rmdir /s /q "%LOCALAPPDATA%\nvim\.git"
)
if exist "%LOCALAPPDATA%\nvim\.gitignore" (
    del /q "%LOCALAPPDATA%\nvim\.gitignore"
)
if exist "%LOCALAPPDATA%\nvim\lua\example.lua" (
    del /q "%LOCALAPPDATA%\nvim\lua\example.lua"
)

:: Copy my lazyvim settings
xcopy /e /i /y lua "%LOCALAPPDATA%\nvim\lua"

:: Start Neovim!
nvim
