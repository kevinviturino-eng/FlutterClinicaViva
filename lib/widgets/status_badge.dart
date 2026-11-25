import 'package:flutter/material.dart';
import '../models/consulta.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final StatusConsulta status;

  @override
  Widget build(BuildContext context) {
    final (foreground, background) = switch (status) {
      StatusConsulta.agendada => (const Color(0xFF795518), const Color(0xFFFFF1D8)),
      StatusConsulta.realizada => (const Color(0xFF146B60), const Color(0xFFE1F3E9)),
      StatusConsulta.cancelada => (const Color(0xFFA03D40), const Color(0xFFFBE8E8)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: foreground, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(status.titulo, style: TextStyle(color: foreground, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
