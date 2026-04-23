import '../models/opportunity.dart';
import '../../../data/mock/mock_data.dart';

class OpportunityService {
  Future<List<Opportunity>> getOpportunities() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MockData.opportunities;
  }

  Future<void> markAsAttended(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> saveForLater(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
