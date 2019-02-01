param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]
    $ProfileName
)

$mutilsDataRoot = "$env:APPDATA\mutils"
$profileData = "$mutilsDataRoot\git-profile.dat"

if (-not [System.IO.Directory]::Exists($mutilsDataRoot)) {
    Write-Debug "Creating mutils data directory"
    New-Item -Path $mutilsDataRoot -ItemType Directory | Out-Null
}

if ([System.IO.File]::Exists($profileData)) {
    Write-Debug "Importing git profiles"
    $profiles = Import-Clixml $profileData
} else {
    $profiles = @{}
}

if ($profiles.Keys.Count -eq 0) {
    Write-Host "No git profiles defined yet"
    Exit 1
}

if (-not $profiles.ContainsKey($ProfileName)) {
    Write-Error "Profile ""$ProfileName"" doesn't exist!"
    Exit 1
}

git config --local user.name $profiles[$ProfileName]["DisplayName"]
git config --local user.email $profiles[$ProfileName]["Email"]
git config --local user.signingkey $profiles[$ProfileName]["SigningKey"]
