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
Function Apause(){
    param (
        [Parameter(Mandatory=$false)][string]$message,
        [Parameter(Mandatory=$false)][int]$active
    )
    [int]$_pause = 1
    if ($active -eq 0 -or 1) {
        [int]$_pause = $active
    } 
    Write-Output $message
    isPause -$_pause
}
function DeleteSelf() {
    $Path= $MyInvocation.ScriptName
    Write-Host $Path 
    Write-Host "===== Script is self distructing"
    Remove-Item $Path -force
}
Function isPause(){
    param (
        [Parameter(Mandatory=$false)][int]$pause
    )
    if ($pause) {
        Pause
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
    git push heroku heroku-prod
}
function exclusion-git{    
    $exclusionAttribute='
# Heroku Production Only
.gitignore merge=ours
.gitattributes merge=ours';
        
    Write-Output '
    ==== write attributes exclutions?
    '
    isPause -pause $pause    # write exclutions
    Out-File -FilePath .gitattributes -Encoding utf8 -InputObject $exclusionAttribute -NoClobber -Append

    Write-Output '
    ==== commit changes?
    '
    isPause -pause $pause    # commit changes
    git add .
    git commit -am "write Attribute exclutions"
}    
function merge-to-heroku-prod{
    Write-Output '
    merge to heroku-prod
    '
    isPause -pause $pause
    git checkout heroku-prod
    git merge master -X theirs
}

$active =! (ConfirmDialog -message "Run in speed mode?" -default 1)

$github_remote = ReadInput -default 'https://github.com/MoustafaMohsen/fridge-notes-api.git' `
-message 'Github remote serve url' -active $active -view 1;

$heroku_remote = ReadInput -default 'https://git.heroku.com/aspnet-1.git'`
-message 'Heroku remote serve url' -active $active -view 1;

$HerokutBranch ='heroku-prod' ;

# init git
Apause -message '=== init git?' -active $active
git init
Pause
# adding remotes
Apause -message '=== Add remotes?' -active $active
git remote add github $github_remote;
git remote add heroku $heroku_remote;


# config git
Apause -message '=== Configure local .git?' -active $active
git config  merge.ours.driver true

# === Self Destruct
DeleteSelf


# ============= preparing git

# pulling files
Apause -message '=== Pull files?' -active $active
git pull github master


Write-Output '=== Create branches ?'

# create branches
git branch  heroku-prod

exclusion-git

# add exclusion in branch.





# merge to heroku-prod


# checkout heroku-prod
Write-Output '=== Checkout to  heroku-prod ?'
git checkout  heroku-prod


Apause -message '=== config to  heroku branch to remote heroku ?' -active $active
git branch --set-upstream-to heroku/master
git config branch.heroku-prod.remote heroku

Apause -message '=== Fetch heroku remote ?' -active $active
git fetch
git branch --set-upstream-to heroku/master


# === Done
Write-Output '
creating is complete
=================================== REMOVE SENSETIVE FILES FROME .gitignore AND COMMIT =================================== 
'
pause