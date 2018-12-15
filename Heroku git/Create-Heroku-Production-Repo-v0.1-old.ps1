function ReadInput() {
    # ==== usage example
    #$var = ReadInput -message "please enter value" -default "default value"
    # === No parameter is Mandatory
    param (
        [Parameter(Mandatory=$false)][string]$message,
        [Parameter(Mandatory=$false)][string]$default,
        [Parameter(Mandatory=$false)][int]$active
    )
    [int]$_active = 1
    if ($active) {
        [int]$_active = $active
    }
    
    if ($_active) {
        $_message = "Values is"
        if ($message) {
            [string]$_message = $message
        }    
        if ($default) {
            [string]$_default = $default
            $_message = "$_message (default is [$_default])"
        } 
    
        $result = Read-Host "$_message"
        $_default = ""
        if( $result -eq '')
        {
            return $default
        }
        else{
            return $result
        }
    }else{
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
function DeleteSelf() {
    $Path= $MyInvocation.ScriptName
    Write-Host $Path 
    Write-Host "== Script is self distructing"
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

$pause = ReadInput -message "run in step mode?" -default '0'
Write-Output "You Entered:$pause"

$github_remote = ReadInput -default 'https://github.com/MoustafaMohsen/fridge-notes-api.git' `
-message 'Github remote serve url' -active $pause;
Write-Output "You Entered:$github_remote"

$heroku_remote = ReadInput -default 'https://git.heroku.com/aspnet-1.git'`
-message 'Heroku remote serve url' -active $pause;
Write-Output "You Entered:$heroku_remote"

$HerokutBranch = ReadInput -default 'heroku-prod' `
-message 'Local Heroko brach name' -active $pause;
Write-Output "You Entered:$HerokutBranch"


Write-Output '
=== init git?
'
isPause -pause $pause

# init git
git init

Write-Output '
=== Add remotes?
'
isPause -pause $pause

# adding remotes
git remote add github $github_remote;
git remote add heroku $heroku_remote;

Write-Output '
=== Configure local .git ?
'
isPause -pause $pause


# config git
git config  merge.ours.driver true



# ============= preparing git

Write-Output '
=== Pull files?
'
isPause -pause $pause

# pulling files
git pull github master


Write-Output '
=== Create branches ?
'
# create branches
git branch  heroku-prod

exclusion-git

# add exclusion in branch.





# merge to heroku-prod
function merge-to-heroku-prod{
    Write-Output '
    merge to heroku-prod
    '
    isPause -pause $pause
    git checkout heroku-prod
    git merge master -X theirs
}

Write-Output '
=== Checkout to  heroku-prod ?
'
# checkout heroku-prod
git checkout  heroku-prod


Write-Output '
=== config to  heroku branch to remote heroku ?
'

isPause -pause $pause
git branch --set-upstream-to heroku/master
git config branch.heroku-prod.remote heroku
Write-Output '
=== Fetch heroku remote ?
'
isPause -pause $pause

git fetch
git branch --set-upstream-to heroku/master


# === Done
Write-Output '
creating is complete
=================================== REMOVE SERSETIVE FILES FROME .gitignore AND COMMIT =================================== 
then past this line to .gitattributes
'
pause