import '../../features/auth/models/ambassador_user.dart';
import '../../features/dashboard/models/dashboard_stats.dart';
import '../../features/earnings/models/earning.dart';
import '../../features/opportunities/models/opportunity.dart';
import '../../features/missions/models/mission.dart';
import '../../features/support/models/support_models.dart';

/// Datos mock centralizados para toda la app.
/// Al migrar a backend real, solo se reemplazan los servicios.
class MockData {
  // ─── USUARIO EMBAJADOR ───
  static final currentUser = AmbassadorUser(
    id: 'amb_001',
    name: 'Carlos Mendoza',
    email: 'carlos@techmarket.app',
    phone: '+591 78912345',
    tier: AmbassadorTier.plata,
    refId: 'TM-00042',
    inviterName: 'Ana López',
    attributionSource: AttributionSource.link,
    participationType: ParticipationType.ambos,
    emailVerification: VerificationStatus.verified,
    phoneVerification: VerificationStatus.verified,
    documentType: 'CI',
    documentNumber: '9876543',
    birthDate: DateTime(1992, 5, 15),
    country: 'Bolivia',
    city: 'Santa Cruz de la Sierra',
    zone: 'Equipetrol',
    profileCompleted: true,
    termsAccepted: true,
    programRulesAccepted: true,
    paymentMethod: PaymentMethod(
      type: PaymentMethodType.transferencia,
      bankName: 'Banco Mercantil',
      accountType: 'Ahorros',
      accountNumber: '****4523',
      holderName: 'Carlos Mendoza',
      holderDocument: '9876543',
      status: PaymentMethodStatus.configured,
    ),
    onboardingStep: OnboardingStep.completed,
    totalReferrals: 18,
    activeBusinesses: 7,
    activeDrivers: 4,
    activeUsers: 12,
    totalEarnings: 4850.0,
    ambassadorCode: 'TM-12345',
    inviteUrl: 'https://techmarket.app/registro?ref=TM-12345',
  );

  // ─── DASHBOARD STATS ───
  static final dashboardStats = DashboardStats(
    economicImpact: 38450.0,
    estimatedIncome: 1920.0,
    isIncomeConfirmed: false,
    activityByType: ActivityByType(
      activeHardware: 7,
      activeSoftware: 4,
      activeServices: 12,
    ),
    variationPercent: 18.5,
    activityState: ActivityState.actividadConstante,
    levelBreakdown: [
      LevelImpact(level: 1, economicImpact: 18200, percentageApplied: 5.0, incomeGenerated: 910),
      LevelImpact(level: 2, economicImpact: 12800, percentageApplied: 3.0, incomeGenerated: 384),
      LevelImpact(level: 3, economicImpact: 7450, percentageApplied: 2.0, incomeGenerated: 149),
    ],
  );

  // ─── ACTIVIDAD RECIENTE ───
  static final recentActivity = [
    ActivityItem(title: 'Venta de hardware', subtitle: 'Laptop Lenovo ThinkPad vendida a través de tu enlace', timestamp: DateTime.now().subtract(const Duration(hours: 2)), amount: 85.0),
    ActivityItem(title: 'Licencia de software', subtitle: 'Suscripción anual Microsoft 365 activada', timestamp: DateTime.now().subtract(const Duration(hours: 5)), amount: 24.0),
    ActivityItem(title: 'Nuevo registro', subtitle: 'Un cliente se registró con tu enlace', timestamp: DateTime.now().subtract(const Duration(hours: 8))),
    ActivityItem(title: 'Liquidación procesada', subtitle: 'Pago semanal Bs 890 confirmado', timestamp: DateTime.now().subtract(const Duration(days: 1)), amount: 890.0),
    ActivityItem(title: 'Servicio técnico', subtitle: 'Servicio de configuración de red completado', timestamp: DateTime.now().subtract(const Duration(days: 2)), amount: 45.0),
  ];

