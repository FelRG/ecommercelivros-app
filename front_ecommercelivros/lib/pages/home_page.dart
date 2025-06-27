import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:front_ecommercelivros/widgets/produto_card.dart';
import '../models/livro.dart';
import '../service/livro_service.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LivroService _livroService = LivroService();
  List<Livro> _livros = [];

  @override
  void initState() {
    super.initState();
    _carregarLivrosDisponiveis();
  }

  Future<void> _carregarLivrosDisponiveis() async {
    final livros = await _livroService.buscarLivrosAVenda();
    final livrosAVenda = livros.where((l) => l.estaAVenda == true && l.quantidade > 0).toList();

    setState(() {
      _livros = livrosAVenda;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de busca
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _livros.map((livro) {
                return ProdutoCard(
                  id: livro.id!,
                  titulo: livro.titulo,
                  preco: 'R\$ ${livro.preco.toStringAsFixed(2)}',
                  imagemUrl: livro.urlImagem ?? 'assets/images/iconelivro.jpg',
                  autor: livro.autor,
                  quantidade: livro.quantidade,
                  descricao: livro.descricao,
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ContaPage()),
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
