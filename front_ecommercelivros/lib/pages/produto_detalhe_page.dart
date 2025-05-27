import 'package:flutter/material.dart';

import '../widgets/livrolumina_appbar.dart';

class ProdutoDetalhePage extends StatefulWidget {
  final String titulo;
  final String preco;
  final String imagemUrl;

  const ProdutoDetalhePage({
    super.key,
    required this.titulo,
    required this.preco,
    required this.imagemUrl,
  });

  @override
  State<ProdutoDetalhePage> createState() => _ProdutoDetalhePageState();
}

class _ProdutoDetalhePageState extends State<ProdutoDetalhePage> {
  int quantidadeSelecionada = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.imagemUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Por Anderson Tsar', // Ou passe como parâmetro depois
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.preco,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<int>(
                value: quantidadeSelecionada,
                underline: const SizedBox(),
                isExpanded: true,
                items: List.generate(
                  10,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('Quantidade: ${index + 1}'),
                  ),
                ),
                onChanged: (valor) {
                  setState(() {
                    quantidadeSelecionada = valor!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // lógica para adicionar ao carrinho
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1C40F), // amarelo
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Adicionar ao carrinho',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF4C3A32),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