  // ─── ACTIVIDAD SEMANAL (GRÁFICO) ───
  static final weeklyActivity = List.generate(7, (i) => DailyActivity(
    date: DateTime.now().subtract(Duration(days: 6 - i)),
    impact: [1200, 1800, 1500, 2200, 1900, 2800, 3100][i].toDouble(),
    income: [60, 90, 75, 110, 95, 140, 155][i].toDouble(),
  ));

  // ─── EVENTOS DE ACTIVIDAD DETALLADOS ───
  static final activityEvents = [
    ActivityEvent(id: 'ev_01', date: DateTime.now().subtract(const Duration(hours: 3)), type: ActivityType.venta, origin: ActivityOrigin.hardware, description: 'Venta – Laptop Lenovo ThinkPad', impactGenerated: 4500.0, incomeAssociated: 225.0, isConfirmed: true, level: 1),
    ActivityEvent(id: 'ev_02', date: DateTime.now().subtract(const Duration(hours: 5)), type: ActivityType.suscripcion, origin: ActivityOrigin.software, description: 'Suscripción – Microsoft 365 Enterprise', impactGenerated: 800.0, incomeAssociated: 24.0, isConfirmed: true, level: 1),
    ActivityEvent(id: 'ev_03', date: DateTime.now().subtract(const Duration(hours: 8)), type: ActivityType.venta, origin: ActivityOrigin.hardware, description: 'Venta – Monitor Samsung 27"', impactGenerated: 1200.0, incomeAssociated: 36.0, isConfirmed: false, level: 2),
    ActivityEvent(id: 'ev_04', date: DateTime.now().subtract(const Duration(days: 1)), type: ActivityType.registroActivo, origin: ActivityOrigin.servicios, description: 'Registro activo – Cliente corporativo', impactGenerated: 50.0, incomeAssociated: 2.5, isConfirmed: true, level: 1),
    ActivityEvent(id: 'ev_05', date: DateTime.now().subtract(const Duration(days: 1)), type: ActivityType.servicio, origin: ActivityOrigin.servicios, description: 'Servicio – Configuración de red empresarial', impactGenerated: 1500.0, incomeAssociated: 45.0, isConfirmed: false, level: 3),
  ];

  // ─── PERIODOS HISTÓRICOS ───
  static final historicalPeriods = [
    HistoricalPeriod(period: 'Semana 14', economicImpact: 8200, ambassadorIncome: 450, status: LiquidationStatus.paid, paymentDate: DateTime.now().subtract(const Duration(days: 3))),
    HistoricalPeriod(period: 'Semana 13', economicImpact: 7100, ambassadorIncome: 380, status: LiquidationStatus.paid, paymentDate: DateTime.now().subtract(const Duration(days: 10))),
    HistoricalPeriod(period: 'Semana 12', economicImpact: 6900, ambassadorIncome: 350, status: LiquidationStatus.paid, paymentDate: DateTime.now().subtract(const Duration(days: 17))),
    HistoricalPeriod(period: 'Semana 15', economicImpact: 9300, ambassadorIncome: 520, status: LiquidationStatus.pending),
  ];

  // ─── GANANCIAS MENSUALES ───
  static final monthlyEarnings = [
    MonthlyEarning(month: 'Ene', amount: 620),
    MonthlyEarning(month: 'Feb', amount: 890),
    MonthlyEarning(month: 'Mar', amount: 1150),
    MonthlyEarning(month: 'Abr', amount: 1920),
  ];

  // ─── PAGOS ───
  static final payments = [
    PaymentRecord(id: 'pay_01', amount: 890.0, method: 'Transferencia – Mercantil', status: LiquidationStatus.paid, requestedAt: DateTime.now().subtract(const Duration(days: 3)), paidAt: DateTime.now().subtract(const Duration(days: 2))),
    PaymentRecord(id: 'pay_02', amount: 750.0, method: 'Transferencia – Mercantil', status: LiquidationStatus.paid, requestedAt: DateTime.now().subtract(const Duration(days: 10)), paidAt: DateTime.now().subtract(const Duration(days: 9))),
    PaymentRecord(id: 'pay_03', amount: 520.0, method: 'Transferencia – Mercantil', status: LiquidationStatus.pending, requestedAt: DateTime.now()),
  ];

