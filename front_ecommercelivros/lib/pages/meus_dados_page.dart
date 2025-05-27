import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_appbar.dart';
import 'package:front_ecommercelivros/widgets/livrolumina_bottomnav.dart';
import 'carrinho_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class MeusDadosPage extends StatelessWidget {
  const MeusDadosPage({super.key});

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
              initialValue: 'Fulano de tal',
              readOnly: true,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 16),

            const Text('Email',
                style: TextStyle(fontSize: 16, color: Color(0xFF3B2E2A))),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: 'fulanodetal@gmail.com',
              readOnly: true,
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 16),

            const Text('Senha',
                style: TextStyle(fontSize: 16, color: Color(0xFF3B2E2A))),
            const SizedBox(height: 4),
            TextFormField(
              initialValue: '*******',
              readOnly: true,
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
                    onPressed: () {

                    },
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
