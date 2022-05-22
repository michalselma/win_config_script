#########################
# Auxiliary Functions
#########################

# *** Check and relaunch script with administrator privilege if needed 
Function AdministratorRightsCheck($varScriptPath) {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		PrintFunctionInfo "Script requires Administrator rights. Restarting..."
		#PrintFunctionLog "[adminRightsCheck] variable varScriptPath: $varScriptPath"
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$varScriptPath`"" -Verb RunAs
		#PrintFunctionLog "[adminRightsCheck] Start-Process powershell.exe done"
		Exit
	}
	PrintFunctionInfo "Script is run with Administrator rights. Continuing..."
}

# *** Restart computer without asking
Function Restart {
	Write-Output "Restarting..."
	Restart-Computer
}

# *** Ask to restart computer 
Function RestartAsk() {
    $restartInput = Read-Host "Setup is done, restart is needed, input 'y' to restart computer now. (y/[N])"
    if ((('y', 'Y', 'yes') -contains $restartInput)) {
        Restart-Computer
    } else {
        WaitForKey
    }
}

#########################
# User Key interactions
#########################

# *** Wait for any key press
Function waitForKey {
	Write-Output "Press any key to continue..."
	[Console]::ReadKey($true) | Out-Null
}

# *** Wait for ENTER press
Function waitForENTER {
	Read-Host "Press ENTER to continue..."
}


#########################
# On-screen messages
#########################

# *** Application Info
Function PrintInfo($str) {
	$getCurDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    Write-Host $getCurDateTime $str -ForegroundColor Green
}

# *** Function Info
Function PrintFunctionInfo($str) {
	$getCurDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    Write-Host $getCurDateTime $str -ForegroundColor Blue
}

# *** Application Log
Function PrintLog($str) {
	$getCurDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    Write-Host $getCurDateTime $str -ForegroundColor DarkGray
}

# *** Function Log
Function PrintFunctionLog($str) {
	$getCurDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    Write-Host $getCurDateTime $str -ForegroundColor Cyan
}

# *** Warning
Function PrintWarn($str) {
	$getCurDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    Write-Host $getCurDateTime $str -ForegroundColor Yellow
}

# *** Error
Function PrintError($str) {
	$getCurDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    Write-Host $getCurDateTime $str -ForegroundColor Red
}

#########################
# Modules End
#########################

# Export module functions
Export-ModuleMember -Function *