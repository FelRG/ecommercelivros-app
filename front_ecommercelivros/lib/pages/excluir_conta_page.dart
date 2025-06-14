import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../persistence/user_dao.dart';
import 'carrinho_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'menu_page.dart';


class ExcluirContaPage extends StatelessWidget {
  const ExcluirContaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Excluir conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Você tem certeza que deseja excluir a sua conta?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Voltar para a página anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getInt('usuario_id');

                  if (userId != null) {
                    // 1. Excluir do banco local
                    await UserDao().deleteUser(userId);

                    // 2. Limpar cache
                    await prefs.remove('usuario_id');
                    await prefs.remove('usuario_nome');
                    await prefs.remove('usuario_email');
                    await prefs.remove('usuario_senha');

                    // 3. Redirecionar para login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  } else {
                    // Caso ocorra algum erro ou usuário não encontrado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erro ao excluir conta.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A5F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Excluir conta',
                  style: TextStyle(fontSize: 16),
                ),
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
