# PowerShell script to check network connectivity and send email alerts if servers are not reachable

Set-ExecutionPolicy Bypass -Scope Process -Force

# The servers to check for
$serverNames = @("qvaryfaldb13", "qvaryfaldb21", "qvaryfaldb01", "qvaryfaldb07")

# Email settings
$recipients = 'robert.smidak@yanfeng.com','jim.yao@yanfeng.com','ivy.maclean@yanfeng.com','marco.rodriguez01@yanfeng.com'  # Replace with the actual recipient email addresses
$from = "cyberquery-bi@yanfeng-auto.com"
$smtpServer = "mailrelay.yanfeng.com"

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
