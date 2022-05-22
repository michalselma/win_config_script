#########################
# rename computer name
#########################
Function renameComputerName() {
    $computerName = Read-Host 'Enter New Computer Name'
    PrintWarn "Renaming this computer to: " $computerName
    Rename-Computer -NewName $computerName
}

#########################
# List, uninstall or install Microsoft applicaions
#########################





#########################
# Win11-tweaks call-out
#########################
Function executeTweaks($filename) {
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$currentDir/$filename.ps1" -include "$currentDir/tweaks/*.psm1" -preset "$currentDir/$filename.preset"
}


#########################
# Modules End
#########################

Export-ModuleMember -Function *
