# NexusXElite Hardware Detection Module
# Detects and analyzes system hardware components

function Get-SystemHardware {
    <#
    .SYNOPSIS
        Detects system hardware information
    .DESCRIPTION
        Gathers comprehensive hardware details including CPU, RAM, GPU, storage, etc.
    .OUTPUTS
        PSCustomObject with hardware information
    #>
    
    Write-Host "Detecting Hardware..." -ForegroundColor Blue
    
    try {
        # CPU Information
        $cpu = Get-WmiObject Win32_Processor | Select-Object -First 1
        $cpuInfo = @{
            Name = $cpu.Name
            Cores = $cpu.NumberOfCores
            LogicalProcessors = $cpu.NumberOfLogicalProcessors
            MaxClockSpeed = $cpu.MaxClockSpeed
        }
        
        # Memory Information
        $memory = Get-WmiObject Win32_PhysicalMemory | Measure-Object Capacity -Sum
        $memoryInfo = @{
            TotalGB = [math]::Round($memory.Sum / 1GB, 2)
            Slots = (Get-WmiObject Win32_PhysicalMemory).Count
        }
        
        # GPU Information
        $gpu = Get-WmiObject Win32_VideoController | Select-Object -First 1
        $gpuInfo = @{
            Name = $gpu.Name
            DriverVersion = $gpu.DriverVersion
            VideoProcessor = $gpu.VideoProcessor
        }
        
        # Storage Information
        $storage = Get-WmiObject Win32_DiskDrive | ForEach-Object {
            @{
                Model = $_.Model
                SizeGB = [math]::Round($_.Size / 1GB, 2)
                InterfaceType = $_.InterfaceType
            }
        }
        
        # Network Information
        $network = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true } | Select-Object -First 1
        $networkInfo = @{
            Name = $network.Name
            Speed = $network.Speed
        }
        
        # Create hardware object
        $hardware = [PSCustomObject]@{
            CPU = $cpuInfo
            Memory = $memoryInfo
            GPU = $gpuInfo
            Storage = $storage
            Network = $networkInfo
            Timestamp = Get-Date
        }
        
        Write-Host "Hardware detection complete." -ForegroundColor Green
        return $hardware
        
    } catch {
        Write-Host "Hardware detection failed: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Export functions
Export-ModuleMember -Function Get-SystemHardware