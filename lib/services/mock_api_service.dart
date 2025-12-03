import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/cart_item.dart';
import '../models/live_event.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/order.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  Map<String, dynamic>? _data;
  final List<CartItem> _cart = [];
  User? _currentUser;

  Future<void> _loadData() async {
    if (_data != null) return;
    final jsonString = await rootBundle.loadString('assets/mock-api-data.json');
    _data = json.decode(jsonString) as Map<String, dynamic>;

    // Initialize cart from JSON (single user for now)
    final cartJson = _data!['cart'] as Map<String, dynamic>?;
    if (cartJson != null) {
      final items = cartJson['items'] as List<dynamic>? ?? [];
      final products = await getProducts();
      for (final item in items) {
        final map = item as Map<String, dynamic>;
        final productId = map['productId'] as String;
        final product =
            products.firstWhere((p) => p.id == productId, orElse: () => products.first);
        _cart.add(
          CartItem(
            id: map['id'] as String,
            product: product,
            quantity: map['quantity'] as int,
            selectedVariations:
                (map['selectedVariations'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<List<Product>> getProducts() async {
    await _loadData();
    final list = _data!['products'] as List<dynamic>;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final products = await getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<LiveEvent>> getLiveEvents() async {
    await _loadData();
    final products = await getProducts();
    final list = _data!['liveEvents'] as List<dynamic>;
    return list
        .map((e) => LiveEvent.fromJson(e as Map<String, dynamic>, products))
        .toList();
  }

  Future<LiveEvent?> getLiveEventById(String id) async {
    final events = await getLiveEvents();
    try {
      return events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // Orders operations (mocked)

  Future<List<Order>> getOrdersForUser(String userId) async {
    await _loadData();
    final list = _data!['orders'] as List<dynamic>? ?? [];
    return list
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .where((order) => order.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Auth operations (mocked)

  Future<User?> login(String email, String password) async {
    await _loadData();
    final list = _data!['users'] as List<dynamic>?;
    if (list == null) return null;
    try {
      print(list);
      final match = list.firstWhere(
        (u) =>
            (u as Map<String, dynamic>)['email'] == email &&
            u['password'] == password,
      ) as Map<String, dynamic>;

      _currentUser = User.fromJson(match);
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<User?> getCurrentUser() async {
    await _loadData();
    return _currentUser;
  }

  // Cart operations

  Future<List<CartItem>> getCart() async {
    await _loadData();
    return List<CartItem>.unmodifiable(_cart);
  }

  Future<void> addToCart(
    String productId,
    int quantity, {
    Map<String, String>? variations,
  }) async {
    await _loadData();
    final product = await getProductById(productId);
    if (product == null) {
      throw Exception('Product not found');
    }

    final existingIndex = _cart.indexWhere(
      (item) =>
          item.product.id == productId && _mapsEqual(item.selectedVariations, variations),
    );

    if (existingIndex >= 0) {
      final existing = _cart[existingIndex];
      _cart[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      _cart.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          quantity: quantity,
          selectedVariations: variations,
        ),
      );
    }
  }

  Future<void> updateCartItem(String cartItemId, int quantity) async {
    await _loadData();
    final index = _cart.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      _cart[index] = _cart[index].copyWith(quantity: quantity);
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _loadData();
    _cart.removeWhere((item) => item.id == cartItemId);
  }

  Future<void> clearCart() async {
    await _loadData();
    _cart.clear();
  }

  bool _mapsEqual(Map<String, String>? a, Map<String, String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
