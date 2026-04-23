// Modelo principal del embajador alineado con la especificación.
// Incluye atribución, verificación, perfil y método de pago.

enum AmbassadorTier { bronce, plata, oro, platino }

extension AmbassadorTierExt on AmbassadorTier {
  String get displayName {
    switch (this) {
      case AmbassadorTier.bronce: return 'Bronce';
      case AmbassadorTier.plata: return 'Plata';
      case AmbassadorTier.oro: return 'Oro';
      case AmbassadorTier.platino: return 'Platino';
    }
  }

  String get emoji {
    switch (this) {
      case AmbassadorTier.bronce: return '🥉';
      case AmbassadorTier.plata: return '🥈';
      case AmbassadorTier.oro: return '🥇';
      case AmbassadorTier.platino: return '💎';
    }
  }

  double get commissionRate {
    switch (this) {
      case AmbassadorTier.bronce: return 0.05;
      case AmbassadorTier.plata: return 0.08;
      case AmbassadorTier.oro: return 0.12;
      case AmbassadorTier.platino: return 0.15;
    }
  }

  int get minReferrals {
    switch (this) {
      case AmbassadorTier.bronce: return 0;
      case AmbassadorTier.plata: return 10;
      case AmbassadorTier.oro: return 30;
      case AmbassadorTier.platino: return 75;
    }
  }

  AmbassadorTier? get nextTier {
    switch (this) {
      case AmbassadorTier.bronce: return AmbassadorTier.plata;
      case AmbassadorTier.plata: return AmbassadorTier.oro;
      case AmbassadorTier.oro: return AmbassadorTier.platino;
      case AmbassadorTier.platino: return null;
    }
  }
}

/// Fuente de atribución (cómo llegó el embajador).
enum AttributionSource { link, qr, manual, organic }

extension AttributionSourceExt on AttributionSource {
  String get displayName {
    switch (this) {
      case AttributionSource.link: return 'Enlace';
      case AttributionSource.qr: return 'Código QR';
      case AttributionSource.manual: return 'Código manual';
      case AttributionSource.organic: return 'Registro directo';
    }
  }
}

/// Tipo de participación preferida.
enum ParticipationType { restaurantes, conductores, ambos }

extension ParticipationTypeExt on ParticipationType {
  String get displayName {
    switch (this) {
      case ParticipationType.restaurantes: return 'Restaurantes';
      case ParticipationType.conductores: return 'Conductores';
      case ParticipationType.ambos: return 'Ambos';
    }
  }
}

/// Estado de verificación de la cuenta.
enum VerificationStatus { pending, verified }

/// Tipo de método de pago.
enum PaymentMethodType { transferencia, billetera, otro }

extension PaymentMethodTypeExt on PaymentMethodType {
  String get displayName {
    switch (this) {
      case PaymentMethodType.transferencia: return 'Transferencia bancaria';
      case PaymentMethodType.billetera: return 'Billetera digital';
      case PaymentMethodType.otro: return 'Otro método';
    }
  }
}

/// Estado del método de pago.
enum PaymentMethodStatus { notConfigured, configured, inValidation }

/// Estado de onboarding del embajador.
enum OnboardingStep {
  registration,       // Pantallas 0-6
  verification,       // Verificación email + teléfono
  profileCompletion,  // Completar perfil
  paymentSetup,       // Método de pago
  welcome,            // Bienvenida al programa
  completed,          // Todo listo
}

class AmbassadorUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final AmbassadorTier tier;

  // Atribución
  final String? refId;
  final String? inviterName;
  final AttributionSource attributionSource;

  // Participación
  final ParticipationType participationType;

  // Verificación
  final VerificationStatus emailVerification;
  final VerificationStatus phoneVerification;

  // Perfil
  final String? documentType;
  final String? documentNumber;
  final DateTime? birthDate;
  final String country;
  final String city;
  final String? zone;
  final bool profileCompleted;
  final bool termsAccepted;
  final bool programRulesAccepted;

  // Método de pago
  final PaymentMethod? paymentMethod;

  // Onboarding
  final OnboardingStep onboardingStep;

  // Stats de impacto
  final int totalReferrals;
  final int activeBusinesses;
  final int activeDrivers;
  final int activeUsers;
  final double totalEarnings;

  // Código personal
  final String ambassadorCode;
  final String inviteUrl;

  AmbassadorUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.tier,
    this.refId,
    this.inviterName,
    required this.attributionSource,
    required this.participationType,
    required this.emailVerification,
    required this.phoneVerification,
    this.documentType,
    this.documentNumber,
    this.birthDate,
    this.country = 'Bolivia',
    this.city = 'Santa Cruz de la Sierra',
    this.zone,
    this.profileCompleted = false,
    this.termsAccepted = false,
    this.programRulesAccepted = false,
    this.paymentMethod,
    required this.onboardingStep,
    required this.totalReferrals,
    required this.activeBusinesses,
    required this.activeDrivers,
    required this.activeUsers,
    required this.totalEarnings,
    required this.ambassadorCode,
    required this.inviteUrl,
  });

  bool get isFullyVerified =>
      emailVerification == VerificationStatus.verified &&
      phoneVerification == VerificationStatus.verified;

  bool get canReceivePayments =>
      isFullyVerified && profileCompleted && paymentMethod != null && paymentMethod!.status == PaymentMethodStatus.configured;

  bool get hasCompletedOnboarding => onboardingStep == OnboardingStep.completed;
}

class PaymentMethod {
  final PaymentMethodType type;
  final String? bankName;
  final String? accountType;
  final String? accountNumber;
  final String? holderName;
  final String? holderDocument;
  final String? provider;
  final String? associatedNumber;
  final PaymentMethodStatus status;

  PaymentMethod({
    required this.type,
    this.bankName,
    this.accountType,
    this.accountNumber,
    this.holderName,
    this.holderDocument,
    this.provider,
    this.associatedNumber,
    required this.status,
  });
}
