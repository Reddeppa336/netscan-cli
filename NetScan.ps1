param (
    [string]$target,
    [string]$ports
)

$ErrorActionPreference = "Stop"
$logFile = "netscan.log"

function Log($msg) {
    Add-Content $logFile "[$(Get-Date)] $msg"
}

function Scan-Port($target, $port) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($target, $port)
        $client.Close()
        return $true
    }
    catch {
        return $false
    }
}

if (-not $target -or -not $ports) {
    Write-Host "Usage: .\NetScan.ps1 -target <IP> -ports <p1,p2>"
    exit
}

$portList = $ports -split ","

Log "Starting scan on $target"

foreach ($port in $portList) {
    if (Scan-Port $target $port) {
        Write-Host "[OPEN] Port $port"
        Log "Port $port OPEN"
    } else {
        Write-Host "[CLOSED] Port $port"
    }
}

Log "Scan finished"