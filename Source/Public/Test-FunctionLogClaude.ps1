function Test-FunctionLogClaude {
    try {
    
        # Exemple d'utilisation
        Write-CustomLogClaude -Message "This is a success message." -LogType "Success"
        Write-CustomLogClaude -Message "This is an error message." -LogType "Error"
        Write-CustomLogClaude -Message "This is a warning message." -LogType "Warning"
        Write-CustomLogClaude -Message "This is a debug message." -LogType "Debug"

        function test {
            Get-Process | Select-Object -First 10 name, handles | ForEach-Object {
                Write-CustomLogClaude -Message $_.name -LogType (Get-Random "error", "debug", "success", "warning")
            }
        }
        function test2 {
            Get-Process | Select-Object -First 10 name, handles | ForEach-Object {
                Write-CustomLogClaude -Message $_.name -LogType (Get-Random "error", "debug", "success", "warning")
            }
        }
        test
        test2
    }
    catch {
        Write-Host $_.Exception.Message Error
    }
}