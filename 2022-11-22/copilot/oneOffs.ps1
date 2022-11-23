# clean up files older than 30 days in Downloads
Get-ChildItem -Path $env:USERPROFILE\Downloads -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force

# get errors from event log with id 2
Get-WinEvent -FilterHashtable @{LogName="Application";ID=2} | Select-Object -Property TimeCreated,Message | Format-Table -AutoSize

# zeig mir die angelegten Benutzer
Get-LocalUser | Select-Object -Property Name,Enabled,PasswordNeverExpires,PasswordChangeable,PasswordExpires,PasswordRequired | Format-Table -AutoSize

# zeigsch mir die aktuelle username
whoami

# wie spöt isch?
Get-Date

# welle blöde user hät letzsch uf dem PC si agmolde?
Get-EventLog -LogName Security -Newest 1 | Select-Object -Property TimeGenerated,UserName | Format-Table -AutoSize

# user a free api to give me 5 swiss names
Invoke-RestMethod -Uri "https://randomuser.me/api/?results=5&nat=ch" | Select-Object -ExpandProperty results | Format-Table -AutoSize

# create a variable with a list of fruit
$fruit = "apple","banana","orange","pear","grape"

# create another variable in german
$fruitDe = "Apfel","Banane","Orange","Birne","Traube"

# and another in polish
$fruitPl = "jabłko","banan","pomarańcza","gruszka","winogrono"

# create a function to get a random fruit with a specific language
function getRandomFruit {
    param(
        [Parameter(Mandatory=$true)]
        [string]$language
    )
    # get a random fruit
    $randomFruit = $fruit | Get-Random
    # get the index of the random fruit
    $index = $fruit.IndexOf($randomFruit)
    # return the fruit in the specified language
    switch ($language) {
        "de" { $fruitDe[$index] }
        "pl" { $fruitPl[$index] }
        default { $randomFruit }
    }
}

# call the function to get a random fruit in german
getRandomFruit -language "de"