function Add-GitProfile {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $ProfileName,

        [Parameter(Mandatory = $true)]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [string]
        $Email,

        [string]
        $SigningKey = $null
    )

    $mutilsDataRoot = "$env:APPDATA\mutils"
    $profileData = "$mutilsDataRoot\git-profile.dat"

    if (-not [System.IO.Directory]::Exists($mutilsDataRoot)) {
        Write-Debug "Creating mutils data directory"
        New-Item -Path $mutilsDataRoot -ItemType Directory | Out-Null
    }

    if ([System.IO.File]::Exists($profileData)) {
        Write-Debug "Importing git profiles"
        $profile = Import-Clixml $profileData
    }
    else {
        $profile = @{}
    }

    if ($profile.ContainsKey($ProfileName)) {
        Write-Error "Profile already exists"
        Exit 1
    }

    $profile[$ProfileName] = @{
        DisplayName = $DisplayName;
        Email       = $Email;
        SigningKey  = $SigningKey;
    }

    $profile | Export-Clixml -Path $profileData
    Write-Host "New profile ""$ProfileName"" added!"
}
