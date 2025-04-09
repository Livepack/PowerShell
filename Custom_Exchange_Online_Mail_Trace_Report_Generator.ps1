param (
    [string]$AdminUPN,
    [string]$SenderDomain,
    [string]$RecipientUser,
    [string]$StartDate,
    [switch]$ReverseDirection
)

# Connect to Exchange Online
Write-Host "Connecting to Exchange Online..."
Connect-ExchangeOnline -UserPrincipalName $AdminUPN -ShowProgress $true

# Adjust StartDate if older than 90 days
$StartDateParsed = [datetime]$StartDate
$MaxDate = (Get-Date).AddDays(-90)

if ($StartDateParsed -lt $MaxDate) {
    Write-Host "WARNING: StartDate is more than 90 days ago. Adjusting to 90 days ago."
    $StartDateParsed = $MaxDate
}

# Determine the sender and recipient based on direction
if ($ReverseDirection) {
    $SenderAddress = "*@$SenderDomain"
    $RecipientAddress = $RecipientUser
    $ReportTitle = "MessageTrace_$($SenderDomain.Replace('@', '_'))_to_$($RecipientUser.Replace('@', '_'))_$($StartDateParsed.ToString('yyyyMMddHHmmss'))"
    Write-Host "Tracing: $SenderAddress to $RecipientAddress"
} else {
    $SenderAddress = $RecipientUser
    $RecipientAddress = "*@$SenderDomain"
    $ReportTitle = "MessageTrace_$($RecipientUser.Replace('@', '_'))_to_$($SenderDomain.Replace('@', '_'))_$($StartDateParsed.ToString('yyyyMMddHHmmss'))"
    Write-Host "Tracing: $SenderAddress to $RecipientAddress"
}

# Start Historical Search for Mail Trace
Write-Host "Submitting historical search request: $ReportTitle"
$searchRequest = Start-HistoricalSearch -ReportTitle $ReportTitle `
                                        -StartDate $StartDateParsed `
                                        -EndDate (Get-Date) `
                                        -SenderAddress $SenderAddress `
                                        -RecipientAddress $RecipientAddress `
                                        -ReportType "MessageTrace"

# Wait for the report to complete
$reportStatus = Get-HistoricalSearch -JobId $searchRequest.JobId

while ($reportStatus.Status -eq "NotStarted" -or $reportStatus.Status -eq "InProgress") {
    Write-Host "Status: $($reportStatus.Status)"
    Start-Sleep -Seconds 30
    $reportStatus = Get-HistoricalSearch -JobId $searchRequest.JobId
}

Write-Host "Report Status: $($reportStatus.Status)"
if ($reportStatus.Status -eq "Done") {
    Write-Host "Report is ready! Downloading..."
    
    # Check if FileUrl is an array or single value and handle accordingly
    $url = $reportStatus.FileUrl
    if ($url -is [Array]) {
        $url = $url[0]  # Get the first element if it's an array
    }

    # Ensure we have a valid URI
    if ($url -is [Uri]) {
        Invoke-WebRequest $url -OutFile "C:\Users\$env:USERNAME\Downloads\$ReportTitle.csv"
        Write-Host "Report saved to: C:\Users\$env:USERNAME\Downloads\$ReportTitle.csv"
    } else {
        Write-Host "Error: Invalid URL received for report download."
    }
} else {
    Write-Host "No results found."
}
