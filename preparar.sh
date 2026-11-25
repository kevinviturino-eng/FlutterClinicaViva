#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
command -v flutter >/dev/null || { echo 'Instale o Flutter e configure o PATH.' >&2; exit 1; }
flutter create --platforms=android,web --org br.com.clinicaviva --project-name clinica_agenda .
flutter pub get
