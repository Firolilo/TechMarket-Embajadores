import 'package:flutter/material.dart';
import '../models/earning.dart';
import '../services/earnings_service.dart';

class EarningsProvider extends ChangeNotifier {
  final _service = EarningsService();
  List<ActivityEvent> _events = [];
  List<HistoricalPeriod> _periods = [];
  List<MonthlyEarning> _monthly = [];
  List<PaymentRecord> _payments = [];
  bool _isLoading = false;
  ActivityType? _filterType;
  int? _filterLevel;

  List<ActivityEvent> get events {
    var filtered = _events;
    if (_filterType != null) filtered = filtered.where((e) => e.type == _filterType).toList();
    if (_filterLevel != null) filtered = filtered.where((e) => e.level == _filterLevel).toList();
    return filtered;
  }

  List<HistoricalPeriod> get periods => _periods;
  List<MonthlyEarning> get monthlyEarnings => _monthly;
  List<PaymentRecord> get payments => _payments;
  bool get isLoading => _isLoading;
  ActivityType? get filterType => _filterType;
  int? get filterLevel => _filterLevel;

  double get totalIncome => _events.fold(0, (sum, e) => sum + e.incomeAssociated);
  double get confirmedIncome => _events.where((e) => e.isConfirmed).fold(0, (sum, e) => sum + e.incomeAssociated);
  double get totalPaid => _payments.where((p) => p.status == LiquidationStatus.paid).fold(0, (sum, p) => sum + p.amount);
  double get totalPending => _payments.where((p) => p.status != LiquidationStatus.paid).fold(0, (sum, p) => sum + p.amount);

  void setTypeFilter(ActivityType? type) { _filterType = type; notifyListeners(); }
  void setLevelFilter(int? level) { _filterLevel = level; notifyListeners(); }

  Future<void> loadEarnings() async {
    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _service.getActivityEvents(),
      _service.getHistoricalPeriods(),
      _service.getMonthlyEarnings(),
      _service.getPayments(),
    ]);

    _events = results[0] as List<ActivityEvent>;
    _periods = results[1] as List<HistoricalPeriod>;
    _monthly = results[2] as List<MonthlyEarning>;
    _payments = results[3] as List<PaymentRecord>;
    _isLoading = false;
    notifyListeners();
  }
}
