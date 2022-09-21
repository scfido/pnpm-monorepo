$rootDir = Resolve-Path ($PSScriptRoot + "/../")

function publish($packagePath) {
    Push-Location
    Set-Location "${packagePath}"
    . npm publish
    Pop-Location    
}

function publishAll() {
    $packages = Get-ChildItem $rootDir/packages/

    foreach ($package in $packages) {
        publish $package $version
    }
}

publishAll $version