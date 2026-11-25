import 'package:clinica_agenda/main.dart';
import 'package:clinica_agenda/models/consulta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder verticalScroll() => find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).first;

void main() {
  test('Uma consulta pode ser concluída ou cancelada, mas não reaberta', () {
    final consulta = Consulta(id: '1', paciente: 'Paciente Teste', profissional: 'Dra. Teste', especialidade: 'Clínica geral', horario: DateTime(2030));
    expect(consulta.status, StatusConsulta.agendada);
    expect(consulta.concluir().status, StatusConsulta.realizada);
    expect(consulta.cancelar().status, StatusConsulta.cancelada);
    expect(consulta.concluir().cancelar().status, StatusConsulta.realizada);
  });

  testWidgets('Formulário vazio não permite salvar', (tester) async {
    await tester.pumpWidget(const ClinicaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nova consulta'));
    await tester.pumpAndSettle();
    final salvar = find.text('Salvar consulta');
    await tester.scrollUntilVisible(salvar, 200, scrollable: verticalScroll());
    await tester.tap(salvar);
    await tester.pumpAndSettle();
    expect(find.text('Nova consulta'), findsOneWidget);
    expect(find.text('Selecione horário.'), findsOneWidget);
    expect(find.text('Detalhes da consulta'), findsNothing);
  });

  testWidgets('Concluir atendimento atualiza a agenda', (tester) async {
    await tester.pumpWidget(const ClinicaApp());
    await tester.pumpAndSettle();
    final paciente = find.text('Rafael Mendes');
    await tester.scrollUntilVisible(paciente, 220, scrollable: verticalScroll());
    await tester.tap(paciente);
    await tester.pumpAndSettle();
    final concluir = find.text('Concluir consulta');
    await tester.scrollUntilVisible(concluir, 200, scrollable: verticalScroll());
    await tester.tap(concluir);
    await tester.pumpAndSettle();
    expect(find.text('Realizada'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(paciente, 180, scrollable: verticalScroll());
    final card = find.ancestor(of: paciente, matching: find.byType(InkWell)).first;
    expect(find.descendant(of: card, matching: find.text('Realizada')), findsOneWidget);
  });
}
