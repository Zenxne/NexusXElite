# NexusXElite - Windows Optimization Tool
# Main runner script that downloads and executes the bootstrap

param()

# Function to download and execute Bootstrap.ps1
function Invoke-NexusXElite {
    try {
        Write-Host "Downloading NexusXElite Bootstrap..." -ForegroundColor Cyan
        
        # Create temp directory for scripts
        if (-not $env:TEMP) {
            $env:TEMP = [System.IO.Path]::GetTempPath()
        }
        $tempDir = Join-Path $env:TEMP "NexusXElite"
        if (!(Test-Path $tempDir)) {
            New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        }
        
        # Download Bootstrap.ps1
        $bootstrapUrl = "https://raw.githubusercontent.com/Zenxne/NexusXElite/main/Core/Bootstrap.ps1"
        $bootstrapPath = Join-Path $tempDir "Bootstrap.ps1"
        Invoke-WebRequest -Uri $bootstrapUrl -OutFile $bootstrapPath -UseBasicParsing
        
        # Download all modules
        $modules = @("HardwareDetection.ps1", "DeepOptimize.ps1", "GamingOptimize.ps1", "NetworkOptimize.ps1")
        $modulesDir = Join-Path $tempDir "Modules"
        if (!(Test-Path $modulesDir)) {
            New-Item -ItemType Directory -Path $modulesDir -Force | Out-Null
        }
        foreach ($module in $modules) {
            $moduleUrl = "https://raw.githubusercontent.com/Zenxne/NexusXElite/main/Modules/$module"
            $modulePath = Join-Path $modulesDir $module
            Invoke-WebRequest -Uri $moduleUrl -OutFile $modulePath -UseBasicParsing
        }
        
        # Download UI
        $uiDir = Join-Path $tempDir "UI"
        if (!(Test-Path $uiDir)) {
            New-Item -ItemType Directory -Path $uiDir -Force | Out-Null
        }
        $uiUrl = "https://raw.githubusercontent.com/Zenxne/NexusXElite/main/UI/Launcher.ps1"
        $uiPath = Join-Path $uiDir "Launcher.ps1"
        Invoke-WebRequest -Uri $uiUrl -OutFile $uiPath -UseBasicParsing
        
        # Execute the bootstrap script with temp path
        Write-Host "Executing Bootstrap..." -ForegroundColor Green
        & $bootstrapPath -TempPath $tempDir
        
    } catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Run the main function
Invoke-NexusXElite