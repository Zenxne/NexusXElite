# NexusXElite Premium WPF Launcher
# Professional UI for Windows optimization

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

# XAML for the main window
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NexusXElite - Windows Optimization Suite" 
        Height="600" Width="800"
        WindowStartupLocation="CenterScreen"
        Background="#1e1e1e"
        Foreground="White"
        FontFamily="Segoe UI">
    <Window.Resources>
        <Style x:Key="ModernButton" TargetType="Button">
            <Setter Property="Background" Value="#0078d4"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="5">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#106ebe"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="Background" Value="#005a9e"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <!-- Header -->
        <Border Grid.Row="0" Background="#2d2d30" Padding="20">
            <StackPanel>
                <TextBlock Text="NEXUS X ELITE" FontSize="28" FontWeight="Bold" HorizontalAlignment="Center" Foreground="#0078d4"/>
                <TextBlock Text="Professional Windows Optimization Suite" FontSize="16" HorizontalAlignment="Center" Margin="0,5,0,0" Foreground="#cccccc"/>
            </StackPanel>
        </Border>
        
        <!-- Main Content -->
        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
            <StackPanel Margin="20">
                <!-- Hardware Detection -->
                <GroupBox Header="System Analysis" Margin="0,0,0,20">
                    <StackPanel>
                        <TextBlock Text="Detect and analyze your system hardware" Foreground="#cccccc" Margin="0,0,0,10"/>
                        <Button Name="btnHardwareDetect" Content="🔍 Detect Hardware" Style="{StaticResource ModernButton}" HorizontalAlignment="Left"/>
                        <TextBlock Name="txtHardwareInfo" Text="" Margin="0,10,0,0" TextWrapping="Wrap" Foreground="#ffffff"/>
                    </StackPanel>
                </GroupBox>
                
                <!-- Optimization Options -->
                <GroupBox Header="Optimization Modules" Margin="0,0,0,20">
                    <StackPanel>
                        <TextBlock Text="Choose optimization modules to apply" Foreground="#cccccc" Margin="0,0,0,10"/>
                        <Button Name="btnDeepOptimize" Content="⚡ Deep System Optimization" Style="{StaticResource ModernButton}" HorizontalAlignment="Left"/>
                        <Button Name="btnGamingOptimize" Content="🎮 Gaming Optimization" Style="{StaticResource ModernButton}" HorizontalAlignment="Left"/>
                        <Button Name="btnNetworkOptimize" Content="🌐 Network Optimization" Style="{StaticResource ModernButton}" HorizontalAlignment="Left"/>
                    </StackPanel>
                </GroupBox>
                
                <!-- Status -->
                <GroupBox Header="Status" Margin="0,0,0,20">
                    <TextBlock Name="txtStatus" Text="Ready to optimize your system" Foreground="#cccccc"/>
                </GroupBox>
            </StackPanel>
        </ScrollViewer>
        
        <!-- Footer -->
        <Border Grid.Row="2" Background="#2d2d30" Padding="10">
            <TextBlock Text="© 2024 NexusXElite - Enterprise Windows Optimization" HorizontalAlignment="Center" Foreground="#666666"/>
        </Border>
    </Grid>
</Window>
"@

# Load XAML
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Get controls
$btnHardwareDetect = $window.FindName("btnHardwareDetect")
$btnDeepOptimize = $window.FindName("btnDeepOptimize")
$btnGamingOptimize = $window.FindName("btnGamingOptimize")
$btnNetworkOptimize = $window.FindName("btnNetworkOptimize")
$txtHardwareInfo = $window.FindName("txtHardwareInfo")
$txtStatus = $window.FindName("txtStatus")

# Event handlers
$btnHardwareDetect.Add_Click({
    $txtStatus.Text = "Detecting hardware..."
    try {
        $hardware = Get-SystemHardware
        if ($hardware) {
            $info = @"
CPU: $($hardware.CPU.Name)
Cores: $($hardware.CPU.Cores) / Logical: $($hardware.CPU.LogicalProcessors)
RAM: $($hardware.Memory.TotalGB) GB
GPU: $($hardware.GPU.Name)
Storage: $(($hardware.Storage | ForEach-Object { "$($_.SizeGB)GB $($_.Model)" }) -join ', ')
"@
            $txtHardwareInfo.Text = $info
            $txtStatus.Text = "Hardware detection complete."
        } else {
            $txtHardwareInfo.Text = "Hardware detection failed."
            $txtStatus.Text = "Error detecting hardware."
        }
    } catch {
        $txtHardwareInfo.Text = "Error: $($_.Exception.Message)"
        $txtStatus.Text = "Hardware detection failed."
    }
})

$btnDeepOptimize.Add_Click({
    $txtStatus.Text = "Applying deep optimizations..."
    try {
        Invoke-DeepOptimization
        $txtStatus.Text = "Deep optimization complete."
    } catch {
        $txtStatus.Text = "Deep optimization failed: $($_.Exception.Message)"
    }
})

$btnGamingOptimize.Add_Click({
    $txtStatus.Text = "Applying gaming optimizations..."
    try {
        Invoke-GamingOptimization
        $txtStatus.Text = "Gaming optimization complete."
    } catch {
        $txtStatus.Text = "Gaming optimization failed: $($_.Exception.Message)"
    }
})

$btnNetworkOptimize.Add_Click({
    $txtStatus.Text = "Applying network optimizations..."
    try {
        Invoke-NetworkOptimization
        $txtStatus.Text = "Network optimization complete. Please restart."
    } catch {
        $txtStatus.Text = "Network optimization failed: $($_.Exception.Message)"
    }
})

# Show window
$window.ShowDialog() | Out-Null