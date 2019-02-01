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
} else {
    $profile = @{}
}

if (-not $profile.ContainsKey($ProfileName)) {
    Write-Error "Profile ""$ProfileName"" doesn't exist!"
    Exit 1
}

$profile[$ProfileName]["DisplayName"] = $DisplayName;
$profile[$ProfileName]["Email"] = $Email;
$profile[$ProfileName]["SigningKey"] = $SigningKey;

$profile | Export-Clixml -Path $profileData
Write-Host "Profile ""$ProfileName"" updated!"
