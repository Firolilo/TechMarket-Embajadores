import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/opportunity.dart';
import '../providers/opportunity_provider.dart';

/// PANTALLA 8 – Oportunidades Detectadas (IA).
class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});
  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<OpportunityProvider>().loadOpportunities());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OpportunityProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Oportunidades detectadas', style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text('Sugerencias basadas en datos del ecosistema', style: AppTextStyles.bodySmall),
                const SizedBox(height: 14),
                SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _Chip(label: 'Todas', selected: prov.filterType == null, onTap: () => prov.setTypeFilter(null)),
                    ...OpportunityType.values.map((t) => Padding(padding: const EdgeInsets.only(left: 8),
                      child: _Chip(label: t.displayName, selected: prov.filterType == t, onTap: () => prov.setTypeFilter(t)))),
                  ])),
                const SizedBox(height: 10),
              ])),
            Expanded(
              child: prov.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : prov.opportunities.isEmpty
                      ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('Sin oportunidades disponibles', style: AppTextStyles.bodyMedium),
                        ]))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: prov.opportunities.length,
                          itemBuilder: (_, i) => _OppCard(opp: prov.opportunities[i])),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final bool selected; final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border)),
      child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: selected ? AppColors.primary : AppColors.textSecondary)),
    ));
  }
}

class _OppCard extends StatelessWidget {
  final Opportunity opp;
  const _OppCard({required this.opp});

  Color get _potColor {
    switch (opp.potential) {
      case OpportunityPotential.alto: return AppColors.success;
      case OpportunityPotential.medio: return AppColors.warning;
      case OpportunityPotential.bajo: return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(opp.type.icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(child: Text(opp.zone, style: AppTextStyles.labelLarge)),
          StatChip(label: opp.potential.displayName, color: _potColor),
        ]),
        const SizedBox(height: 10),
        Text(opp.description, style: AppTextStyles.bodySmall),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.auto_awesome, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          Text(opp.dataSource, style: AppTextStyles.caption),
          const Spacer(),
          StatChip(label: opp.status.displayName, color: AppColors.info),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton(
            onPressed: () {}, style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
            child: const Text('Marcar atendida'))),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () {},
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border)),
            child: Text('Guardar', style: TextStyle(color: AppColors.textSecondary))),
        ]),
      ]),
    );
  }
}
