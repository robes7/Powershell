# Define the services to monitor
$servicesToCheck = @("service1", "service2", "service3")

# Define the path for the log file
$logFilePath = "C:\Logs\errorlog_services.txt"

foreach ($service in $servicesToCheck) {
    $serviceStatus = Get-Service $service | Select-Object Status, DisplayName
	$recipients = 'recipient@mail.com','recipient2@mail.com'

    try {
        if ($serviceStatus.Status -eq 'Stopped') {
            # Notify when the service is stopped
            Send-MailMessage -To $recipients -From 'sender@mail.com' -Subject "Service Alert: $($serviceStatus.DisplayName) has stopped! Please run the service again." -Body "Service $($serviceStatus.DisplayName) has stopped.- Please take an action and restart the service. " -SmtpServer 'smtp_server'
		}
    } catch {
        # Write error to the log file
        $errorMessage = "$(Get-Date) - Error encountered while processing service $($serviceStatus.DisplayName): $($_.Exception.Message)"
        $errorMessage | Out-File -Append $logFilePath
    }
}
