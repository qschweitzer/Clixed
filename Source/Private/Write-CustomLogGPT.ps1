function Write-CustomLogGPT {
    param (
        [string]$Message,
        [ValidateSet("Success", "Error", "Warning", "Debug")]
        [string]$LogType = "Debug"
    )

    # Déterminer le nom du fichier de log basé sur le nom de la fonction ou du script en cours et l'horodatage
    $callStack = Get-PSCallStack
    $scriptname = if ([string]$callStack.command -contains "scriptblock") {
        "Interactive" 
    }
    else {
        $callStack[1].Command 
    }
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $script:sessionID = [guid]::NewGuid().ToString()
    if (-not $script:logFileName -or -not $script:sessionID) {
        $script:logFileName = "$scriptName-$timestamp-$sessionID.log"
    }

    # Déterminer le chemin du fichier de log basé sur le type de log
    $logFolderPath = Join-Path $env:APPDATA "Clixed\logs"
    $logDirectory = if ($LogType -eq "Debug") {
        "$($logFolderPath)\debug" 
    }
    else {
        $logFolderPath 
    }
    
    if (-not (Test-Path $logDirectory)) {
        New-Item -Path $logDirectory -ItemType Directory | Out-Null
    }

    $logFilePath = Join-Path -Path $logDirectory -ChildPath $global:logFileName

    # Créer le message de log avec horodatage
    $timestampedMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") [$LogType] $Message"

    # Écrire dans le fichier de log
    Add-Content -Path $logFilePath -Value $timestampedMessage

    # Colorer la sortie dans la console en fonction du type de log
    switch ($LogType) {
        "Success" {
            Write-Host $timestampedMessage -ForegroundColor Green 
        }
        "Error" {
            Write-Host $timestampedMessage -ForegroundColor Red 
        }
        "Warning" {
            Write-Host $timestampedMessage -ForegroundColor Yellow 
        }
        "Debug" {
            Write-Host $timestampedMessage -ForegroundColor Cyan 
        }
    }
}
