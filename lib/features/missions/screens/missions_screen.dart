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
        if (mission.status == MissionStatus.completada)
          Row(children: [const Icon(Icons.check_circle, color: AppColors.success, size: 18), const SizedBox(width: 6),
            Text('Completada', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success))]),
      ]),
    );
  }
}
