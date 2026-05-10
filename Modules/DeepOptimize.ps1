# NexusXElite Deep Optimization Module
# Performs comprehensive system optimizations

function Invoke-DeepOptimization {
    <#
    .SYNOPSIS
        Performs deep system optimizations
    .DESCRIPTION
        Applies various optimizations including registry tweaks, service optimizations, etc.
    .PARAMETER CreateRestorePoint
        Whether to create a system restore point before optimization
    #>
    
    param(
        [bool]$CreateRestorePoint = $true
    )
    
    Write-Host "Starting Deep Optimization..." -ForegroundColor Yellow
    
    try {
        # Create restore point if requested
        if ($CreateRestorePoint) {
            Write-Host "Creating System Restore Point..." -ForegroundColor Cyan
            Checkpoint-Computer -Description "NexusXElite Deep Optimization" -RestorePointType "MODIFY_SETTINGS"
        }
        
        # Disable unnecessary services
        Write-Host "Optimizing Services..." -ForegroundColor Gray
        $servicesToDisable = @(
            "SysMain",  # Superfetch
            "WSearch",  # Windows Search
            "Spooler"   # Print Spooler (if no printer)
        )
        
        foreach ($service in $servicesToDisable) {
            if (Get-Service $service -ErrorAction SilentlyContinue) {
                Set-Service $service -StartupType Disabled
                Stop-Service $service -ErrorAction SilentlyContinue
            }
        }
        
        # Registry optimizations
        Write-Host "Applying Registry Optimizations..." -ForegroundColor Gray
        
        # Disable Windows Tips
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Value 0 -Type DWord
        
        # Disable Game DVR
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord
        
        # Optimize visual effects
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary
        
        # Clear temp files
        Write-Host "Cleaning Temporary Files..." -ForegroundColor Gray
        $tempPath = $env:TEMP
        if (-not $tempPath) {
            $tempPath = [System.IO.Path]::GetTempPath()
        }
        if ($tempPath) {
            Get-ChildItem -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        }
        
        Write-Host "Deep Optimization Complete." -ForegroundColor Green
        
    } catch {
        Write-Host "Deep Optimization failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Export functions
Export-ModuleMember -Function Invoke-DeepOptimization