#########################
# Set script internal variables
#########################

# *** psm1 variables - modules names and configs
$varScriptFunctFileName = "functions.psm1"
$varAuxiliaryFileName = "auxiliary.psm1"
$varLogFileName = Get-Date -Format FileDateTime
$varAppxFileName = "appxpackages.psm1"
$varAppxCfgPath = "config\appxpackages.config"
$varPowerOptFileName = "powersettings.psm1"
$varPowerOptCfgPath = "config\powersettings.config"
#$varTweaksFileName = "tweaks.psm1"
#$varTweaksCfgPath = "config\tweaks.config"
#$varTweaksModulesDirectory = "tweaks"

#########################
# Get system variables
#########################

# *** Get full path and file name of the script that is being run
$varScriptPath = $PSCommandPath
#Write-Host "varScriptPath: $varScriptPath" -ForegroundColor DarkGray

# *** Get full path/directory of the script that is being run
$varScriptDir = $PSScriptRoot
#Write-Host "varScriptDir: $varScriptDir" -ForegroundColor DarkGray

#########################
# Start Log
#########################
$log = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$varScriptDir\log\$varLogFileName.log")
Start-Transcript $log

#########################
# Import Modules
#########################
Write-Host "Importing Modules..." -ForegroundColor DarkGray
Import-Module -Name "$varScriptDir\$varScriptFunctFileName" -ErrorAction Stop
Import-Module -Name "$varScriptDir\$varAuxiliaryFileName" -ErrorAction Stop
Import-Module -Name "$varScriptDir\$varAppxFileName" -ErrorAction Stop
Import-Module -Name "$varScriptDir\$varPowerOptFileName" -ErrorAction Stop
#Import-Module -Name "$varScriptDir\$varTweaksFileName" -ErrorAction Stop
foreach ($module in Get-Childitem $varScriptDir\$varTweaksModulesDirectory\ -Name -Filter "*.psm1")
{
    Import-Module $varScriptDir\$varTweaksModulesDirectory\$module -ErrorAction Stop
}
PrintLog "Import-Module Finished"

#########################
# Command list
#########################

PrintInfo "Running Administartor Rights check..."
AdministratorRightsCheck $varScriptPath
PrintLog "AdministratorRightsCheck command Finished"

PrintInfo "Running Power Config Set-up command..."
$pwrcfgfile = "$varScriptDir\$varPowerOptCfgPath"
PowerSettings $pwrcfgfile
PrintLog "PowerSettings command Finished"

PrintInfo "Starting Microsoft Windows Appx Applications configuration..."
$appxcfgfile = "$varScriptDir\$varAppxCfgPath"
Applications $appxcfgfile
PrintLog "Applications command Finished"

#PrintInfo "Executing tweaks set-up..."
#$tweakscfgfile = "$varScriptDir\$varTweaksCfgPath"
#Tweaks $tweakscfgfile
#PrintLog "Tweaks command Finished"

PrintInfo "Starting Computer Rename..."
RenameComputerAsk
PrintLog "RenameComputerAsk command Finished"

PrintInfo "Restart required..."
RestartAsk
PrintLog "RestartAsk command Finished"

waitForKey

exit
