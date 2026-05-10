# NexusXElite Network Optimization Module
# Optimizes network settings for better performance

function Invoke-NetworkOptimization {
    <#
    .SYNOPSIS
        Optimizes network settings
    .DESCRIPTION
        Applies network optimizations including TCP tweaks, DNS settings, etc.
    .PARAMETER CreateRestorePoint
        Whether to create a system restore point before optimization
    #>
    
    param(
        [bool]$CreateRestorePoint = $true
    )
    
    Write-Host "Starting Network Optimization..." -ForegroundColor Blue
    
    try {
        # Create restore point if requested
        if ($CreateRestorePoint) {
            Write-Host "Creating System Restore Point..." -ForegroundColor Cyan
            Checkpoint-Computer -Description "NexusXElite Network Optimization" -RestorePointType "MODIFY_SETTINGS"
        }
        
        # Set DNS to Google DNS
        Write-Host "Setting DNS to Google Public DNS..." -ForegroundColor Gray
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
        foreach ($adapter in $adapters) {
            Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ("8.8.8.8", "8.8.4.4")
        }
        
        # Optimize TCP settings
        Write-Host "Optimizing TCP Settings..." -ForegroundColor Gray
        
        # Set TCP congestion provider to CUBIC
        netsh int tcp set global congestionprovider=cubic
        
        # Enable ECN
        netsh int tcp set global ecncapability=enabled
        
        # Set receive window auto-tuning
        netsh int tcp set global autotuninglevel=normal
        
        # Optimize for broadband
        netsh int tcp set global chimney=enabled
        netsh int tcp set global rss=enabled
        
        # Flush DNS cache
        Write-Host "Flushing DNS Cache..." -ForegroundColor Gray
        Clear-DnsClientCache
        
        # Reset network stack
        Write-Host "Resetting Network Stack..." -ForegroundColor Gray
        netsh int ip reset
        netsh winsock reset
        
        Write-Host "Network Optimization Complete. Please restart your computer." -ForegroundColor Green
        
    } catch {
        Write-Host "Network Optimization failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Export functions
Export-ModuleMember -Function Invoke-NetworkOptimization