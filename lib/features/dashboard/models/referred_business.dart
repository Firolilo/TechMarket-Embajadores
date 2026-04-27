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
  final double monthlyImpact; // Impacto económico generado este mes
  final double monthlyIncome; // Ingresos generados por este negocio
  final double totalImpact; // Impacto total acumulado
  final double totalIncome; // Ingresos totales acumulados
  final int referralLevel; // 1, 2 o 3
  final DateTime referralDate; // Fecha en que se refirió
  final DateTime? lastActivityDate; // Última actividad

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
}
