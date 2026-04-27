/// Información de contacto de la empresa referida.
class BusinessContact {
  final String name;
  final String phone;
  final String email;
  final String? position;

  BusinessContact({
    required this.name,
    required this.phone,
    required this.email,
    this.position,
  });
}

/// Actividad de la empresa (compras, transacciones, etc).
class BusinessActivity {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String type; // venta, suscripcion, servicio

  BusinessActivity({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}

/// Información extendida de una empresa referida.
class BusinessDetail {
  final String id;
  final String name;
  final String zone;
  final String? address;
  final BusinessContact? contact;
  final String description; // Descripción de lo que hace la empresa
  final List<BusinessActivity> activities;
  final double growthOpportunity; // Score de 0-100 para oportunidades de crecimiento
  final List<String> recommendedProducts; // Productos que podría usar

  BusinessDetail({
    required this.id,
    required this.name,
    required this.zone,
    this.address,
    this.contact,
    required this.description,
    required this.activities,
    required this.growthOpportunity,
    required this.recommendedProducts,
  });
}
