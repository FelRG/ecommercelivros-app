import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:front_ecommercelivros/widgets/produto_card_carrinho.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database.dart';
import '../persistence/carrinho_dao.dart';
import '../persistence/compra_dao.dart';
import 'conta_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  List<Map<String, dynamic>> produtos = [];
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _carregarCarrinho();
  }

  Future<void> _carregarCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    usuarioId = prefs.getInt('usuario_id');

    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não está logado.')),
      );
      return;
    }

    final carrinhoDao = CarrinhoDao();
    final resultados = await carrinhoDao.getCarrinhoCompleto(usuarioId!);

    setState(() {
      produtos = resultados;
    });
  }

  Future<void> _excluirProduto(int produtoId) async {
    final carrinhoDao = CarrinhoDao();
    await carrinhoDao.removerDoCarrinho(produtoId);
    _carregarCarrinho();
  }

  Future<void> _atualizarQuantidade(int produtoId, int novaQuantidade) async {
    final carrinhoDao = CarrinhoDao();
    await carrinhoDao.atualizarQuantidade(produtoId, novaQuantidade);
    _carregarCarrinho();
  }

  Future<void> realizarCompra() async {
    final compraDao = CompraDao();

    try {
      await compraDao.realizarCompra(produtos);
      _carregarCarrinho();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada com sucesso!')),
      );
    } catch (e) {
      // Mostra erro caso não tenha estoque suficiente ou outro erro qualquer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


  double get subtotal =>
      produtos.fold(0, (soma, p) => soma + (p['preco'] * p['quantidade']));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: produtos.isEmpty
          ? const Center(
        child: Text(
          'Nenhum livro no carrinho.'
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carrinho',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xFF4C3A32)),
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
                onPressed: realizarCompra,
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
              children: produtos.map((p) {
                return ProdutoCardCarrinho(
                  id: p['carrinho_id'],
                  titulo: p['titulo'],
                  preco: p['preco'],
                  imagemUrl: p['urlImagem'] ?? 'assets/images/iconelivro.jpg',
                  quantidadeInicial: p['quantidade'],
                  onExcluir: () => _excluirProduto(p['carrinho_id']),
                  onQuantidadeAlterada: (novaQtd) =>
                      _atualizarQuantidade(p['carrinho_id'], novaQtd),
                );
              }).toList(),
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
