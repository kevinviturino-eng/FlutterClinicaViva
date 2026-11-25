import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../theme/app_theme.dart';
import '../widgets/consulta_card.dart';
import 'consulta_form_screen.dart';
import 'consulta_detail_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final List<Consulta> _consultas = consultasExemplo();
  StatusConsulta? _filtro;

  int _contar(StatusConsulta status) => _consultas.where((c) => c.status == status).length;

  List<Consulta> get _visiveis => _consultas
      .where((c) => _filtro == null || c.status == _filtro)
      .toList()..sort((a, b) => a.horario.compareTo(b.horario));

  Future<void> _novaConsulta() async {
    // A tela de formulário devolve uma Consulta pelo Navigator.pop.
    final consulta = await Navigator.push<Consulta>(context,
      MaterialPageRoute(builder: (_) => const ConsultaFormScreen()));
    if (!mounted || consulta == null) return;
    setState(() { _consultas.add(consulta); _filtro = null; });
    _abrirDetalhes(consulta);
  }

  void _atualizarConsulta(Consulta atualizada) {
    final indice = _consultas.indexWhere((c) => c.id == atualizada.id);
    if (indice == -1) return;
    setState(() => _consultas[indice] = atualizada);
  }

  void _abrirDetalhes(Consulta consulta) {
    // O objeto selecionado é passado pelo construtor da terceira tela.
    Navigator.push<void>(context, MaterialPageRoute(builder: (_) =>
      ConsultaDetailScreen(consulta: consulta, onChanged: _atualizarConsulta)));
  }

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final totalHoje = _consultas.where((c) => mesmoDia(c.horario, hoje) && c.status != StatusConsulta.cancelada).length;
    final visiveis = _visiveis;
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(13)),
            child: const Icon(Icons.medical_services_outlined, color: Colors.white, size: 23)),
          const SizedBox(width: 11),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('clínica viva', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.8)),
            Text('GESTÃO DE CONSULTAS', style: TextStyle(fontSize: 9, letterSpacing: 1.4, color: AppTheme.muted, fontWeight: FontWeight.w700)),
          ]),
        ]),
        actions: [Padding(padding: const EdgeInsets.only(right: 18), child: Container(
          width: 38, height: 38, decoration: const BoxDecoration(color: AppTheme.pale, shape: BoxShape.circle),
          child: const Icon(Icons.person_outline_rounded, color: AppTheme.primary)))],
      ),
      body: SafeArea(
        child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), children: [
            Text('Sua agenda', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 5),
            const Text('Organize seus atendimentos em um só lugar.', style: TextStyle(color: AppTheme.muted)),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF135D55), Color(0xFF218374)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(23)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('HOJE  •  ${formatarData(hoje)}', style: const TextStyle(color: Color(0xFFC7EBE2), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                  const SizedBox(height: 9),
                  Text('$totalHoje', style: const TextStyle(color: Colors.white, fontSize: 42, height: 1.1, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  const Text('Consultas do dia', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                ])),
                Container(width: 66, height: 66, decoration: BoxDecoration(color: const Color(0xFF398F81), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 36)),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _Indicador(label: 'Agendadas', value: _contar(StatusConsulta.agendada), icon: Icons.schedule_rounded, color: AppTheme.primary)),
              const SizedBox(width: 10),
              Expanded(child: _Indicador(label: 'Realizadas', value: _contar(StatusConsulta.realizada), icon: Icons.task_alt_rounded, color: const Color(0xFF43856B))),
            ]),
            const SizedBox(height: 25),
            Row(children: [Expanded(child: Text('Consultas', style: Theme.of(context).textTheme.titleLarge)),
              Text('${visiveis.length} registros', style: const TextStyle(color: AppTheme.muted, fontSize: 12))]),
            const SizedBox(height: 12),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
              _chip('Todas', null),
              ...StatusConsulta.values.map((s) => Padding(padding: const EdgeInsets.only(left: 7), child: _chip(s.titulo, s))),
            ])),
            const SizedBox(height: 12),
            if (visiveis.isEmpty)
              Container(padding: const EdgeInsets.all(26), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: const Center(child: Column(children: [Icon(Icons.event_busy_outlined, size: 36, color: AppTheme.muted), SizedBox(height: 10), Text('Nenhuma consulta neste filtro.')])))
            else
              ...visiveis.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: ConsultaCard(consulta: c, onTap: () => _abrirDetalhes(c)))),
          ]),
        )),
      ),
      bottomNavigationBar: SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 14), child: Center(heightFactor: 1, child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 610), child: SizedBox(width: double.infinity,
        child: FilledButton.icon(onPressed: _novaConsulta, icon: const Icon(Icons.add_rounded), label: const Text('Nova consulta'))))))),
    );
  }

  Widget _chip(String label, StatusConsulta? status) => ChoiceChip(
    label: Text(label), selected: _filtro == status,
    showCheckmark: false, selectedColor: AppTheme.pale, backgroundColor: Colors.white,
    side: BorderSide(color: _filtro == status ? AppTheme.primary : AppTheme.border),
    labelStyle: TextStyle(fontSize: 12, fontWeight: _filtro == status ? FontWeight.w700 : FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    onSelected: (_) => setState(() => _filtro = status),
  );
}

class _Indicador extends StatelessWidget {
  const _Indicador({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppTheme.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 8),
      Text('$value', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, height: 1.1)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
    ]),
  );
}
