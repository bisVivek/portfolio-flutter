param(
    [string]$BaseHref = "/"
)

if (-not $BaseHref.EndsWith("/")) {
    $BaseHref = "$BaseHref/"
}

Write-Host "Building Flutter web with base-href: $BaseHref"

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build web --release --base-href=$BaseHref
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Build complete! Upload contents of build/web/ to Hostinger public_html"
Write-Host "Path: $(Resolve-Path 'build/web')"
