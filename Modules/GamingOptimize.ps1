# NexusXElite Gaming Optimization Module
# Optimizes system for gaming performance

function Invoke-GamingOptimization {
    <#
    .SYNOPSIS
        Optimizes system for gaming
    .DESCRIPTION
        Applies gaming-specific optimizations including priority settings, network tweaks, etc.
    .PARAMETER CreateRestorePoint
        Whether to create a system restore point before optimization
    #>
    
    param(
        [bool]$CreateRestorePoint = $true
    )
    
    Write-Host "Starting Gaming Optimization..." -ForegroundColor Magenta
    
    try {
        # Create restore point if requested
        if ($CreateRestorePoint) {
            Write-Host "Creating System Restore Point..." -ForegroundColor Cyan
            Checkpoint-Computer -Description "NexusXElite Gaming Optimization" -RestorePointType "MODIFY_SETTINGS"
        }
        
        # Set high performance power plan
        Write-Host "Setting High Performance Power Plan..." -ForegroundColor Gray
        $highPerf = powercfg -l | ForEach-Object { if($_.contains("High performance")) { $_.split()[3] } }
        if ($highPerf) {
            powercfg -setactive $highPerf
        }
        
        # Disable Windows Game Mode (let games handle it)
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0 -Type DWord
        
        # Optimize network for gaming
        Write-Host "Optimizing Network Settings..." -ForegroundColor Gray
        
        # Disable Nagle's algorithm
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -Value 1 -Type DWord
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -Value 1 -Type DWord
        
        # Set network throttling index
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord
        
        # Disable Windows Auto-Tuning
        netsh int tcp set global autotuninglevel=disabled
        
        # Optimize mouse settings
        Write-Host "Optimizing Mouse Settings..." -ForegroundColor Gray
        Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Value "8" -Type String
        
        # Disable visual effects that affect gaming
        Write-Host "Disabling Gaming-Interfering Visual Effects..." -ForegroundColor Gray
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -Type String
        
        Write-Host "Gaming Optimization Complete." -ForegroundColor Green
        
    } catch {
        Write-Host "Gaming Optimization failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Export functions
Export-ModuleMember -Function Invoke-GamingOptimization