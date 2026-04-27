import '../models/opportunity.dart';
import '../../../data/mock/mock_data.dart';

class OpportunityService {
  Future<List<Opportunity>> getOpportunities() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.opportunities;
  }

  Future<void> markAsAttended(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Aquí iría la lógica de backend para marcar como atendida
  }

  Future<void> markAsFollowing(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Aquí iría la lógica de backend para marcar como en seguimiento
  }

  Future<void> saveForLater(String id, bool isSaved) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Aquí iría la lógica de backend para guardar/quitar de guardadas
  }
}
