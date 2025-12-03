import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cart_bloc.dart';
import '../../services/mock_api_service.dart';
import '../../models/product.dart';
part 'components/variation_selector.dart';
part 'components/quantity_selector.dart';
part 'components/product_image.dart';
part 'components/product_details_panel.dart';

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
                                child: _ProductImage(
                                  imageUrl: product.images.isNotEmpty
                                      ? product.images.first
                                      : product.thumbnail,
                                  isWide: isWide,
                                ),
                              ),
                              SizedBox(
                                width: isWide ? 24 : 0,
                                height: isWide ? 0 : 24,
                              ),
                              // Details + actions
                              Expanded(
                                flex: 1,
                                child: _ProductDetailsPanel(
                                  product: product,
                                  price: price,
                                  sizes: _sizes,
                                  colors: _colors,
                                  types: _types,
                                  selectedSize: _selectedSize,
                                  selectedColor: _selectedColor,
                                  selectedType: _selectedType,
                                  onSizeChanged: (v) => setState(() => _selectedSize = v),
                                  onColorChanged: (v) => setState(() => _selectedColor = v),
                                  onTypeChanged: (v) => setState(() => _selectedType = v),
                                  quantity: _quantity,
                                  onQuantityChanged: (q) => setState(() => _quantity = q),
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

