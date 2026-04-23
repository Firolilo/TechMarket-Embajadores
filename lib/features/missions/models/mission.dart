// Modelos para Misiones de Valor.
// Reemplaza "campañas" por misiones opcionales y profesionales.

import 'package:flutter/material.dart';

/// Estado de la misión.
enum MissionStatus { disponible, enProgreso, completada }

extension MissionStatusExt on MissionStatus {
  String get displayName {
    switch (this) {
      case MissionStatus.disponible: return 'Disponible';
      case MissionStatus.enProgreso: return 'En progreso';
      case MissionStatus.completada: return 'Completada';
    }
  }
}

/// Tipo de misión.
enum MissionType { hardware, software, servicios }

extension MissionTypeExt on MissionType {
  String get displayName {
    switch (this) {
      case MissionType.hardware: return 'Hardware';
      case MissionType.software: return 'Software';
      case MissionType.servicios: return 'Servicios';
    }
  }

  IconData get icon {
    switch (this) {
      case MissionType.hardware: return Icons.computer;
      case MissionType.software: return Icons.code;
      case MissionType.servicios: return Icons.build;
    }
  }
}

/// Prioridad de misión.
enum MissionPriority { normal, alta }

extension MissionPriorityExt on MissionPriority {
  String get displayName {
    switch (this) {
      case MissionPriority.normal: return 'Normal';
      case MissionPriority.alta: return 'Alta';
    }
  }
}

class Mission {
  final String id;
  final String title;
  final String description;
  final String benefit;
  final MissionType type;
  final MissionPriority priority;
  final MissionStatus status;
  final List<String> steps;
  final String completionCriteria;
  final double? progress; // 0.0 - 1.0

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.benefit,
    required this.type,
    required this.priority,
    required this.status,
    required this.steps,
    required this.completionCriteria,
    this.progress,
  });
}
