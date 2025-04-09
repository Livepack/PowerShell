# Exchange Online Mail Trace Report Generator

This repository contains PowerShell scripts for both automated and manual Exchange Online mail trace generation. You can trace mail flows in both directions: **Sender → Recipient** and **Recipient → Sender**.

## Custom Exchange Online Mail Trace Report Generator

This script automates the process of generating mail trace reports from Exchange Online. It supports both tracing directions:
- **Sender → Recipient**
- **Recipient → Sender**

### Explanation of Changes:
Reversed Sender and Recipient: The $ReverseDirection switch allows the user to toggle between tracing Sender → Recipient and Recipient → Sender.

    If $ReverseDirection is true, the script will trace emails sent from the domain SenderDomain to the RecipientUser email.

    If $ReverseDirection is false (or not specified), the script will trace emails sent from RecipientUser to the SenderDomain.

Dynamic Report Title: The ReportTitle changes based on the direction of the trace, so it correctly reflects whether you’re tracing sender-to-recipient or recipient-to-sender.

### Usage:
```powershell
.\Custom_Exchange_Online_Mail_Trace_Report_Generator.ps1 -AdminUPN <Admin UPN> -SenderDomain <Sender Domain> -RecipientUser <Recipient User Email> -StartDate <Start Date> [-ReverseDirection]
```
### Example 1: Tracing Sender → Recipient (default behavior):
```powershell
.\Custom_Exchange_Online_Mail_Trace_Report_Generator.ps1 -AdminUPN admin@domain.com -SenderDomain schwenk.de -RecipientUser franz-josef.zurhove@thyssenkrupp.com -StartDate "2025-04-01"
```
### Example 2: Tracing Recipient → Sender (using the -ReverseDirection switch):
```powershell
.\Custom_Exchange_Online_Mail_Trace_Report_Generator.ps1 -AdminUPN "admin@domain.com" -SenderDomain "schwenk.de" -RecipientUser "franz-josef.zurhove@thyssenkrupp.com" -StartDate "2025-04-01" -ReverseDirection



