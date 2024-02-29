# PowerShell script to check network connectivity and send email alerts if servers are not reachable

Set-ExecutionPolicy Bypass -Scope Process -Force

# The servers to check for
$serverNames = @("server1", "server2", "server3", "server4")

# Email settings
$recipients = 'mail1@ofrecipient.com','mail2@ofrecipient.com','mail3@ofrecipient.com'  # Replace with the actual recipient email addresses
$from = "sender@mail.com"
$smtpServer = "smtp.mail.com"

# Function to ping the servers and compile their connectivity status with detailed problem description if any
function Check-ServerConnectivity {
    $serverStatuses = @()

    foreach ($server in $serverNames) {
        Try {
            $pingResult = Test-Connection -ComputerName $server -Count 2 -ErrorAction Stop
            $serverStatuses += "$server is reachable."
        } Catch {
            $errorMessage = $_.Exception.Message
            $serverStatuses += "$server is not reachable. Error: $errorMessage"
        }
    }

    # Preparing email content
    $body = "Server Connectivity Report:`n`n" + ($serverStatuses -join "`n")
    $subject = "Server Connectivity Report"

    Send-MailMessage -To $recipients -From $from -Subject $subject -Body $body -SmtpServer $smtpServer
    Write-Host "Email notification sent with server connectivity report."
}

# Check server connectivity and send report
Check-ServerConnectivity
