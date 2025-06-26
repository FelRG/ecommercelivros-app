import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:front_ecommercelivros/pages/home_page.dart';
import 'package:front_ecommercelivros/pages/carrinho_page.dart';
import 'package:front_ecommercelivros/pages/menu_page.dart';
import 'package:front_ecommercelivros/widgets/pedido_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../persistence/compra_dao.dart'; // widget criado

class MeusPedidosPage extends StatefulWidget {
  const MeusPedidosPage({super.key});

  @override
  State<MeusPedidosPage> createState() => _MeusPedidosPageState();
}

class _MeusPedidosPageState extends State<MeusPedidosPage> {
  List<Map<String, dynamic>> pedidos = [];

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt('usuario_id');

    if (usuarioId == null) {
      // Tratar usuário não logado, por exemplo, mostrando mensagem ou redirecionando
      return;
    }

    final compraDao = CompraDao();
    final dadosPedidos = await compraDao.getComprasUsuario(usuarioId);

    setState(() {
      pedidos = dadosPedidos;
    });
  }

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
              child: pedidos.isEmpty
                  ? const Center(child: Text('Nenhum pedido encontrado.'))
                  : ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return PedidoCard(
                    imagemUrl: pedido['imagemUrl'] ?? 'assets/images/iconelivro.jpg',
                    titulo: pedido['titulo'] ?? 'Pedido sem título',
                    quantidade: pedido['quantidade_total'] ?? 0,
                    valorTotal: pedido['total']?.toDouble() ?? 0,
                    numeroPedido: pedido['compra_id'],
                    data: pedido['data_compra'] ?? '',
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

