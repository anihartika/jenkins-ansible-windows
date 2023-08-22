#####check chrome#########
$chromeInstalled = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | 
                   Where-Object { $_.DisplayName -eq 'Google Chrome' -and $_.DisplayVersion -ne $null }

if ($chromeInstalled) {
    Write-Host 'Google Chrome is installed.'
} else {
    Write-Host 'Google Chrome is not installed.'
}
###check httpd#########
$serviceName = 'httpd'

# Check if the Apache service is running
$service = Get-Service -Name $serviceName

if ($service -ne $null) {
    if ($service.Status -eq 'Running') {
        Write-Host "Apache ($serviceName) is running."
    } else {
        Write-Host "Apache ($serviceName) is installed but not running."
    }
} else {
    Write-Host "Apache ($serviceName) is not installed."
}
#Check Notepad++ Installation
# Define the path where Notepad++ is typically installed (adjust as needed)
$notepadPlusPlusPath = 'C:\Notepad++'

# Check if Notepad++ executable exists in the installation directory
$notepadPlusPlusExe = Join-Path -Path $notepadPlusPlusPath -ChildPath 'notepad++.exe'

if (Test-Path $notepadPlusPlusExe -PathType Leaf) {
    Write-Host 'Notepad++ is installed.'
} else {
    Write-Host 'Notepad++ is not installed.'
}
