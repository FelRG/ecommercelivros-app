import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'carrinho_page.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'meus_dados_page.dart';
import 'meus_pedidos_page.dart';
import 'excluir_conta_page.dart';

class ContaPage extends StatefulWidget {
  const ContaPage({super.key});

  @override
  State<ContaPage> createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  String _nomeUsuario = '';

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUsuario = prefs.getString('usuario_nome') ?? 'Usuário';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sua conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 16),
            // Exibindo "Olá, {nomeDoUsuario}"
            Text(
              'Olá, $_nomeUsuario!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 32),
            _buildOptionButton(context, 'Meus dados', () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeusDadosPage()),
              );
              // Após retornar da MeusDadosPage, recarrega o nome atualizado da cache
              await _carregarNomeUsuario();
            }),
            const SizedBox(height: 16),
            _buildOptionButton(context, 'Meus pedidos', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeusPedidosPage()),
              );
            }),
            const SizedBox(height: 32),
            _buildDeleteButton(context, 'Excluir conta', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExcluirContaPage()),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const CarrinhoPage()));
              break;
            case 3:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const MenuPage()));
              break;
          }
        },
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title,
      VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF4C3A32),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18,
            color: Color(0xFF4C3A32)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, String title,
      VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF5A5F), // vermelho claro como na imagem
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
