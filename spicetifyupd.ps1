# Spicetify Update Script

# Run Spicetify update and capture its output
$output = & spicetify upgrade --no-restart 2>&1 | Out-String
$exitCode = $LASTEXITCODE

# If Spicetify failed
if ($exitCode -ne 0) {

    # Try to restore the previous state
    & spicetify restore backup apply | Out-Null

    Write-Host ""
    Write-Host "Error installing spicetify update, try updating manually"
    Write-Host ""
    Read-Host "Press Enter to continue"
    exit 1
}

# Check whether an actual update was performed
# If there was no update, close immediately
if ($output.Contains("up-to-date")) {
    exit 0
}

# Update was successfully installed
Write-Host ""
Write-Host "Update installed successfully, press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0
```
