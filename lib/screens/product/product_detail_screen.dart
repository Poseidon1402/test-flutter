import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cart_bloc.dart';
import '../../services/mock_api_service.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _loading = true;
  String? _selectedSize;
  String? _selectedColor;
  String? _selectedType; // for beauty product type variations
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = MockApiService();
    final prod = await api.getProductById(widget.productId);
    setState(() {
      _product = prod;
      _loading = false;
      _selectedSize = _sizes.isNotEmpty ? _sizes.first : null;
      _selectedColor = _colors.isNotEmpty ? _colors.first : null;
      _selectedType = _types.isNotEmpty ? _types.first : null;
    });
  }

  List<String> get _sizes =>
      (_product?.variations?['size'] as List<dynamic>? ?? []).cast<String>();
  List<String> get _colors =>
      (_product?.variations?['color'] as List<dynamic>? ?? []).cast<String>();
  List<String> get _types =>
      (_product?.variations?['type'] as List<dynamic>? ?? []).cast<String>();

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final product = _product!;
    final price = product.salePrice ?? product.price;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1729), Color(0xFF1A1D2E), Color(0xFF2D1B4E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Product Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Main content
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 800;
                          return Flex(
                            direction: isWide ? Axis.horizontal : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Images
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    product.images.isNotEmpty
                                        ? product.images.first
                                        : product.thumbnail,
                                    fit: BoxFit.cover,
                                    height: isWide ? 420 : 260,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: isWide ? 24 : 0,
                                height: isWide ? 0 : 24,
                              ),
                              // Details + actions
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Text(
                                            '\u20ac${price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF9D4EDD),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          if (product.salePrice != null)
                                            Text(
                                              '\u20ac${product.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white.withOpacity(
                                                  0.6,
                                                ),
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Variations
                                      if (_sizes.isNotEmpty)
                                        _VariationSelector(
                                          label: 'Size',
                                          options: _sizes,
                                          value: _selectedSize,
                                          onChanged: (v) =>
                                              setState(() => _selectedSize = v),
                                        ),
                                      if (_colors.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        _VariationSelector(
                                          label: 'Color',
                                          options: _colors,
                                          value: _selectedColor,
                                          onChanged: (v) => setState(
                                            () => _selectedColor = v,
                                          ),
                                        ),
                                      ],
                                      if (_types.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        _VariationSelector(
                                          label: 'Type',
                                          options: _types,
                                          value: _selectedType,
                                          onChanged: (v) =>
                                              setState(() => _selectedType = v),
                                        ),
                                      ],

                                      // Quantity selector
                                      const SizedBox(height: 16),
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 140,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2D3E),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              splashRadius: 20,
                                              icon: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _quantity = _quantity > 1
                                                      ? _quantity - 1
                                                      : 1;
                                                });
                                              },
                                            ),
                                            Text(
                                              '$_quantity',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            IconButton(
                                              splashRadius: 20,
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _quantity = _quantity < 99
                                                      ? _quantity + 1
                                                      : 99;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF9D4EDD),
                                                    Color(0xFF7B2CBF),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  final variations =
                                                      <String, String>{};
                                                  if (_selectedSize != null) {
                                                    variations['size'] =
                                                        _selectedSize!;
                                                  }
                                                  if (_selectedColor != null) {
                                                    variations['color'] =
                                                        _selectedColor!;
                                                  }
                                                  if (_selectedType != null) {
                                                    variations['type'] =
                                                        _selectedType!;
                                                  }
                                                  context.read<CartBloc>().add(
                                                    CartItemAdded(
                                                      productId: product.id,
                                                      quantity: _quantity,
                                                      variations:
                                                          variations.isEmpty
                                                          ? null
                                                          : variations,
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Ajouté: ${product.name} (x$_quantity)',
                                                      ),
                                                      backgroundColor:
                                                          const Color(
                                                            0xFF9D4EDD,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Ajouter au panier',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          OutlinedButton(
                                            onPressed: () {
                                              // Potential quick checkout navigation
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text(
                                              'Acheter maintenant',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VariationSelector extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _VariationSelector({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2A2D3E),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2D3E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF9D4EDD), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
