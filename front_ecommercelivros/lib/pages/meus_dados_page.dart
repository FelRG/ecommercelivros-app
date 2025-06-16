import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_ecommercelivros/models/user.dart';
import 'package:front_ecommercelivros/persistence/user_dao.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import '../persistence/user_dao.dart';
import 'carrinho_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class MeusDadosPage extends StatefulWidget {
  const MeusDadosPage({super.key});

  @override
  State<MeusDadosPage> createState() => _MeusDadosPageState();
}

class _MeusDadosPageState extends State<MeusDadosPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  int? _userId;

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('usuario_id');

    if (id != null) {
      final db = UserDao();
      final usuario = await db.getUserById(id);
      if (usuario != null) {
        setState(() {
          _userId = usuario.id;
          _nomeController.text = usuario.name;
          _emailController.text = usuario.email;
          _senhaController.text = usuario.password;
        });
      }
    }
  }

  Future<void> atualizarDados() async {
    if (_userId == null) return;

    final user = User(
      id: _userId,
      name: _nomeController.text,
      email: _emailController.text,
      password: _senhaController.text,
    );

    await UserDao().updateUser(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_nome', user.name);
    await prefs.setString('usuario_email', user.email);
    await prefs.setString('usuario_senha', user.password);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados atualizados com sucesso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meus dados',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Nome',
                style: TextStyle(fontSize: 16, color: Color(0xFF3B2E2A))),
            const SizedBox(height: 4),
            TextFormField(
              controller: _nomeController,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 16),

            const Text('Email',
                style: TextStyle(fontSize: 16, color: Color(0xFF3B2E2A))),
            const SizedBox(height: 4),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 16),

            const Text('Senha',
                style: TextStyle(fontSize: 16, color: Color(0xFF3B2E2A))),
            const SizedBox(height: 4),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: _inputDecoration().copyWith(
                suffixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: atualizarDados,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Atualizar dados'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CarrinhoPage()));
              break;
            case 3:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuPage()));
              break;
          }
        },
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade300,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
