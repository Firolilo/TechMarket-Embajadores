import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_decorations.dart';
import '../models/referred_business.dart';
import '../models/business_detail.dart';

/// Pantalla de detalle de una empresa referida.
class BusinessDetailScreen extends StatefulWidget {
  final ReferredBusiness business;

  const BusinessDetailScreen({
    super.key,
    required this.business,
  });

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  late BusinessDetail _detail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessDetail();
  }

  Future<void> _loadBusinessDetail() async {
    // Simular carga de datos
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _detail = BusinessDetail(
        id: widget.business.id,
        name: widget.business.name,
        zone: widget.business.zone,
        address: '${widget.business.zone}, Santa Cruz de la Sierra',
        contact: BusinessContact(
          name: 'Juan García',
          phone: '+591 76543210',
          email: 'contacto@${widget.business.name.toLowerCase().replaceAll(' ', '')}.com',
          position: 'Gerente General',
        ),
        description: 'Empresa dedicada a la venta y distribución de ${widget.business.type.displayName.toLowerCase()}. ${widget.business.status == BusinessStatus.activo ? 'Muy activa en el mercado' : 'Empresa en evaluación'}.',
        activities: _getActivitiesForBusiness(),
        growthOpportunity: _calculateGrowthOpportunity(),
        recommendedProducts: _getRecommendedProducts(),
      );
      _isLoading = false;
    });
  }

  List<BusinessActivity> _getActivitiesForBusiness() {
    return [
      BusinessActivity(
        id: 'act_001',
        description: 'Compra de equipos de oficina',
        amount: 8500.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: 'venta',
      ),
      BusinessActivity(
        id: 'act_002',
        description: 'Licencia de software activada',
        amount: 2400.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: 'suscripcion',
      ),
      BusinessActivity(
        id: 'act_003',
        description: 'Servicio técnico - Configuración de red',
        amount: 1500.0,
        date: DateTime.now().subtract(const Duration(days: 8)),
        type: 'servicio',
      ),
      BusinessActivity(
        id: 'act_004',
        description: 'Renovación de componentes',
        amount: 3200.0,
        date: DateTime.now().subtract(const Duration(days: 15)),
        type: 'venta',
      ),
    ];
  }

  double _calculateGrowthOpportunity() {
    if (widget.business.status == BusinessStatus.activo) {
      return (widget.business.monthlyIncome / widget.business.totalIncome * 100).clamp(0, 100);
    }
    return 25.0;
  }

  List<String> _getRecommendedProducts() {
    switch (widget.business.type) {
      case BusinessType.hardware:
        return ['Laptops', 'Servidores', 'Routers', 'Switches'];
      case BusinessType.software:
        return ['Microsoft 365', 'Adobe Creative Suite', 'Antivirus empresarial'];
      case BusinessType.servicios:
        return ['Soporte 24/7', 'Consultoría IT', 'Mantenimiento preventivo'];
      case BusinessType.mixto:
        return ['Equipos', 'Licencias', 'Soporte técnico', 'Consultoría'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : CustomScrollView(
                  slivers: [
                    // Header con botón de retorno
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: widget.business.status.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              widget.business.status.displayName,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: widget.business.status.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre y tipo de negocio
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: widget.business.type.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    widget.business.type.icon,
                                    color: widget.business.type.color,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.business.name,
                                        style: AppTextStyles.heading2,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              size: 14,
                                              color: AppColors.textTertiary),
                                          const SizedBox(width: 4),
                                          Text(
                                            _detail.zone,
                                            style: AppTextStyles.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Descripción
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: AppDecorations.card(),
                              child: Text(
                                _detail.description,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Resumen de métricas principales
                            Text('Resumen de ingresos',
                                style: AppTextStyles.heading3),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _MetricCard(
                                    label: 'Ingresos mes',
                                    value:
                                        'Bs ${widget.business.monthlyIncome.toStringAsFixed(0)}',
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _MetricCard(
                                    label: 'Total acumulado',
                                    value:
                                        'Bs ${widget.business.totalIncome.toStringAsFixed(0)}',
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _MetricCard(
                                    label: 'Impacto mes',
                                    value:
                                        'Bs ${widget.business.monthlyImpact.toStringAsFixed(0)}',
                                    color: AppColors.warning,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _MetricCard(
                                    label: 'Referido hace',
                                    value:
                                        '${DateTime.now().difference(widget.business.referralDate).inDays} días',
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Información de contacto
                            Text('Contacto', style: AppTextStyles.heading3),
                            const SizedBox(height: 10),
                            if (_detail.contact != null) ...[
                              _ContactTile(
                                icon: Icons.person_outline,
                                label: _detail.contact!.name,
                                subtitle: _detail.contact!.position,
                              ),
                              const SizedBox(height: 8),
                              _ContactTile(
                                icon: Icons.phone_outlined,
                                label: _detail.contact!.phone,
                                subtitle: 'Teléfono',
                                onTap: () {
                                  // Aquí se podría abrir dialer
                                },
                              ),
                              const SizedBox(height: 8),
                              _ContactTile(
                                icon: Icons.email_outlined,
                                label: _detail.contact!.email,
                                subtitle: 'Email',
                              ),
                            ],
                            const SizedBox(height: 20),

                            // Oportunidades de crecimiento
                            Text('Oportunidades de crecimiento',
                                style: AppTextStyles.heading3),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: AppDecorations.card(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Potencial de crecimiento',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                      Text(
                                        '${_detail.growthOpportunity.toStringAsFixed(0)}%',
                                        style: AppTextStyles.labelLarge.copyWith(
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _detail.growthOpportunity / 100,
                                      backgroundColor: AppColors.textTertiary
                                          .withValues(alpha: 0.2),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              AppColors.success),
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _detail.growthOpportunity > 75
                                        ? 'Empresa con alto potencial de crecimiento'
                                        : _detail.growthOpportunity > 50
                                            ? 'Empresa con potencial moderado'
                                            : 'Empresa con potencial por explorar',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Productos recomendados
                            Text('Productos recomendados',
                                style: AppTextStyles.heading3),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _detail.recommendedProducts
                                  .map(
                                    (product) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Text(
                                        product,
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 20),

                            // Historial de actividades
                            Text('Historial de actividades',
                                style: AppTextStyles.heading3),
                            const SizedBox(height: 10),
                            ..._detail.activities.map(
                              (activity) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _ActivityTile(activity: activity),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: AppDecorations.card(),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final BusinessActivity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final daysAgo = DateTime.now().difference(activity.date).inDays;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppDecorations.card(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity.type == 'venta'
                  ? Icons.shopping_cart_outlined
                  : activity.type == 'suscripcion'
                      ? Icons.card_membership_outlined
                      : Icons.build_outlined,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Hace $daysAgo días',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '+Bs ${activity.amount.toStringAsFixed(0)}',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
