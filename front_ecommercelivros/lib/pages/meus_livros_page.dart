import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/pages/editar_livro_page.dart';
import '../widgets/livrolumina_appbar.dart';
import '../widgets/livrolumina_bottomnav.dart';
import '../widgets/meu_livro_card.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'home_page.dart';

class MeusLivrosPage extends StatelessWidget {
  const MeusLivrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final livros = List.generate(4, (index) => {
      'titulo': 'A natureza das sombras',
      'imagem': 'assets/images/iconelivro.jpg',
      'valor': 35.00,
      'quantidade': 2,
      'aVenda': true,
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const LivroLuminaAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meus livros',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: livros.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final livro = livros[index];
                  return MeuLivroCard(
                    titulo: livro['titulo'] as String,
                    imagemUrl: livro['imagem'] as String,
                    valor: livro['valor'] as double,
                    quantidade: livro['quantidade'] as int,
                    aVenda: livro['aVenda'] as bool,
                    onEditar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditarLivroPage()),
                      );
                    },
                    onDeletar: () {
                      // Ação ao deletar
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ContaPage()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CarrinhoPage()));
              break;
          }
        },
      ),
    );
  }
}
