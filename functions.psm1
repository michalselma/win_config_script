#########################
# Computer Rename
#########################
Function renameComputerAsk() {
    $renameComputerInput = Read-Host "Do you want to set/change Computer Name ? Press 'y' to rename computer or ENTER to skip"
    if ((('y', 'Y', 'yes') -contains $renameComputerInput)) {
        $computerName = Read-Host 'Enter New Computer Name'
    	PrintWarn "Renaming this computer to: " $computerName
    	Rename-Computer -NewName $computerName
    } else {
        PrintWarn "Pressed ENTER or picked other key. Skipping Computer Rename."
    }
}

#########################
# Windows tweaks call-out
#########################
Function executeTweaks($filename) {
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$currentDir/$filename.ps1" -include "$currentDir/tweaks/*.psm1" -preset "$currentDir/$filename.preset"
}

#########################
# Computer Restart
#########################

# *** Restart computer without asking
Function Restart {
	Write-Output "Restarting..."
	Restart-Computer
}

# *** Ask to restart computer 
Function RestartAsk() {
    $restartInput = Read-Host "Setup is done and computer restart is needed. Input 'y' to restart computer now or ENTER to skip"
    if ((('y', 'Y', 'yes') -contains $restartInput)) {
        Restart-Computer
    } else {
        PrintWarn "Pressed ENTER or picked other key. Skipping Computer Restart."
    }
}

#########################
# Modules End
#########################

Export-ModuleMember -Function *
