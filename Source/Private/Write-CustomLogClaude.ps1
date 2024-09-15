function Write-CustomLogClaude {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('Success', 'Error', 'Warning', 'Debug')]
        [string]$LogType = 'Success'
    )

    # Obtenir le nom du script ou de la fonction en cours
    $callStack = Get-PSCallStack
    $callerName = if ([string]$callStack.command -contains "scriptblock") {
        "Interactive" 
    }
    else {
        $callStack[1].Command 
    }
    
    # Créer un nom de fichier unique pour la session
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $logFolderPath = Join-Path $env:APPDATA "Clixed\logs"
    if (-not $script:sessionId) {
        $script:sessionId = [Guid]::NewGuid().ToString()
    }
    if (-not $script:logFileName -or $script:logFileName -notlike "$($callerName)*") {
        $script:logFileName = "$callerName-$timestamp-$sessionID.log"
    }

    # Définir le chemin du fichier de log
    $logPath = if ($LogType -eq 'Debug') {
        Join-Path $logFolderPath "debug"
    }
    else {
        $logFolderPath
    }

    # Tester et créer les dossiers de logs si besoin
    if (-not (Test-Path $logpath)) {
        mkdir $logPath
    }

    # Créer le dossier debug si nécessaire
    if ($LogType -eq 'Debug' -and -not (Test-Path $logPath)) {
        New-Item -ItemType Directory -Path $logPath | Out-Null
    }

    $logFilePath = Join-Path $logPath $logFileName

    # Préparer le message de log
    $logTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$logTime] [$LogType] $Message"

    # Écrire dans le fichier de log
    #Write-Host $logFilePath
    Add-Content -Path $logFilePath -Value $logMessage 

    # Définir la couleur pour Write-Host
    $color = switch ($LogType) {
        'Success' {
            'Green' 
        }
        'Error' {
            'Red' 
        }
        'Warning' {
            'Yellow' 
        }
        'Debug' {
            'Cyan' 
        }
        default {
            'White' 
        }
    }

    # Afficher le message dans la console
    Write-Host $logMessage -ForegroundColor $color
}