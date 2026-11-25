$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter não encontrado. Instale o SDK e adicione flutter/bin ao PATH.'
}
flutter create --platforms=android,web --org br.com.clinicaviva --project-name clinica_agenda .
if ($LASTEXITCODE -ne 0) { throw 'Falha ao preparar as plataformas.' }
flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'Falha ao resolver as dependências.' }
Write-Host 'Projeto preparado. Execute flutter run ou flutter build apk --release.'
