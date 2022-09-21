# 按此顺序编译

$packages = @(
    "libA",
    "libB",
    "libC"
)

$rootDir = Resolve-Path ($PSScriptRoot + "/../")

function build($packages) {
    Push-Location
    Set-Location "${rootDir}packages\$package"
    . pnpm build
    Pop-Location    
}

function buildAll() {
    foreach ($package in $packages) {
        build($package)
    }
}

buildAll