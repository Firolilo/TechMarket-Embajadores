// Modelos para Oportunidades Detectadas (IA).
// Reemplaza el concepto de "negocios" por oportunidades basadas en datos reales.

import 'package:flutter/material.dart';

/// Nivel de potencial de la oportunidad.
enum OpportunityPotential { bajo, medio, alto }

extension OpportunityPotentialExt on OpportunityPotential {
  String get displayName {
    switch (this) {
      case OpportunityPotential.bajo: return 'Bajo';
      case OpportunityPotential.medio: return 'Medio';
      case OpportunityPotential.alto: return 'Alto';
    }
  }
}

/// Tipo de oportunidad.
enum OpportunityType { hardware, software, servicios }

extension OpportunityTypeExt on OpportunityType {
  String get displayName {
    switch (this) {
      case OpportunityType.hardware: return 'Hardware';
      case OpportunityType.software: return 'Software';
      case OpportunityType.servicios: return 'Servicios';
    }
  }

  IconData get icon {
    switch (this) {
      case OpportunityType.hardware: return Icons.computer;
      case OpportunityType.software: return Icons.code;
      case OpportunityType.servicios: return Icons.build;
    }
  }
}

/// Estado de la oportunidad.
enum OpportunityStatus { nueva, enSeguimiento, atendida }

extension OpportunityStatusExt on OpportunityStatus {
  String get displayName {
    switch (this) {
      case OpportunityStatus.nueva: return 'Nueva';
      case OpportunityStatus.enSeguimiento: return 'En seguimiento';
      case OpportunityStatus.atendida: return 'Atendida';
    }
  }
}

class Opportunity {
  final String id;
  final OpportunityType type;
  final String zone;
  final String description;
  final OpportunityPotential potential;
  final String dataSource;
  final OpportunityStatus status;

  Opportunity({
    required this.id,
    required this.type,
    required this.zone,
    required this.description,
    required this.potential,
    required this.dataSource,
    required this.status,
  });
}
