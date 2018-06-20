#Moustafa Mohesen 2018
#Confirmation dialogue
$caption1 = "Please Confirm"    
$message1 = '
This operation could take a while, make sure you have a stable internet connection.
 Please before continuing make sure of the following:
     1- Docker is running & ready, the container is set to linux
     2- You are running this script from the project folder
     3- Heroku app is created and ready
     4- You have made a proper Dockerfile and placed it in the project folder
     5- Heroku-cli and dotnet is up to date to the lates version
Is everything ready
'

[int]$defaultChoice1 = 0
$yes1 = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "continue."
$no1 = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "I'm not ready."
$options1 = [System.Management.Automation.Host.ChoiceDescription[]]($yes1, $no1)
$choiceRTN1 = $host.ui.PromptForChoice($caption1,$message1, $options1,$defaultChoice1)
if ( $choiceRTN1 -ne 1 )
{}
else
{exit}


#confirm login status
$caption3 = "Login Confirm"    
$message3 = '
Are you logged in in heroku-cli and heroku container
'

[int]$defaultChoice3 = 0
$yes3 = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Already logged in" 
$no3 = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "I need to login"
$options3 = [System.Management.Automation.Host.ChoiceDescription[]]($yes3, $no3)
$choiceRTN3 = $host.ui.PromptForChoice($caption3,$message3, $options3,$defaultChoice3)
if ( $choiceRTN3 -ne 0 )
{
heroku login
heroku container:login
}
else
{

}

echo '

IMPORTANT: lower case only is allowed
'
$appname = Read-Host 'What is the app name in heroku?'
$imagename = Read-Host 'what name would you like to give to the image?'

dotnet publish -c Release

Copy-Item ".\Dockerfile" -Destination ".\bin\release\netcoreapp2.0\publish"

& docker build -t $imagename ./bin/release/netcoreapp2.0/publish

& docker tag $imagename registry.heroku.com/$appname/web

& docker push registry.heroku.com/$appname/web

#Confirmation dialogue
$caption2 = "Please Confirm"    
$message2 = "Release Image in heroku:"
[int]$defaultChoice2 = 0
$yes2 = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "release."
$no2 = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not release."
$options2 = [System.Management.Automation.Host.ChoiceDescription[]]($yes2, $no2)
$choiceRTN2 = $host.ui.PromptForChoice($caption2,$message2, $options2,$defaultChoice2)
if ( $choiceRTN2 -ne 1 )
{& heroku container:release web --app $appname}
else
{Write-host 'cancelled releas'}
echo 'all done'
pause