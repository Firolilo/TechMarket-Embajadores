import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/mission.dart';
import '../providers/mission_provider.dart';

/// PANTALLA 9 – Misiones de Valor.
class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});
  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MissionProvider>().loadMissions());
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MissionProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Misiones de valor', style: AppTextStyles.heading2),
              const SizedBox(height: 4),
              Text('Acciones recomendadas para generar impacto', style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              Text('Las misiones son opcionales.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
            ])),
          const SizedBox(height: 12),
          TabBar(controller: _tabCtrl, tabs: [
            Tab(text: 'Disponibles (${prov.availableMissions.length})'),
            Tab(text: 'En progreso (${prov.inProgressMissions.length})'),
            Tab(text: 'Completadas (${prov.completedMissions.length})'),
          ]),
          Expanded(child: prov.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : TabBarView(controller: _tabCtrl, children: [
                  _MissionList(missions: prov.availableMissions),
                  _MissionList(missions: prov.inProgressMissions),
                  _MissionList(missions: prov.completedMissions),
                ])),
        ])),
      ),
    );
  }
}

class _MissionList extends StatelessWidget {
  final List<Mission> missions;
  const _MissionList({required this.missions});
  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.assignment_outlined, size: 48, color: AppColors.textTertiary),
        const SizedBox(height: 12),
        Text('Sin misiones en esta categoría', style: AppTextStyles.bodyMedium),
      ]));
    }
    return ListView.builder(padding: const EdgeInsets.all(20), itemCount: missions.length,
      itemBuilder: (_, i) => _MissionCard(mission: missions[i]));
  }
}

class _MissionCard extends StatelessWidget {
  final Mission mission;
  const _MissionCard({required this.mission});

  Color get _prioColor => mission.priority == MissionPriority.alta ? AppColors.warning : AppColors.info;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(18),
      decoration: AppDecorations.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(mission.type.icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(child: Text(mission.title, style: AppTextStyles.heading4)),
          if (mission.priority == MissionPriority.alta) StatChip(label: 'Alta', color: _prioColor),
        ]),
        const SizedBox(height: 10),
        Text(mission.description, style: AppTextStyles.bodySmall),
        const SizedBox(height: 8),
        Text('Beneficio: ${mission.benefit}', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
        if (mission.progress != null && mission.progress! > 0) ...[
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: mission.progress!, backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(mission.status == MissionStatus.completada ? AppColors.success : AppColors.primary), minHeight: 6)),
          const SizedBox(height: 4),
          Text('${(mission.progress! * 100).toInt()}% completado', style: AppTextStyles.caption),
        ],
        const SizedBox(height: 10),
        if (mission.status == MissionStatus.disponible)
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {},
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
            child: const Text('Marcar como iniciada'))),
        if (mission.status == MissionStatus.enProgreso)
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {},
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.success)),
              child: const Text('Marcar como completada'))),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () => _showDetail(context),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border)),
              child: const Text('Ver detalle')),
          ]),
        if (mission.status == MissionStatus.completada)
          Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 18), const SizedBox(width: 6),
            Text('Completada', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success))]),
      ]),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
        builder: (_, scrollCtrl) => ListView(controller: scrollCtrl, padding: const EdgeInsets.all(24), children: [
          Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: AppColors.textTertiary, borderRadius: BorderRadius.circular(2)))),
          Text(mission.title, style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text(mission.description, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          Text('Pasos sugeridos', style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          ...mission.steps.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 24, height: 24, margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                child: Center(child: Text('${e.key + 1}', style: AppTextStyles.caption.copyWith(color: AppColors.primary)))),
              Expanded(child: Text(e.value, style: AppTextStyles.bodySmall)),
            ]))),
          const SizedBox(height: 16),
          Text('Criterios de completitud', style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(12), decoration: AppDecorations.cardFlat(),
            child: Row(children: [
              const Icon(Icons.flag_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(mission.completionCriteria, style: AppTextStyles.bodySmall)),
            ])),
          if (mission.progress != null) ...[
            const SizedBox(height: 16),
            Text('Progreso', style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: mission.progress!, backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 8)),
            const SizedBox(height: 4),
            Text('${(mission.progress! * 100).toInt()}% completado', style: AppTextStyles.caption),
          ],
          const SizedBox(height: 20),
          Text('Completar misiones no garantiza ingresos.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          Text('Las misiones ayudan a mejorar el impacto del ecosistema.', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
        ]),
      ),
    );
  }
}
