# Moustafa Mohsen 15-12-2018
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