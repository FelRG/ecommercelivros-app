import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:front_ecommercelivros/widgets/produto_card_carrinho.dart';

import 'conta_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final List<Map<String, dynamic>> produtos = [
    {'titulo': 'Hygge: The Danish Way To Live Well', 'preco': 36.99},
    {'titulo': 'Hygge: The Danish Way To Live Well', 'preco': 36.99},
  ];

  double get subtotal =>
      produtos.fold(0, (soma, p) => soma + (p['preco'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carrinho',
              style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),),
            ),
            const SizedBox(height: 8),
            Text(
              'Subtotal: R\$ ${subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ação para realizar compra
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Realizar compra',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: produtos
                  .map((p) => const ProdutoCardCarrinho()) // para este exemplo, mesmo produto
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ContaPage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