  // ─── OPORTUNIDADES DETECTADAS (IA) ───
  static final opportunities = [
    Opportunity(id: 'opp_01', type: OpportunityType.hardware, zone: 'Equipetrol', description: 'Alta demanda de equipos de oficina en empresas nuevas de la zona.', potential: OpportunityPotential.alto, dataSource: 'Demanda no cubierta', status: OpportunityStatus.nueva),
    Opportunity(id: 'opp_02', type: OpportunityType.software, zone: 'Plan 3000', description: 'Instituciones educativas sin licencias de software actualizadas.', potential: OpportunityPotential.alto, dataSource: 'Baja cobertura', status: OpportunityStatus.nueva),
    Opportunity(id: 'opp_03', type: OpportunityType.hardware, zone: 'Av. Monseñor Rivero', description: 'Oficinas corporativas con equipos obsoletos que necesitan renovación.', potential: OpportunityPotential.medio, dataSource: 'Detección por IA', status: OpportunityStatus.enSeguimiento),
    Opportunity(id: 'opp_04', type: OpportunityType.servicios, zone: 'Urbarí', description: 'Zona residencial con alta demanda de servicios de soporte técnico.', potential: OpportunityPotential.medio, dataSource: 'Análisis demográfico', status: OpportunityStatus.nueva),
    Opportunity(id: 'opp_05', type: OpportunityType.software, zone: 'Norte', description: 'Startups tecnológicas sin herramientas de productividad empresarial.', potential: OpportunityPotential.alto, dataSource: 'Patrones de mercado', status: OpportunityStatus.atendida),
  ];

  // ─── MISIONES DE VALOR ───
  static final missions = [
    Mission(id: 'mis_01', title: 'Expandir ventas de hardware', description: 'Genera 2 ventas de equipos de computación en tu zona.', benefit: 'Mayor cobertura de mercado y potencial de ingresos', type: MissionType.hardware, priority: MissionPriority.alta, status: MissionStatus.enProgreso, steps: ['Identifica empresas que necesiten equipos', 'Comparte tu catálogo con enlace personalizado', 'Acompaña el proceso de compra'], completionCriteria: '2 ventas confirmadas en 7 días', progress: 0.5),
    Mission(id: 'mis_02', title: 'Activar licencias de software', description: 'Consigue 3 suscripciones de software empresarial.', benefit: 'Ingresos recurrentes por suscripciones activas', type: MissionType.software, priority: MissionPriority.alta, status: MissionStatus.disponible, steps: ['Identifica empresas sin licenciamiento', 'Presenta las opciones disponibles', 'Completa el proceso de activación'], completionCriteria: '3 licencias activadas', progress: 0.0),
    Mission(id: 'mis_03', title: 'Captar clientes de servicios técnicos', description: 'Registra 5 clientes nuevos para servicios de soporte.', benefit: 'Incremento del ecosistema de servicios', type: MissionType.servicios, priority: MissionPriority.normal, status: MissionStatus.disponible, steps: ['Identifica necesidades de soporte', 'Registra clientes con tu enlace', 'Confirma al menos un servicio prestado'], completionCriteria: '5 clientes con al menos 1 servicio', progress: 0.0),
    Mission(id: 'mis_04', title: 'Primera venta de equipo', description: 'Realiza tu primera venta de hardware a través de la plataforma.', benefit: 'Desbloqueo de misiones avanzadas', type: MissionType.hardware, priority: MissionPriority.normal, status: MissionStatus.completada, steps: ['Identifica un cliente potencial', 'Comparte tu enlace de catálogo', 'Confirma la venta'], completionCriteria: '1 venta confirmada', progress: 1.0),
  ];

