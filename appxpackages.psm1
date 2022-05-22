#########################
# Add or Remove Applications
#########################

# *** List installed Microsoft applications
Function ListInstalledAppxPkgs($appslistfile) {
    #PrintFunctionInfo "Dropping installed apps list: $appslistfile"
    Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName | Out-File -FilePath $appslistfile
}

$removeapps = @()
$addapps = @()
$skipapps = @()

Function AddRemoveLists($appcfgfile) {
    #PrintFunctionInfo "Building add/remove applications list..."
    $appcfg = @()
    $add = @()
    $remove = @()
    $skip = @()

    # *** Get config content and remove whitespaces at beggining and end of each object
    $appcfg = Get-Content $appcfgfile -ErrorAction Stop | ForEach-Object { $_.Trim() }
    #PrintFunctionLog "[AddRemoveLists] Loaded config content and trimmed whitespaces" 

    # *** Remove Empty lines/objects
    # !!! $_.Trim() above should do the job, but to be checked why it does not work for empty line as 'n (Enter) !!!
    # !!! If no objects (empty Enter line) Trim will cause/leave it as null object, where Where-Object will filter them out (prevents null execption) !!!
    $appcfg = $appcfg | Where-Object {$_}
    #PrintFunctionLog "[AddRemoveLists] Removed Empty Lines/Objects" 

    # *** Remove comments
    $appcfg = $appcfg | Where-Object { $_.Substring(0,1) -ne '#'}
    #PrintFunctionLog "[AddRemoveLists] Removed Comments" 

    # *** Setting-up each option
    foreach ($app in $appcfg) {
        #PrintFunctionLog "**** Processing $app"
        $app = $app.split("=")
        #PrintFunctionLog "Split: $app"
        $app = $app.trim()
        #PrintFunctionLog "Trim : $app"
        if ($app[1] -eq 0) {
            $remove += $app[0]
        }
        elseif ($app[1] -eq 1){
            $add += $app[0]
        }
        elseif ($app[1] -eq 2){
            $skip += $app[0]
        }
        else {
            $errinfo = $app[0]
            PrintError "$errinfo - Incorrect or empty switch in config file. Ignoring..."
        }
    }
    #PrintFunctionInfo "Add/Remove applications lists built..."
    #Write-Host "Remove length:" $remove.length
    #Write-Host "Add length:" $add.length
    #Write-Host "Skip length:" $skip.length
    #Write-Host "Remove list:" $remove
    #Write-Host "Add list:" $add
    #Write-Host "Skip list:" $skip
    return $remove, $add, $skip
}

# *** Uninstall / Remove Microsoft applications
Function UninstallApp($removeapps) {
    PrintFunctionInfo "Uninstalling Microsoft AppxPackages..."
    if ($removeapps.length -eq 0){
        PrintWarn "Uninstallation list is empty"
    }
    else {
        foreach ($app in $removeapps) {
            # Get system info if app is installed
            $isAppInstalled = Get-AppxPackage -Name $app | Format-Table -Property Name -HideTableHeaders | out-string
            # Remove whitespaces
            $isAppInstalled = $isAppInstalled | ForEach-Object { $_.Trim() }
            if ($isAppInstalled -ne $app){
                PrintWarn "$app not installed or not found. Skipping..."
            }
            else {
                PrintFunctionLog "Uninstalling $app"
                Get-AppxPackage $app | Remove-AppxPackage -AllUsers
            }
        }
    }
}

# *** Install / Add Microsoft applications
Function InstallApp($addapps) {
    PrintFunctionInfo "Installing Microsoft AppxPackages..."
    if ($addapps.length -eq 0){
        PrintWarn "Installation list is empty"
    }
    else {
        foreach ($app in $addapps) {
            # Get system info if app is installed
            $isAppInstalled = Get-AppxPackage -Name $app | Format-Table -Property Name -HideTableHeaders | out-string
            # Remove whitespaces
            $isAppInstalled = $isAppInstalled | ForEach-Object { $_.Trim() }
            if ($isAppInstalled -eq $app) {
                PrintWarn "$app application/package already installed. Skipping..."
            }
            else {
                PrintFunctionLog "Installing $app"
                Get-AppxPackage -AllUsers $app | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
            }
        }
    }
}

# Install/Uninstall main function
Function Applications($appcfgfile){  
    PrintFunctionInfo "Starting Applications installation/uninstallation..."
    $datetime = Get-Date -Format FileDateTime
    PrintFunctionInfo "Current Appx application list can be found in \log\AppListSnapshot-*-before.list"
    $appslistfile = "$PSScriptRoot\log\AppListSnapshot-$datetime-before.list"
    ListInstalledAppxPkgs($appslistfile)
    $removeapps, $addapps, $skipapps = AddRemoveLists($appcfgfile)
    #PrintFunctionInfo "AddRemoveLists Done"
    #Write-Host "Uninstallation list contain" ($removeapps.length) "items"
    #Write-Host "Installation list contain" ($addapps.length) "items"
    #Write-Host ($skipapps.length) "items will not be changed."
    UninstallApp($removeapps)
    #PrintFunctionLog "UninstallApp Done"
    InstallApp($addapps)
    #PrintFunctionLog "InstallApp Done"
    $datetime = Get-Date -Format FileDateTime
    $appslistfile = "$PSScriptRoot\log\AppListSnapshot-$datetime-after.list"
    ListInstalledAppxPkgs($appslistfile)
    PrintFunctionInfo "Any Appx applications that are still installed can be found in \log\AppListSnapshot-*-after.list"
    PrintFunctionInfo "Finished Applications installation/uninstallation..."
}


#########################
# Modules End
#########################

Export-ModuleMember -Function *