import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/widgets/stat_chip.dart';
import '../models/opportunity.dart';
import '../providers/opportunity_provider.dart';
import 'opportunity_detail_screen.dart';

/// PANTALLA 8 – Oportunidades Detectadas (IA).
class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});
  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        context.read<OpportunityProvider>().loadOpportunities());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OpportunityProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Oportunidades detectadas',
                      style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text('Sugerencias basadas en datos del ecosistema',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      _Chip(
                        label: 'Todas',
                        selected: prov.filterType == null,
                        onTap: () => prov.setTypeFilter(null),
                      ),
                      ...OpportunityType.values.map((t) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _Chip(
                          label: t.displayName,
                          selected: prov.filterType == t,
                          onTap: () => prov.setTypeFilter(t),
                        ),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // TabBar con categorías
            Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {
                  // Cambiar filtro de estado según tab
                  switch (index) {
                    case 0:
                      prov.setStatusFilter(null); // Todas
                      break;
                    case 1:
                      prov.setStatusFilter(OpportunityStatus.nueva);
                      break;
                    case 2:
                      prov.setStatusFilter(OpportunityStatus.enSeguimiento);
                      break;
                    case 3:
                      prov.setStatusFilter(OpportunityStatus.atendida);
                      break;
                    case 4:
                      // Para guardadas, lo manejaremos en el build
                      break;
                  }
                },
                tabs: [
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Todas'),
                        const SizedBox(height: 2),
                        Text(
                          '${prov.allOpportunities.length}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Nueva'),
                        const SizedBox(height: 2),
                        Text(
                          '${prov.newCount}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Seguimiento'),
                        const SizedBox(height: 2),
                        Text(
                          '${prov.followingCount}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Atendidas'),
                        const SizedBox(height: 2),
                        Text(
                          '${prov.attendedCount}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Guardadas'),
                        const SizedBox(height: 2),
                        Text(
                          '${prov.savedCount}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Lista de oportunidades
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 0: Todas
                  _OpportunitiesList(
                    opportunities: prov.opportunities,
                    isLoading: prov.isLoading,
                  ),
                  // Tab 1: Nueva
                  _OpportunitiesList(
                    opportunities: prov.opportunities
                        .where((o) => o.status == OpportunityStatus.nueva)
                        .toList(),
                    isLoading: prov.isLoading,
                  ),
                  // Tab 2: En seguimiento
                  _OpportunitiesList(
                    opportunities: prov.opportunities
                        .where((o) =>
                            o.status == OpportunityStatus.enSeguimiento)
                        .toList(),
                    isLoading: prov.isLoading,
                  ),
                  // Tab 3: Atendidas
                  _OpportunitiesList(
                    opportunities: prov.attendedOpportunities,
                    isLoading: prov.isLoading,
                  ),
                  // Tab 4: Guardadas
                  _OpportunitiesList(
                    opportunities: prov.savedOpportunities,
                    isLoading: prov.isLoading,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip(
      {required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _OpportunitiesList extends StatelessWidget {
  final List<Opportunity> opportunities;
  final bool isLoading;

  const _OpportunitiesList({
    required this.opportunities,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          )
        : opportunities.isEmpty
            ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inbox_outlined,
                      size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: 12),
                  Text('Sin oportunidades disponibles',
                      style: AppTextStyles.bodyMedium),
                ],
              ),
            )
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: opportunities.length,
              itemBuilder: (_, i) =>
                  _OppCard(opp: opportunities[i]),
            );
  }
}

class _OppCard extends StatelessWidget {
  final Opportunity opp;
  const _OppCard({required this.opp});

  Color get _potColor {
    switch (opp.potential) {
      case OpportunityPotential.alto:
        return AppColors.success;
      case OpportunityPotential.medio:
        return AppColors.warning;
      case OpportunityPotential.bajo:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Abrir pantalla de detalle
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                OpportunityDetailScreen(opportunityId: opp.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(opp.type.icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(opp.zone, style: AppTextStyles.labelLarge),
                ),
                StatChip(
                  label: opp.potential.displayName,
                  color: _potColor,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(opp.description, style: AppTextStyles.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.auto_awesome,
                    size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(opp.dataSource, style: AppTextStyles.caption),
                const Spacer(),
                StatChip(label: opp.status.displayName, color: AppColors.info),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Abre el detalle
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              OpportunityDetailScreen(opportunityId: opp.id),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text('Ver más'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await context
                          .read<OpportunityProvider>()
                          .toggleSaved(opp.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              opp.isSaved
                                  ? 'Removida de favoritos'
                                  : 'Guardada en favoritos',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Icon(
                      opp.isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

