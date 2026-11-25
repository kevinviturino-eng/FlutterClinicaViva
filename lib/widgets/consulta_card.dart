import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class ConsultaCard extends StatelessWidget {
  const ConsultaCard({super.key, required this.consulta, required this.onTap});
  final Consulta consulta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: AppTheme.border)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: AppTheme.pale, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                Text(formatarHora(consulta.horario), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                const SizedBox(height: 3),
                Text('${consulta.horario.day.toString().padLeft(2, '0')}/${consulta.horario.month.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(consulta.paciente, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text('${consulta.especialidade} · ${consulta.profissional}', style: const TextStyle(fontSize: 12, color: AppTheme.muted), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              StatusBadge(status: consulta.status),
            ])),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
          ]),
        ),
      ),
    );
  }
}
