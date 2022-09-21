
param($version)

if (!$version) {
    $version = Read-Host "请输入新的版本号"
}

$rootDir = Resolve-Path ($PSScriptRoot + "/../")


function setVersion($packagePath, $version) {
    Push-Location
    Set-Location "${packagePath}"
    Write-Host "Set package '$($packagePath.Name)' version $version"
    . npm version $version -m "build: release %s"
    Pop-Location    
}

function setAll($version) {
    $packages = Get-ChildItem $rootDir/packages/

    foreach ($package in $packages) {
        setVersion $package $version
    }
}

setAll $version