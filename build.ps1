[CmdletBinding()]
param (
    [Parameter(Position = 0, Mandatory = $False)]
    [ValidateSet('Clean', 'Analyze', 'Build', 'Test', 'Install')]
    $Task,

    [Parameter(Position = 1, Mandatory = $False)]
    [string]$OutputDir,

    [Parameter(Mandatory = $False)]
    [string]$ModuleDir
)

begin {
    if (-not (Get-Command 'Invoke-Build' -ErrorAction SilentlyContinue)) {
        $tools = Join-Path $PsScriptRoot '.tools'
        New-Item $tools -ItemType Directory -Force | Out-Null
        $oldModulePath = $env:PSModulePath
        $env:PSModulePath += ";$tools"
        try {
            if (-not (Test-Path (Join-Path $tools InvokeBuild))) {
                Save-Module -Name InvokeBuild -Path $tools
            }
            Write-Host "Importing InvokeBuild"
            Import-Module InvokeBuild
        }
        finally {
            $env:PSModulePath = $oldModulePath
        }
    }
}

process {
    Push-Location $PsScriptRoot
    try {
        Invoke-Build @PSBoundParameters
    }
    finally {
        Pop-Location
    }
}

end {
}
