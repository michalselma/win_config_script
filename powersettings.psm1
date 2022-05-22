#########################
# Set Power Config Options based on preset file
#########################

Function PowerSettings($preset) {
    PrintFunctionInfo "Starting PowerSettings function..."
    $pwrsettings = @()

    # *** Get config content and remove whitespaces at beggining and end of each object
    $pwrsettings = Get-Content $preset -ErrorAction Stop | ForEach-Object { $_.Trim() }
    #PrintFunctionLog "[pwrsettings] Loaded config content and trimmed whitespaces" 

    # *** Remove Empty lines/objects
    $pwrsettings = $pwrsettings | Where-Object {$_}
    #PrintFunctionLog "[pwrsettings] Removed Empty Lines/Objects" 

    # *** Remove comments
    $pwrsettings = $pwrsettings | Where-Object { $_.Substring(0,1) -ne '#'}
    #PrintFunctionLog "[pwrsettings] Removed Comments" 

    # *** Setting-up each option
    foreach ($option in $pwrsettings) {
        #PrintFunctionInfo "**** Processing $option"
        $option = $option.split("=")
        #PrintFunctionLog "Split: $option"
        $option = $option.trim()
        #PrintFunctionLog "Trim : $option"
        $key=$option[0]
        $value=$option[1]
        PrintFunctionLog "Setting power config $key to $value minutes"
        powercfg /X $option[0] $option[1]
    }
    PrintFunctionInfo "Finished PowerSettings function..."
}

#########################
# Modules End
#########################

Export-ModuleMember -Function *