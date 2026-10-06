Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

# Spicetify Auto Updater

This repository contains a PowerShell script named `spicetifyupd.ps1` that automates the process of updating Spicetify and handles failures safely.

## What the script does

The script performs the following steps:

1. Runs `spicetify upgrade --no-restart`.
2. Captures the command output and exit code.
3. If the update command fails, it tries to restore the previous Spicetify state using `spicetify restore backup apply`.
4. If the command reports that Spicetify is already up to date, it exits successfully without showing a success message.
5. Otherwise, it prints a success message and waits for a key press before exiting.

## Script behavior

```powershell
# Run Spicetify update and capture its output
$output = & spicetify upgrade --no-restart 2>&1 | Out-String
$exitCode = $LASTEXITCODE
```

This launches the Spicetify upgrade command and stores both the console output and the exit code. The `2>&1` part ensures error output is captured too.

### Failure handling

```powershell
if ($exitCode -ne 0) {
    & spicetify restore backup apply | Out-Null

    Write-Host ""
    Write-Host "Error installing spicetify update, try updating manually"
    Write-Host ""
    Read-Host "Press Enter to continue"
    exit 1
}
```

If the update fails, the script immediately restores the backup and informs the user that the update could not be installed. It then pauses so the message can be read before exiting with a non-zero status.

### Up-to-date check

```powershell
if ($output.Contains("up-to-date")) {
    exit 0
}
```

If the command output indicates that Spicetify is already current, the script exits without any further action.

### Successful update

```powershell
Write-Host ""
Write-Host "Update installed successfully, press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0
```

When the update succeeds, the script displays a confirmation message and waits for a key press before closing.

## Requirements

- PowerShell
- Spicetify installed and available in `PATH`
- A working Spicetify backup/restore setup

## Notes

This script is designed to be a simple safety net for updating Spicetify. It protects the user from a failed upgrade by attempting to restore the backup automatically, which is useful if a package update breaks the current configuration.

## Example usage

```powershell
./spicetifyupd.ps1
```

Run the script from a PowerShell session or via a shortcut/task scheduler if you want automatic updates.

## Installation guide

### The files are plug&play, so just press `Win+R` and insert shell:startup

Create a new shortcut 

```powershell
powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File "C:\Users\Jonas\Documents\spicetify.ps1"
```

And then finally name the shortcut!

### Done!


