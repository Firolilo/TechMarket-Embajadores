import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../models/referred_business.dart';
import '../providers/dashboard_provider.dart';
import 'business_detail_screen.dart';

/// Pantalla para ver todas las empresas referidas del embajador.
class ReferredBusinessesScreen extends StatefulWidget {
  const ReferredBusinessesScreen({super.key});

  @override
  State<ReferredBusinessesScreen> createState() =>
      _ReferredBusinessesScreenState();
}

class _ReferredBusinessesScreenState extends State<ReferredBusinessesScreen> {
  String _filterStatus = 'todos'; // todos, activo, inactivo, pausado
  String _sortBy = 'impacto'; // impacto, ingresos, fecha

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DashboardProvider>();
    final businesses = _getFilteredAndSortedBusinesses(prov.referredBusinesses);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.arrow_back, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mis empresas referidas',
                                style: AppTextStyles.heading2,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${businesses.length} empresas en total',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Filtros y ordenamiento
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        selected: _filterStatus == 'todos',
                        onTap: () => setState(() => _filterStatus = 'todos'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Activos',
                        selected: _filterStatus == 'activo',
                        onTap: () => setState(() => _filterStatus = 'activo'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Pausados',
                        selected: _filterStatus == 'pausado',
                        onTap: () => setState(() => _filterStatus = 'pausado'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Inactivos',
                        selected: _filterStatus == 'inactivo',
                        onTap: () => setState(() => _filterStatus = 'inactivo'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Lista de empresas
              Expanded(
                child: businesses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.store_outlined,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sin empresas con este filtro',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: businesses.length,
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BusinessDetailScreen(business: businesses[i]),
                            ),
                          ),
                          child: _BusinessCard(business: businesses[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ReferredBusiness> _getFilteredAndSortedBusinesses(
      List<ReferredBusiness> all) {
    // Filtrar
    var filtered = all;
    if (_filterStatus != 'todos') {
      filtered = filtered
          .where((b) => b.status.name == _filterStatus)
          .toList();
    }

    // Ordenar
    switch (_sortBy) {
      case 'impacto':
        filtered.sort((a, b) => b.monthlyImpact.compareTo(a.monthlyImpact));
        break;
      case 'ingresos':
        filtered.sort((a, b) => b.monthlyIncome.compareTo(a.monthlyIncome));
        break;
      case 'fecha':
        filtered.sort((a, b) => b.referralDate.compareTo(a.referralDate));
        break;
    }

    return filtered;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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

class _BusinessCard extends StatelessWidget {
  final ReferredBusiness business;

  const _BusinessCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final daysActive = DateTime.now().difference(business.referralDate).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con nombre y estado
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: business.type.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  business.type.icon,
                  color: business.type.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          business.zone,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 8),
                        Text('•', style: AppTextStyles.caption),
                        const SizedBox(width: 8),
                        Text(
                          'Nivel ${business.referralLevel}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: business.status.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      business.status.displayName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: business.status.color,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Métricas
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Impacto mes',
                  value: 'Bs ${business.monthlyImpact.toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Ingresos mes',
                  value: 'Bs ${business.monthlyIncome.toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Días activo',
                  value: '$daysActive días',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso de ingresos
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos totales',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (business.totalIncome / 5000).clamp(0, 1),
                        backgroundColor:
                            AppColors.textTertiary.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          business.totalIncome > 2000
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Bs ${business.totalIncome.toStringAsFixed(0)}',
                style: AppTextStyles.labelSmall,
              ),
            ],
          ),
          if (business.lastActivityDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Última actividad: ${_formatLastActivity(business.lastActivityDate!)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastActivity(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 1) {
      return 'Hace poco';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays} días';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}
