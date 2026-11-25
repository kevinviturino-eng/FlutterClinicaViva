import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class ConsultaDetailScreen extends StatefulWidget {
  const ConsultaDetailScreen({super.key, required this.consulta, required this.onChanged});
  final Consulta consulta;
  final ValueChanged<Consulta> onChanged;

  @override
  State<ConsultaDetailScreen> createState() => _ConsultaDetailScreenState();
}

class _ConsultaDetailScreenState extends State<ConsultaDetailScreen> {
  late Consulta _consulta;

  @override
  void initState() {
    super.initState();
    _consulta = widget.consulta;
  }

  void _alterarStatus(Consulta nova) {
    // Atualiza esta tela e a agenda, inclusive ao voltar pelo botão do sistema.
    setState(() => _consulta = nova);
    widget.onChanged(nova);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Consulta ${nova.status.titulo.toLowerCase()}.')));
  }

  Future<void> _cancelar() async {
    final confirmado = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Cancelar consulta?'),
      content: const Text('O atendimento continuará na agenda com o status Cancelada.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Manter consulta')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sim, cancelar'))],
    ));
    if (!mounted || confirmado != true) return;
    _alterarStatus(_consulta.cancelar());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes da consulta', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
    body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 650), child: ListView(
      padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppTheme.border)), child: Column(children: [
          Container(width: 72, height: 72, decoration: BoxDecoration(color: AppTheme.pale, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.person_outline_rounded, size: 38, color: AppTheme.primary)),
          const SizedBox(height: 15),
          Text(_consulta.paciente, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 25)),
          const SizedBox(height: 4),
          const Text('Paciente', style: TextStyle(color: AppTheme.muted)),
          const SizedBox(height: 14),
          StatusBadge(status: _consulta.status),
        ])),
        const SizedBox(height: 24),
        Text('Informações do atendimento', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 13),
        Container(padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)), child: Column(children: [
          _info(Icons.medical_services_outlined, 'Profissional', _consulta.profissional),
          const Divider(height: 1, color: AppTheme.border),
          _info(Icons.health_and_safety_outlined, 'Especialidade', _consulta.especialidade),
          const Divider(height: 1, color: AppTheme.border),
          _info(Icons.calendar_today_outlined, 'Data', formatarData(_consulta.horario)),
          const Divider(height: 1, color: AppTheme.border),
          _info(Icons.schedule_rounded, 'Horário', formatarHora(_consulta.horario)),
        ])),
        const SizedBox(height: 24),
        if (_consulta.podeAlterar) ...[
          FilledButton.icon(onPressed: () => _alterarStatus(_consulta.concluir()), icon: const Icon(Icons.task_alt_rounded), label: const Text('Concluir consulta')),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: _cancelar, icon: const Icon(Icons.event_busy_outlined), label: const Text('Cancelar consulta'), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFA03D40))),
        ] else
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.pale, borderRadius: BorderRadius.circular(15)), child: Row(children: [
            Icon(_consulta.status == StatusConsulta.realizada ? Icons.check_circle_outline : Icons.info_outline, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(_consulta.status == StatusConsulta.realizada ? 'Atendimento concluído e atualizado na agenda.' : 'Atendimento cancelado e mantido no histórico.')),
          ])),
        const SizedBox(height: 12),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Voltar à agenda')),
      ],
    )))),
  );

  Widget _info(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14), child: Row(children: [
      Icon(icon, size: 23, color: AppTheme.primary), const SizedBox(width: 13),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)), const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ])),
    ]),
  );
}
