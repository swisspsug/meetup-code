# create function to show the weather for a given city using wttr api
function showWeather {
    param(
        [Parameter(Mandatory=$true)]
        [string]$city
    )
    # get the weather for the city
    $weather = Invoke-RestMethod -Uri "http://wttr.in/$city"
    # return the weather
    return $weather
}
# show the weather in bern
showWeather -city "bern"

# download some dummy images in the current directory
Invoke-WebRequest -Uri "https://picsum.photos/200/300" -OutFile "image1.jpg"
Invoke-WebRequest -Uri "https://picsum.photos/200/300" -OutFile "image2.jpg"
Invoke-WebRequest -Uri "https://picsum.photos/200/300" -OutFile "image3.jpg"
Invoke-WebRequest -Uri "https://picsum.photos/200/300" -OutFile "image4.jpg"

# I need some dummy user information. Create a folder for each dummy user and make sure there is a profile picture in each folder. The data format should be json
# create a function to create the dummy user data
function createDummyUserData {
    param(
        [Parameter(Mandatory=$true)]
        [string]$userName,
        [Parameter(Mandatory=$true)]
        [string]$userEmail,
        [Parameter(Mandatory=$true)]
        [string]$userPassword
    )
    # create a folder for the user
    New-Item -ItemType Directory -Path $userName
    # create a json file with the user data
    $userData = @{
        userName = $userName
        userEmail = $userEmail
        userPassword = $userPassword
    }
    $userData | ConvertTo-Json | Out-File -FilePath "$userName\profile.json"
    # copy a random image to the user folder
    $image = Get-ChildItem -Path . -Filter "image*.jpg" | Get-Random
    Copy-Item -Path $image.FullName -Destination "$userName\profile.jpg"
}
# use an api to generate 5 random users and call the function. Download a random image for each user
# get 5 random users
$randomUsers = Invoke-RestMethod -Uri "https://randomuser.me/api/?results=5"
# loop through the results and create a dummy user for each
foreach ($user in $randomUsers.results) {
    createDummyUserData -userName $user.login.username -userEmail $user.email -userPassword $user.login.password
}

# call the ms graph to update the address information for all users in $users variable
# create a function to update the address information for a user
function updateAddress {
    param(
        [Parameter(Mandatory=$true)]
        [string]$userName,
        [Parameter(Mandatory=$true)]
        [string]$userEmail,
        [Parameter(Mandatory=$true)]
        [pscredential]$userPassword,
        [Parameter(Mandatory=$true)]
        [string]$street,
        [Parameter(Mandatory=$true)]
        [string]$city,
        [Parameter(Mandatory=$true)]
        [string]$state,
        [Parameter(Mandatory=$true)]
        [string]$country,
        [Parameter(Mandatory=$true)]
        [string]$zip
    )
    # get the access token
    $accessToken = Get-AccessToken -userName $userName -userPassword $userPassword
    # update the address information
    $address = @{
        street = $street
        city = $city
        state = $state
        countryOrRegion = $country
        postalCode = $zip
    }
    $address | ConvertTo-Json | Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/me/addresses/office" -Method Patch -Headers @{"Authorization" =$accessToken} -ContentType "application/json"
}
# get the users
$users = Get-ChildItem -Path . -Directory
# loop through the users and update the address information
foreach ($user in $users) {
    # get the user data
    $userData = Get-Content -Path "$user\profile.json" | ConvertFrom-Json
    # update the address information
    updateAddress -userName $userData.userName -userEmail $userData.userEmail -userPassword $userData.userPassword -street "Main Street" -city "Bern" -state "Bern" -country "Switzerland" -zip "3000"
}

# call the ms graph to update the profile picture for all users in $users variable
# create a function to update the profile picture for a user
function updateProfilePicture {
    param(
        [Parameter(Mandatory=$true)]
        [string]$userName,
        [Parameter(Mandatory=$true)]
        [string]$userEmail,
        [Parameter(Mandatory=$true)]
        [pscredential]$userPassword,
        [Parameter(Mandatory=$true)]
        [string]$profilePicture
    )
    # get the access token
    $accessToken = Get-AccessToken -userName $userName -userPassword $userPassword
    # update the profile picture
    Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/me/photo/$profilePicture" -Method Put -Headers @{"Authorization" =$accessToken} -ContentType "application/json"
}
# get the users
$users = Get-ChildItem -Path . -Directory
# loop through the users and update the profile picture
foreach ($user in $users) {
    # get the user data
    $userData = Get-Content -Path "$user\profile.json" | ConvertFrom-Json
    # update the profile picture
    updateProfilePicture -userName $userData.userName -userEmail $userData.userEmail -userPassword $userData.userPassword -profilePicture "$user\profile.jpg"
}

