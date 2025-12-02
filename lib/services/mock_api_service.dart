import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/live_event.dart';
import '../models/product.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  Map<String, dynamic>? _data;

  Future<void> _loadData() async {
    if (_data != null) return;
    final jsonString = await rootBundle.loadString('assets/mock-api-data.json');
    _data = json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<List<Product>> getProducts() async {
    await _loadData();
    final list = _data!['products'] as List<dynamic>;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<LiveEvent>> getLiveEvents() async {
    await _loadData();
    final products = await getProducts();
    final list = _data!['liveEvents'] as List<dynamic>;
    return list
        .map((e) => LiveEvent.fromJson(e as Map<String, dynamic>, products))
        .toList();
  }
}
