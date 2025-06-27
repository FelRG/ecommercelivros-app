import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/carrinho.dart';
import '../persistence/carrinho_dao.dart';
import '../widgets/livrolumina_appbar.dart';
import '../widgets/livrolumina_bottomnav.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'menu_page.dart';

class ProdutoDetalhePage extends StatefulWidget {
  final int id;
  final String titulo;
  final String preco;
  final String imagemUrl;
  final String autor;
  final int quantidade;
  final String? descricao;

  const ProdutoDetalhePage({
    super.key,
    required this.id,
    required this.titulo,
    required this.preco,
    required this.imagemUrl,
    required this.autor,
    required this.quantidade,
    this.descricao,
  });

  @override
  State<ProdutoDetalhePage> createState() => _ProdutoDetalhePageState();
}

class _ProdutoDetalhePageState extends State<ProdutoDetalhePage> {
  int quantidadeSelecionada = 1;


  @override
  Widget build(BuildContext context) {

    Uri? uri = Uri.tryParse(widget.imagemUrl);
    bool isUrlValida = uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');

    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(
            //   widget.imagemUrl,
            //   height: 220,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) => Image.asset(
            //     'assets/images/iconelivro.jpg',
            //     height: 220,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            isUrlValida
                ? Image.network(
              widget.imagemUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/iconelivro.jpg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Image.asset(
              'assets/images/iconelivro.jpg',
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
            Text(
              'Por ${widget.autor}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            // if (widget.descricao != null && widget.descricao!.isNotEmpty)
            //   Text(
            //     widget.descricao!,
            //     style: const TextStyle(fontSize: 16),
            //   ),
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
                    widget.quantidade,
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
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final idUsuarioLogado = prefs.getInt('usuario_id');

                  if (idUsuarioLogado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuário não está logado.')),
                    );
                    return;
                  }

                  final carrinhoDao = CarrinhoDao();
                  await carrinhoDao.adicionarAoCarrinho(
                    Carrinho(
                      usuarioId: idUsuarioLogado,
                      livroId: widget.id,
                      quantidade: quantidadeSelecionada,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Livro adicionado ao carrinho!')),
                  );
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
