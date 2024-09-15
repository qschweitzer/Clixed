function Test-FunctionLogGPT {
    try {
    
        # Exemple d'utilisation
        Write-CustomLogGPT -Message "This is a success message." -LogType "Success"
        Write-CustomLogGPT -Message "This is an error message." -LogType "Error"
        Write-CustomLogGPT -Message "This is a warning message." -LogType "Warning"
        Write-CustomLogGPT -Message "This is a debug message." -LogType "Debug"

        function test {
            Get-Process | Select-Object -First 10 name, handles | ForEach-Object {
                Write-CustomLogGPT -Message $_.name -LogType (Get-Random "error", "debug", "success", "warning")
            }
        }
        function test2 {
            Get-Process | Select-Object -First 10 name, handles | ForEach-Object {
                Write-CustomLogGPT -Message $_.name -LogType (Get-Random "error", "debug", "success", "warning")
            }
        }
        test
        test2
    }
    catch {
        Write-Host $_.Exception.Message Error
    }
}