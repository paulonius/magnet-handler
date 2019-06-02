$Root = 'http://localhost:9091/transmission'
$User = 'transmission'
$Pass = 'secretPassword'
$Rpc = $Root + '/rpc'
$SecPass = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($User, $SecPass)
$SessionId = ''

$Wshell = New-Object -ComObject Wscript.Shell

try {
	Invoke-WebRequest $Rpc -UseBasicParsing -Credential $Credential -TimeoutSec 2
} catch [System.Net.WebException] {
	Write-Verbose "An exception was caught: $($_.Exception.Message)"
    $ExceptionResponse = $_.Exception.Response
	$StatusCode = [int]$ExceptionResponse.StatusCode
    switch ($StatusCode) {
        409 { # Normal execution
            $SessionId = $ExceptionResponse.Headers.Item('X-Transmission-Session-Id')
        }
        default { # Somethings amiss
            $Wshell.Popup("Could not connect to Transmission on $Root", 0x10)
            Exit 1
        }
    }
}

try {
    $Body = @{
        method = 'torrent-add'
        arguments = @{
            filename = $args[0]
        }
    }
    $Headers = @{
        'X-Transmission-Session-Id' = $SessionId
    }
    $Json = $Body | ConvertTo-Json
    $Response = Invoke-RestMethod -Uri $Rpc -Method 'Post' -Credential $Credential -Headers $Headers -Body $Json
    if ($Response.result -eq 'success') {
        Exit 0
    } else {
        $Wshell.Popup("Error adding magnet link: $($Response.result)", 0x10)
        Exit 3
    }
} catch [System.Net.WebException] {
    $Wshell.Popup("Error adding magnet link $_.Exception.Message", 0x10)
    Exit 2
}