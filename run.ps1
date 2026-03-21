# run.ps1
# Centralized task runner for RessurectionSayings.
#
# Usage:
#   .\run.ps1 lint       - Static analysis (luacheck)
#   .\run.ps1 test       - Run test suite (busted)
#   .\run.ps1 coverage   - Run tests with coverage report (busted + luacov)
#   .\run.ps1 export     - Package addon as a zip
#   .\run.ps1 all        - lint + test
#   .\run.ps1            - Show this help

param(
    [Parameter(Position = 0)]
    [string]$Task = "help"
)

Set-Location $PSScriptRoot

# Ensure Scoop shims and LuaRocks bins are on PATH even when launched from VS Code tasks.
$scoopShims   = "$env:USERPROFILE\scoop\shims"
$luaRocksBin  = "$env:USERPROFILE\scoop\apps\luarocks\current\rocks\bin"
foreach ($p in @($scoopShims, $luaRocksBin)) {
    if ((Test-Path $p) -and ($env:PATH -notlike "*$p*")) {
        $env:PATH = "$p;$env:PATH"
    }
}

# Set LUA_PATH / LUA_CPATH so that lua.exe can find LuaRocks-installed modules (e.g. luacov).
$lrPath = luarocks path 2>$null
if ($lrPath) {
    $lrPath | ForEach-Object {
        if ($_ -match 'SET "LUA_PATH=(.+)"')  { $env:LUA_PATH  = $Matches[1] }
        if ($_ -match 'SET "LUA_CPATH=(.+)"') { $env:LUA_CPATH = $Matches[1] }
    }
}

$Divider = "-" * 60

function Write-Header([string]$msg) {
    Write-Host ""
    Write-Host $Divider -ForegroundColor Cyan
    Write-Host "  $msg" -ForegroundColor Cyan
    Write-Host $Divider -ForegroundColor Cyan
}

function Invoke-Lint {
    Write-Header "LINT  (luacheck)"
    luacheck .
    return $LASTEXITCODE
}

function Invoke-Test {
    Write-Header "TEST  (busted)"
    busted
    return $LASTEXITCODE
}

function Invoke-Coverage {
    Write-Header "COVERAGE  (busted + luacov)"

    # Remove previous stats so they don't accumulate.
    Remove-Item -ErrorAction SilentlyContinue luacov.stats.out, luacov.report.out

    busted --coverage
    $testExit = $LASTEXITCODE

    Write-Header "Generating coverage report..."
    lua -e "require('luacov.reporter').report()"

    if (Test-Path luacov.report.out) {
        Write-Host ""
        Get-Content luacov.report.out
    } else {
        Write-Warning "luacov.report.out was not generated."
    }

    return $testExit
}

function Invoke-Export {
    Write-Header "EXPORT"
    & "$PSScriptRoot\export.ps1"
    return $LASTEXITCODE
}

function Show-Help {
    Write-Host ""
    Write-Host "RessurectionSayings task runner" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  .\run.ps1 lint       Static analysis with luacheck"
    Write-Host "  .\run.ps1 test       Run test suite with busted"
    Write-Host "  .\run.ps1 coverage   Tests + luacov coverage report"
    Write-Host "  .\run.ps1 export     Package addon into a .zip"
    Write-Host "  .\run.ps1 all        lint + test"
    Write-Host ""
}

$exitCode = 0

switch ($Task.ToLower()) {
    "lint"     { $exitCode = Invoke-Lint }
    "test"     { $exitCode = Invoke-Test }
    "coverage" { $exitCode = Invoke-Coverage }
    "export"   { $exitCode = Invoke-Export }
    "all" {
        $exitCode = Invoke-Lint
        if ($exitCode -eq 0) {
            $exitCode = Invoke-Test
        } else {
            Write-Host ""
            Write-Warning "Lint failed - skipping tests."
        }
    }
    default    { Show-Help }
}

exit $exitCode
