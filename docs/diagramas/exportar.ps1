# Regenera los .drawio.svg a partir de los .drawio de esta carpeta.
# Uso: ./exportar.ps1   (requiere draw.io Desktop)
param(
    [string]$DrawIo = "C:\Program Files\draw.io\draw.io.exe"
)

if (-not (Test-Path $DrawIo)) {
    Write-Error "No encuentro draw.io en '$DrawIo'. Pasa la ruta con -DrawIo."
    exit 1
}

foreach ($f in Get-ChildItem -Path $PSScriptRoot -Filter *.drawio) {
    $out = Join-Path $PSScriptRoot ($f.BaseName + ".drawio.svg")
    & $DrawIo -x -f svg -e --theme light --embed-svg-fonts false -b 10 -o $out $f.FullName | Out-Null
    Write-Host "OK  $($f.Name) -> $($f.BaseName).drawio.svg"
}
