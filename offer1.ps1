$firefoxPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'
$url = 'https://yandex.com/'

# Open Firefox with the specified URL
Start-Process -FilePath $firefoxPath -ArgumentList $url

# Wait for Firefox to fully load
Start-Sleep -Seconds 10

# Use the .NET UI Automation framework to find and click the "Войти" button
$firefoxWindow = Get-Process -Name firefox | Select-Object -First 1
$firefoxMainWindow = [System.Windows.Automation.AutomationElement]::FromHandle($firefoxWindow.MainWindowHandle)

$loginButtonPattern = $firefoxMainWindow.GetCurrentPattern([System.Windows.Automation.InvokePatternIdentifiers]::Pattern)
$loginButton = $firefoxMainWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, [System.Windows.Automation.Condition]::TrueCondition)

# Click the "Войти" button
$loginButtonPattern.Invoke()
