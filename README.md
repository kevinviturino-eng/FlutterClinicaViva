# Clínica Viva

App de agenda de consultas feito em Flutter e Dart para a disciplina de Desenvolvimento para Dispositivos Móveis. É um MVP acadêmico: serve para mostrar o que aprendemos, não para uso real em clínica.

## Quem fez

- [Nome do integrante 1]
- [Nome do integrante 2]
- [Nome do integrante 3]
- [Nome do integrante 4]

## A ideia

Em clínicas pequenas, é comum a agenda ficar espalhada em caderno, papelzinho e mensagem de WhatsApp. A gente quis criar algo simples para a recepção cadastrar uma consulta, ver os dados do atendimento e marcar quando ela foi concluída ou cancelada.

**Quem usaria:** recepcionistas e pessoal administrativo de clínicas pequenas.

## O que o app faz

- Mostra uma agenda com quatro consultas de exemplo, ordenadas por data e hora.
- Tem um painel com o número de consultas do dia, agendadas e realizadas.
- Permite filtrar a lista por status.
- Tem um formulário de nova consulta (paciente, profissional, especialidade, data e horário), com validação dos campos e exigência de data e hora no futuro.
- Tem uma tela de detalhes, onde dá para concluir ou cancelar a consulta (o cancelamento pede confirmação).
- Atualiza a agenda na hora, depois de cadastrar ou mudar o status.

Algumas limitações, para ficar claro: os dados ficam só na memória e somem quando o app é fechado de vez. Não tem banco de dados, servidor, login, prontuário nem checagem de conflito de horário. Todos os dados são fictícios. O visual usa Material 3.

## Como rodar

### O que você precisa ter instalado

- Flutter estável (usamos a versão 3.27 ou mais nova, com Dart 3.6+)
- Git
- Para Android: Android Studio, Android SDK, JDK 17 (ou o que o seu Flutter/Gradle pedir) e um emulador ou celular com depuração USB
- Para web: Chrome

Para conferir se está tudo certo:

```bash
flutter --version
flutter doctor -v
```

### 1. Preparar o projeto (só na primeira vez)

Abra o terminal na pasta `clinica_agenda`, onde fica o `pubspec.yaml`. O projeto vem com o código Dart, as dependências e os testes. As pastas nativas de Android e web precisam ser geradas pelo Flutter da sua máquina, para não dar conflito de versão com o Gradle e o SDK:

```bash
flutter create --platforms=android,web --org br.com.clinicaviva --project-name clinica_agenda .
flutter pub get
```

Não use `--overwrite`, senão você perde o código que já está lá. Sem essa opção, o `flutter create` só completa o que estiver faltando. Se ele gerar algum arquivo de exemplo a mais, fique com o `lib/main.dart` e o teste que já vieram no projeto.

No Windows, dá para rodar o script pelo PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\preparar.ps1
```

### 2. Executar

No Android, se o `flutter doctor` pedir, aceite as licenças:

```bash
flutter doctor --android-licenses
flutter devices
flutter run
```

Se tiver mais de um dispositivo conectado, escolha um com `flutter run -d ID_DO_DISPOSITIVO` (o ID aparece no `flutter devices`).

Para abrir no navegador:

```bash
flutter run -d chrome
```

### 3. Gerar o APK

```bash
flutter build apk --release
```

O arquivo fica em `build/app/outputs/flutter-apk/app-release.apk`. Para instalar, é só passar o APK para o celular ou usar `flutter install` com o aparelho conectado. Esse APK usa a assinatura padrão do Flutter, então serve para demonstração, mas não para publicar em loja.

Versão web:

```bash
flutter build web
```

Os arquivos saem em `build/web/`.

### 4. Formatar, analisar e testar

```bash
dart format lib test
flutter analyze
flutter test
```

Os testes cobrem a mudança de status, a rejeição de um formulário vazio e a atualização da agenda depois de concluir um atendimento.

## Organização das pastas

```text
lib/
├── main.dart                       # Início do app e idioma pt-BR
├── models/
│   └── consulta.dart               # Classe Consulta, enum de status e exemplos
├── screens/
│   ├── agenda_screen.dart          # Lista, filtros e indicadores
│   ├── consulta_form_screen.dart   # Formulário e validação
│   └── consulta_detail_screen.dart # Detalhes e mudança de status
├── theme/
│   └── app_theme.dart              # Cores e tema Material 3
└── widgets/
    ├── consulta_card.dart          # Card de consulta reutilizável
    └── status_badge.dart           # Etiqueta de status reutilizável
test/
└── widget_test.dart
```

## O que a atividade pedia e onde está no app

| Requisito | Onde aparece |
| --- | --- |
| Pelo menos três telas | Agenda, nova consulta e detalhes |
| Navigator e passagem de dados | `Navigator.push<Consulta>`, `Navigator.pop(context, consulta)` e o construtor da `ConsultaDetailScreen` |
| Container, Row, Column, Padding, Center, Expanded | Usados nas telas e nos widgets reutilizáveis |
| Formulário com pelo menos 3 campos | Cinco campos, com `Form`, `TextFormField`, controllers e validação |
| StatefulWidget e `setState()` | Agenda, formulário e detalhes (filtros, cadastro e troca de status) |
| Dart e POO | Classe `Consulta` com construtor, atributos e os métodos `concluir()` e `cancelar()`, mais o enum `StatusConsulta` |
| Organização do código | Pastas separadas por função e widgets reutilizáveis |
| GitHub | Código, README e instruções neste repositório |

## Roteiro para a demonstração

1. Apresentar o problema e o público, e mostrar a agenda com os indicadores.
2. Abrir "Nova consulta" e tentar salvar vazio: o formulário não deixa.
3. Preencher os cinco campos com data e horário futuros, salvar e conferir os dados na tela de detalhes.
4. Concluir a consulta e mostrar o status mudando de Agendada para Realizada.
5. Voltar para a agenda, ver os indicadores atualizados e usar o filtro Realizada.
6. Abrir uma consulta agendada e cancelar, mostrando também a opção de desistir do cancelamento.
7. Explicar no código a classe `Consulta` e os métodos `_salvar()`, `_novaConsulta()`, `_abrirDetalhes()` e `_alterarStatus()`.
