import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/cart/cart_bloc.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible:
          context.read<AuthBloc>().state.status == AuthStatus.authenticated,
      child: Badge(
        backgroundColor: Colors.red,
        label: Text(
          context.watch<CartBloc>().state.items.length.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        child: IconButton(
          onPressed: () => context.push('/cart'),
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 24,
          ),
          tooltip: 'Cart',
        ),
      ),
    );
  }
}
