import 'package:flutter/material.dart';
import '../pages/produto_detalhe_page.dart';

class ProdutoCard extends StatelessWidget {
  final int id;
  final String titulo;
  final String preco;
  final String imagemUrl;
  final String autor;
  final int quantidade;
  final String? descricao;

  const ProdutoCard({
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
  Widget build(BuildContext context) {
    // Valida se é uma URL de rede (http/https)
    Uri? uri = Uri.tryParse(imagemUrl);
    bool isUrlValida = uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProdutoDetalhePage(
              id: id,
              titulo: titulo,
              preco: preco,
              imagemUrl: imagemUrl,
              autor: autor,
              quantidade: quantidade,
              descricao: descricao,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: isUrlValida
                  ? Image.network(
                imagemUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/iconelivro.jpg',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/images/iconelivro.jpg',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                preco,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
