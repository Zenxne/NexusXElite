# NexusXElite - Windows Optimization Tool
# Main runner script that downloads and executes the bootstrap

param()

# Function to download and execute Bootstrap.ps1
function Invoke-NexusXElite {
    try {
        Write-Host "Downloading NexusXElite Bootstrap..." -ForegroundColor Cyan
        
        # Download Bootstrap.ps1 from GitHub
        $bootstrapUrl = "https://raw.githubusercontent.com/Zenxne/NexusXElite/main/Core/Bootstrap.ps1"
        $bootstrapScript = Invoke-WebRequest -Uri $bootstrapUrl -UseBasicParsing
        
        # Execute the bootstrap script
        Write-Host "Executing Bootstrap..." -ForegroundColor Green
        Invoke-Expression $bootstrapScript.Content
        
    } catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Run the main function
Invoke-NexusXElite