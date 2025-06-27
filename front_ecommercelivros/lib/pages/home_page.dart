import 'dart:async';
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
  final TextEditingController _buscaController = TextEditingController();

  List<Livro> _livros = [];
  String _termoBusca = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _carregarLivrosDisponiveis();

    _buscaController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        final texto = _buscaController.text;
        setState(() {
          _termoBusca = texto;
        });
      });
    });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _carregarLivrosDisponiveis() async {
    final livros = await _livroService.buscarLivrosAVenda();
    final livrosAVenda = livros
        .where((l) => l.estaAVenda == true && l.quantidade > 0)
        .toList();

    setState(() {
      _livros = livrosAVenda;
    });
  }

  @override
  Widget build(BuildContext context) {
    final livrosFiltrados = _termoBusca.trim().length < 3
        ? _livros
        : _livros.where((livro) {
      final busca = _termoBusca.toLowerCase();
      return livro.titulo.toLowerCase().contains(busca) ||
          livro.autor.toLowerCase().contains(busca);
    }).toList();

    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de busca com debounce
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _buscaController,
                decoration: const InputDecoration(
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
              children: livrosFiltrados.map((livro) {
                return ProdutoCard(
                  id: livro.id!,
                  titulo: livro.titulo,
                  preco: 'R\$ ${livro.preco.toStringAsFixed(2)}',
                  imagemUrl:
                  livro.urlImagem ?? 'assets/images/iconelivro.jpg',
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
