import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:front_ecommercelivros/pages/home_page.dart';
import 'package:front_ecommercelivros/pages/carrinho_page.dart';
import 'package:front_ecommercelivros/pages/menu_page.dart';
import 'package:front_ecommercelivros/widgets/pedido_card.dart'; // widget criado

class MeusPedidosPage extends StatelessWidget {
  const MeusPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meus pedidos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 6, // exemplo com 6 pedidos
                itemBuilder: (context, index) {
                  return const PedidoCard(
                    imagemUrl: 'assets/images/iconelivro.jpg',
                    titulo: 'A natureza das sombras',
                    quantidade: 2,
                    valorTotal: 60.00,
                    numeroPedido: 375,
                    data: '13/07/2024',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CarrinhoPage()),
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
