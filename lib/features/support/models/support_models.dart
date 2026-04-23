// Modelos para pantallas de soporte: Educación, Ayuda, Avisos Legales.

// ─── EDUCACIÓN Y BUENAS PRÁCTICAS ───

enum ContentType { articulo, video, guia }

extension ContentTypeExt on ContentType {
  String get displayName {
    switch (this) {
      case ContentType.articulo: return 'Artículo';
      case ContentType.video: return 'Video';
      case ContentType.guia: return 'Guía';
    }
  }
}

class EducationContent {
  final String id;
  final String title;
  final String category;
  final ContentType type;
  final String duration;
  final DateTime updatedAt;
  final bool viewed;
  final String body;

  EducationContent({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.duration,
    required this.updatedAt,
    this.viewed = false,
    required this.body,
  });
}

// ─── CENTRO DE AYUDA ───

enum TicketStatus { abierto, enProceso, cerrado }

extension TicketStatusExt on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.abierto: return 'Abierto';
      case TicketStatus.enProceso: return 'En proceso';
      case TicketStatus.cerrado: return 'Cerrado';
    }
  }
}

class FaqItem {
  final String question;
  final String answer;
  final String category;

  FaqItem({required this.question, required this.answer, required this.category});
}

class SupportTicket {
  final String id;
  final String category;
  final String subject;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;

  SupportTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}

// ─── AVISOS LEGALES ───

enum NoticeType { legal, operativo, economico }

extension NoticeTypeExt on NoticeType {
  String get displayName {
    switch (this) {
      case NoticeType.legal: return 'Legal';
      case NoticeType.operativo: return 'Operativo';
      case NoticeType.economico: return 'Económico';
    }
  }
}

enum NoticeStatus { nuevo, aceptado }

class LegalNotice {
  final String id;
  final String title;
  final NoticeType type;
  final String body;
  final DateTime effectiveDate;
  final NoticeStatus status;
  final bool requiresAcceptance;
  final String version;
  final DateTime? acceptedAt;

  LegalNotice({
    required this.id,
    required this.title,
    required this.type,
    required this.body,
    required this.effectiveDate,
    required this.status,
    required this.requiresAcceptance,
    required this.version,
    this.acceptedAt,
  });
}
