function ReadInput() {
    # ==== usage example
    #$var = ReadInput -message "please enter value" -default "default value"
    # === No parameter is Mandatory
    param (
        [string]$message = "Values is",
        [string]$default = "",
        [boolean]$active = 1,
        [boolean]$view = 0

    )
    if ($active -eq $true) {  
        # if there is a default change massage style
        if (-not [string]::IsNullOrEmpty($default)) {
            [string]$message = "$message (default is [$default])"
        }
        # read host
        $result = Read-Host $message;
        # if input is empty read, reslut default value
        if ([string]::IsNullOrEmpty($result)) {
            $result = $default
        }
        # return value
        if ($view) {
            Write-Host "You Entered:$result"
        }
        return $result

    }else{
        if ($view) {
            Write-Host "You Entered:$default"
        }
        return $default
    }
}

Function Apause(){
    param (
        [Parameter(Mandatory=$false)][string]$message,
        [Parameter(Mandatory=$false)][int]$active
    )
    [int]$_pause = 1
    if ($active -eq 0 -or 1) {
        [int]$_pause = $active
    } 
    Write-Host $message
    isPause -$_pause
}

Function ConfirmDialog() {
    #=======usage Example
    #$dialog = ConfirmDialog -message "confirme operation?" -description 'confirme operation description' `
    #-default 0  -yes "yes option description" -no "no option descriptio"

    # if($dialog -eq 1){
        #yes logic
    #}else{
        #no logic
    #}
    # === -default yes is 1, -default no is 0
    # ==  no parameter is Mandatory

    param(
        [Parameter(Mandatory=$false)][string]$message,
        [Parameter(Mandatory=$false)][string]$description,
        [Parameter(Mandatory=$false)][int]$default,
        [Parameter(Mandatory=$false)][string]$yes,
        [Parameter(Mandatory=$false)][string]$no
    )

    [int]$defaultChoice1 = 0
    $message_description1 = 'Continue'
    $caption1 = 'Proceed?'
    $yesmsg = 'Confirm'
    $nomsg = 'reject'
    if ($default -eq 0 -or 1) {
        [int]$defaultChoice1 = !$default
    } 
    if ($description) {
        [string]$message_description1 = $description
    }    
    if ($message) {
        [string]$caption1 = $message
    } 

    if ($yes) {
        [string]$yesmsg = $yes
    }       
    if ($no) {
        [string]$nomsg = $no
    }       

    $yes1 = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $yesmsg
    $no1 = New-Object System.Management.Automation.Host.ChoiceDescription "&No", $nomsg
    $options1 = [System.Management.Automation.Host.ChoiceDescription[]]($yes1, $no1)
    $choiceRTN1 = $host.ui.PromptForChoice($caption1,$message_description1, $options1,$defaultChoice1)
    if ( $choiceRTN1 -ne 1 )
    {
        return 1;
    }
    else
    {
        return 0;
    }
    
}

function mergeToMaster {
    git checkout heroku-prod
    git merge master -X theirs
}

function pullFromGithub {
    git checkout master
    git pull github master
}

function pushToHeroku {
    git checkout heroku-prod
    #git push -u heroku heroku-prod
    git push heroku HEAD:master
}

$step = ! (ConfirmDialog -default 1 -message "Speed Mode?")
Apause -message "Continue?" -active $step

Write-Host "------------------ Git Status ------------------"
git status

Apause -message "Pull from Gtihub?" -active $step
Write-Host "------------------ Pulling from Gtihub ------------------"
pullFromGithub

Apause -message "Merge master to heroku-prod?" -active $step
Write-Host "------------------ Mergeing master to heroku-prod ------------------"
mergeToMaster

Apause -message "Push heroku-prod to Heroku?" -active $step
Write-Host "------------------ Pushing heroku-prod to Heroku ------------------"
pushToHeroku