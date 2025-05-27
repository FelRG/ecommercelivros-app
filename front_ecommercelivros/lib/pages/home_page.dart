import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:front_ecommercelivros/widgets/produto_card.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'menu_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final produtos = List.generate(4, (index) => {
      'titulo': 'Hygge: The Danish Way To Live Well',
      'preco': 'R\$ 36,99',
      'imagemUrl': 'assets/images/iconelivro.jpg', // ajuste o caminho
    });

    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de busca com lupa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Pesquise algum livro',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ofertas para você',
              style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: produtos
                  .map((p) => ProdutoCard(
                titulo: p['titulo']!,
                preco: p['preco']!,
                imagemUrl: p['imagemUrl']!,
              ))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ContaPage()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const CarrinhoPage()));
              break;
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MenuPage()));
              break;
          }
        },
      ),
    );
  }
}
