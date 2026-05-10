# NexusXElite Bootstrap Script
# Loads all modules and initializes the application

param(
    [string]$TempPath
)

# Set execution policy for the session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Define paths
if ($TempPath) {
    $scriptRoot = $TempPath
} else {
    if ($MyInvocation.MyCommand.Path) {
        $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    } else {
        # Fallback for downloaded scripts
        $scriptRoot = [System.IO.Path]::GetTempPath()
    }
}
$modulesPath = Join-Path $scriptRoot "Modules"
$uiPath = Join-Path $scriptRoot "UI"
$configsPath = Join-Path $scriptRoot "Configs"
$logsPath = Join-Path $scriptRoot "Logs"

# Create necessary directories if they don't exist
if (!(Test-Path $configsPath)) { New-Item -ItemType Directory -Path $configsPath -Force }
if (!(Test-Path $logsPath)) { New-Item -ItemType Directory -Path $logsPath -Force }

# Function to load modules
function Load-NexusModules {
    param([string]$modulesPath)
    
    Write-Host "Loading NexusXElite Modules..." -ForegroundColor Yellow
    
    $modules = @(
        "HardwareDetection.ps1",
        "DeepOptimize.ps1", 
        "GamingOptimize.ps1",
        "NetworkOptimize.ps1"
    )
    
    foreach ($module in $modules) {
        $modulePath = Join-Path $modulesPath $module
        if (Test-Path $modulePath) {
            try {
                Write-Host "Loading $module..." -ForegroundColor Gray
                . $modulePath
            } catch {
                Write-Host "Failed to load $module : $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "Module $module not found at $modulePath" -ForegroundColor Red
        }
    }
}

# Function to start UI
function Start-NexusUI {
    param([string]$uiPath)
    
    $launcherPath = Join-Path $uiPath "Launcher.ps1"
    if (Test-Path $launcherPath) {
        Write-Host "Starting NexusXElite UI..." -ForegroundColor Green
        & $launcherPath
    } else {
        Write-Host "Launcher not found at $launcherPath" -ForegroundColor Red
    }
}

# Main bootstrap function
function Invoke-Bootstrap {
    Write-Host "NexusXElite Bootstrap Starting..." -ForegroundColor Cyan
    
    # Load modules
    Load-NexusModules -modulesPath $modulesPath
    
    # Start UI
    Start-NexusUI -uiPath $uiPath
    
    Write-Host "NexusXElite Bootstrap Complete." -ForegroundColor Green
}

# Run bootstrap
Invoke-Bootstrap