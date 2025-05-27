import 'package:flutter/material.dart';

class LivroLuminaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const LivroLuminaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.brown,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Conta'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrinho'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      ],
    );
  }
}
