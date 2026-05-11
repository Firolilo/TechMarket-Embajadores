import 'package:flutter/material.dart';

/// Tipo de negocio referido.
enum BusinessType { hardware, software, servicios, mixto }

extension BusinessTypeExt on BusinessType {
  String get displayName {
    switch (this) {
      case BusinessType.hardware:
        return 'Hardware';
      case BusinessType.software:
        return 'Software';
      case BusinessType.servicios:
        return 'Servicios';
      case BusinessType.mixto:
        return 'Mixto';
    }
  }

  IconData get icon {
    switch (this) {
      case BusinessType.hardware:
        return Icons.computer;
      case BusinessType.software:
        return Icons.code;
      case BusinessType.servicios:
        return Icons.build;
      case BusinessType.mixto:
        return Icons.store;
    }
  }

  Color get color {
    switch (this) {
      case BusinessType.hardware:
        return const Color(0xFF3B82F6);
      case BusinessType.software:
        return const Color(0xFF8B5CF6);
      case BusinessType.servicios:
        return const Color(0xFF10B981);
      case BusinessType.mixto:
        return const Color(0xFFF59E0B);
    }
  }
}

/// Estado del negocio referido.
enum BusinessStatus { activo, inactivo, pausado }

extension BusinessStatusExt on BusinessStatus {
  String get displayName {
    switch (this) {
      case BusinessStatus.activo:
        return 'Activo';
      case BusinessStatus.inactivo:
        return 'Inactivo';
      case BusinessStatus.pausado:
        return 'Pausado';
    }
  }

  Color get color {
    switch (this) {
      case BusinessStatus.activo:
        return const Color(0xFF10B981);
      case BusinessStatus.inactivo:
        return const Color(0xFF6B7280);
      case BusinessStatus.pausado:
        return const Color(0xFFFB923C);
    }
  }
}

/// Modelo para un negocio referido por el embajador.
class ReferredBusiness {
  final String id;
  final String name;
  final String zone;
  final BusinessType type;
  final BusinessStatus status;
  final double monthlyImpact;
  final double monthlyIncome;
  final double totalImpact;
  final double totalIncome;
  final int referralLevel;
  final DateTime referralDate;
  final DateTime? lastActivityDate;

  ReferredBusiness({
    required this.id,
    required this.name,
    required this.zone,
    required this.type,
    required this.status,
    required this.monthlyImpact,
    required this.monthlyIncome,
    required this.totalImpact,
    required this.totalIncome,
    required this.referralLevel,
    required this.referralDate,
    this.lastActivityDate,
  });

  factory ReferredBusiness.fromJson(Map<String, dynamic> j) => ReferredBusiness(
        id: j['id'] as String,
        name: j['name'] as String,
        zone: j['zone'] as String,
        type: _parseType(j['type'] as String),
        status: _parseStatus(j['status'] as String),
        monthlyImpact: (j['monthlyImpact'] as num).toDouble(),
        monthlyIncome: (j['monthlyIncome'] as num).toDouble(),
        totalImpact: (j['totalImpact'] as num).toDouble(),
        totalIncome: (j['totalIncome'] as num).toDouble(),
        referralLevel: j['referralLevel'] as int,
        referralDate: DateTime.parse(j['referralDate'] as String),
        lastActivityDate: j['lastActivityDate'] != null
            ? DateTime.parse(j['lastActivityDate'] as String)
            : null,
      );

  static BusinessType _parseType(String t) {
    switch (t) {
      case 'hardware': return BusinessType.hardware;
      case 'software': return BusinessType.software;
      case 'mixto': return BusinessType.mixto;
      default: return BusinessType.servicios;
    }
  }

  static BusinessStatus _parseStatus(String s) {
    switch (s) {
      case 'activo': return BusinessStatus.activo;
      case 'pausado': return BusinessStatus.pausado;
      default: return BusinessStatus.inactivo;
    }
  }
}