  // ─── EDUCACIÓN ───
  static final educationContent = [
    EducationContent(id: 'edu_01', title: 'Cómo identificar oportunidades en tecnología', category: 'Cómo generar impacto', type: ContentType.articulo, duration: '5 min', updatedAt: DateTime(2026, 4, 10), viewed: true, body: 'Busca empresas que estén actualizando infraestructura o abriendo nuevas oficinas...'),
    EducationContent(id: 'edu_02', title: 'Buenas prácticas al recomendar productos', category: 'Uso correcto de invitaciones', type: ContentType.guia, duration: '4 min', updatedAt: DateTime(2026, 4, 15), body: 'Siempre usa tu enlace personal. Presenta el catálogo completo antes de recomendar...'),
    EducationContent(id: 'edu_03', title: 'Errores comunes a evitar', category: 'Errores comunes a evitar', type: ContentType.video, duration: '7 min', updatedAt: DateTime(2026, 4, 1), body: 'Los errores más frecuentes incluyen no verificar compatibilidad de productos...'),
    EducationContent(id: 'edu_04', title: 'Introducción al programa de embajadores', category: 'Introducción al programa', type: ContentType.articulo, duration: '3 min', updatedAt: DateTime(2026, 3, 20), viewed: true, body: 'El programa de embajadores TechMarket está diseñado para generar impacto en el mercado tecnológico...'),
    EducationContent(id: 'edu_05', title: 'Aspectos legales y garantías', category: 'Aspectos legales y éticos', type: ContentType.guia, duration: '6 min', updatedAt: DateTime(2026, 4, 18), body: 'Tu participación está regulada por las políticas del programa y las garantías de los productos...'),
  ];

  // ─── FAQ ───
  static final faqs = [
    FaqItem(question: '¿Cómo se calculan mis ingresos?', answer: 'Tus ingresos se calculan en base a las ventas y servicios generados por tus recomendaciones, desglosado por nivel.', category: 'Pagos y liquidaciones'),
    FaqItem(question: '¿Cuándo recibo mi pago?', answer: 'Los pagos se procesan semanalmente. Debes tener un método de pago configurado y verificado.', category: 'Pagos y liquidaciones'),
    FaqItem(question: '¿Puedo cambiar quién me invitó?', answer: 'No. La atribución es inmutable una vez completado el registro.', category: 'Invitaciones y atribución'),
    FaqItem(question: '¿Qué productos puedo recomendar?', answer: 'Puedes recomendar cualquier producto o servicio del catálogo TechMarket: hardware, software y servicios técnicos.', category: 'Reglas del programa'),
    FaqItem(question: '¿Puedo ver quiénes están en mi red?', answer: 'No mostramos personas porque nuestro modelo paga por actividad económica real, no por reclutar personas. Mostramos impacto, no identidades.', category: 'Reglas del programa'),
  ];

  // ─── TICKETS ───
  static final tickets = <SupportTicket>[];

  // ─── AVISOS LEGALES ───
  static final legalNotices = [
    LegalNotice(id: 'notice_01', title: 'Actualización de porcentajes de comisión', type: NoticeType.economico, body: 'A partir del 1 de mayo de 2026, los porcentajes de comisión por nivel se ajustarán según el nuevo modelo de impacto económico...', effectiveDate: DateTime(2026, 5, 1), status: NoticeStatus.nuevo, requiresAcceptance: true, version: '1.0'),
    LegalNotice(id: 'notice_02', title: 'Política de garantías actualizada', type: NoticeType.legal, body: 'Se han actualizado las políticas de garantía para productos recomendados por embajadores...', effectiveDate: DateTime(2026, 4, 15), status: NoticeStatus.aceptado, requiresAcceptance: true, version: '2.1', acceptedAt: DateTime(2026, 4, 16)),
  ];
}
