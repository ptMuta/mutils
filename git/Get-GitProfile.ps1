param(
    [Parameter(Position = 0)]
    [string]
    $ProfileName = $null
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

if ($ProfileName) {
    if (-not $profiles.ContainsKey($ProfileName)) {
        Write-Error "Profile ""$ProfileName"" doesn't exist!"
        Exit 1
    }

    $profiles[$ProfileName]
} else {
    foreach ($profile in $profiles) {
        $profile
    }
}
