enum StatusConsulta { agendada, realizada, cancelada }

extension StatusConsultaTexto on StatusConsulta {
  String get titulo => switch (this) {
    StatusConsulta.agendada => 'Agendada',
    StatusConsulta.realizada => 'Realizada',
    StatusConsulta.cancelada => 'Cancelada',
  };
}

/// Entidade principal do MVP. Os métodos retornam uma nova consulta para
/// que cada mudança de estado seja explícita e fácil de acompanhar.
class Consulta {
  final String id;
  final String paciente;
  final String profissional;
  final String especialidade;
  final DateTime horario;
  final StatusConsulta status;

  const Consulta({
    required this.id,
    required this.paciente,
    required this.profissional,
    required this.especialidade,
    required this.horario,
    this.status = StatusConsulta.agendada,
  });

  bool get podeAlterar => status == StatusConsulta.agendada;

  Consulta concluir() => _alterarStatus(StatusConsulta.realizada);
  Consulta cancelar() => _alterarStatus(StatusConsulta.cancelada);

  Consulta _alterarStatus(StatusConsulta novoStatus) {
    if (!podeAlterar) return this;
    return Consulta(id: id, paciente: paciente, profissional: profissional,
      especialidade: especialidade, horario: horario, status: novoStatus);
  }
}

String formatarData(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String formatarHora(DateTime d) => '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
bool mesmoDia(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

List<Consulta> consultasExemplo() {
  final hoje = DateTime.now();
  DateTime horario(int dia, int hora, [int minuto = 0]) =>
    DateTime(hoje.year, hoje.month, hoje.day + dia, hora, minuto);
  return [
    Consulta(id: 'demo-1', paciente: 'Mariana Lopes', profissional: 'Dra. Ana Ribeiro', especialidade: 'Clínica geral', horario: horario(0, 9), status: StatusConsulta.realizada),
    Consulta(id: 'demo-2', paciente: 'Rafael Mendes', profissional: 'Dr. Bruno Lima', especialidade: 'Cardiologia', horario: horario(0, 10, 30)),
    Consulta(id: 'demo-3', paciente: 'Camila Souza', profissional: 'Dra. Ana Ribeiro', especialidade: 'Clínica geral', horario: horario(0, 14)),
    Consulta(id: 'demo-4', paciente: 'Lucas Martins', profissional: 'Dra. Beatriz Alves', especialidade: 'Dermatologia', horario: horario(1, 9, 30)),
  ];
}
