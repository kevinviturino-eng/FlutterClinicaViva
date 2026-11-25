import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../theme/app_theme.dart';

class ConsultaFormScreen extends StatefulWidget {
  const ConsultaFormScreen({super.key});
  @override
  State<ConsultaFormScreen> createState() => _ConsultaFormScreenState();
}

class _ConsultaFormScreenState extends State<ConsultaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _paciente = TextEditingController();
  final _profissional = TextEditingController();
  final _especialidade = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  DateTime? _data;
  TimeOfDay? _hora;

  @override
  void dispose() {
    _paciente.dispose(); _profissional.dispose(); _especialidade.dispose();
    _dataController.dispose(); _horaController.dispose();
    super.dispose();
  }

  String? _validarTexto(String? value) {
    if (value == null || value.trim().length < 3) return 'Informe pelo menos 3 caracteres.';
    return null;
  }

  Future<void> _escolherData() async {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final data = await showDatePicker(context: context,
      initialDate: _data != null && !_data!.isBefore(hoje) ? _data! : hoje,
      firstDate: hoje, lastDate: DateTime(hoje.year + 2, hoje.month, hoje.day));
    if (!mounted || data == null) return;
    setState(() { _data = data; _dataController.text = formatarData(data); });
  }

  Future<void> _escolherHora() async {
    final hora = await showTimePicker(context: context, initialTime: _hora ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!));
    if (!mounted || hora == null) return;
    setState(() {
      _hora = hora;
      _horaController.text = '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
    });
  }

  void _salvar() {
    FocusScope.of(context).unfocus();
    // Nenhum objeto é criado antes de todos os campos serem validados.
    if (!_formKey.currentState!.validate()) return;
    final horario = DateTime(_data!.year, _data!.month, _data!.day, _hora!.hour, _hora!.minute);
    if (horario.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escolha uma data e hora futuras.')));
      return;
    }
    final consulta = Consulta(id: DateTime.now().microsecondsSinceEpoch.toString(),
      paciente: _paciente.text.trim(), profissional: _profissional.text.trim(),
      especialidade: _especialidade.text.trim(), horario: horario);
    Navigator.pop(context, consulta);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nova consulta', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
    body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 650), child: Form(
      key: _formKey, autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: AppTheme.pale, borderRadius: BorderRadius.circular(18)),
          child: const Row(children: [Icon(Icons.event_available_outlined, color: AppTheme.primary, size: 31), SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Agende um atendimento', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Preencha os dados abaixo para reservar um horário.', style: TextStyle(color: AppTheme.muted, fontSize: 13))]))])),
        const SizedBox(height: 25),
        Text('Dados do atendimento', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _campo('Paciente', _paciente, Icons.person_outline, 'Nome completo'),
        _campo('Profissional', _profissional, Icons.medical_services_outlined, 'Nome do profissional'),
        _campo('Especialidade', _especialidade, Icons.health_and_safety_outlined, 'Ex.: Clínica geral'),
        const SizedBox(height: 8),
        Text('Data e horário', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _seletor('Data', _dataController, Icons.calendar_today_outlined, 'Selecionar data', _escolherData),
        _seletor('Horário', _horaController, Icons.schedule_rounded, 'Selecionar horário', _escolherHora),
        const SizedBox(height: 10),
        const Text('Todos os campos são obrigatórios.', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: _salvar, icon: const Icon(Icons.check_rounded), label: const Text('Salvar consulta')),
      ])),
    )))),
  );

  Widget _campo(String label, TextEditingController controller, IconData icon, String hint) => Padding(
    padding: const EdgeInsets.only(bottom: 16), child: TextFormField(
      controller: controller, textCapitalization: TextCapitalization.words, textInputAction: TextInputAction.next,
      maxLength: 80, decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon), counterText: ''), validator: _validarTexto,
    ),
  );

  Widget _seletor(String label, TextEditingController controller, IconData icon, String hint, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 16), child: TextFormField(
      controller: controller, readOnly: true, onTap: onTap,
      decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon), suffixIcon: const Icon(Icons.expand_more_rounded)),
      validator: (value) => value == null || value.isEmpty ? 'Selecione ${label.toLowerCase()}.' : null,
    ),
  );
}
