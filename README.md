Windows Configuration Script

Script functionality:
- Automated set-up of Windows Power Config.
- Automated installation/uninstallation of Windows Appx packages/applications.
- Automated Windows system/config tweaks. [NOT RELEASED YET]
- Computer rename option.

Script features:
- Separation of psm1 and config files per functionality (including auxiliary and script logic)
- New and tailor-made configuration files parsing and commands execution logic.
- Script logging and application snapshot features.
- Extended scripts comments and on-screen logging.
- Saparation of all path, dir, filename, modulename, dirname variables from script commands. Definable at the begging of the script.
- Pure powershell - no 3rd party modules needed.

Usage:
- Review and set all config files ('config' subfolder) for each functionality (power options, appx packages, tweaks)
- run script by executing 'winconfigscript.cmd' (WARNING: Be aware what each option from config files will do in your Windows System)


AUTHOR:
Michal Selma <michal@selma.cc>

CONTRIBIUTORS:
Disassembler <disassembler@dasm.cz> - inspiration and pieces of tweaks code



