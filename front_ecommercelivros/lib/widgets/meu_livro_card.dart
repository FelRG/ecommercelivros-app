import 'package:flutter/material.dart';

class MeuLivroCard extends StatelessWidget {
  final String titulo;
  final String imagemUrl;
  final double valor;
  final int quantidade;
  final bool aVenda;
  final VoidCallback onEditar;
  final VoidCallback onDeletar;

  const MeuLivroCard({
    super.key,
    required this.titulo,
    required this.imagemUrl,
    required this.valor,
    required this.quantidade,
    required this.aVenda,
    required this.onEditar,
    required this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8), // Para dar espaçamento entre cards
      decoration: BoxDecoration(
        color: const Color(0xFFE7E3E3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imagemUrl,
              width: 70,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/iconelivro.jpg',
                width: 70,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF432E2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Valor: R\$ ${valor.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF432E2E),
                  ),
                ),
                Text(
                  'Quantidade: $quantidade',
                  style: const TextStyle(
                    color: Color(0xFF432E2E),
                  ),
                ),
                Text(
                  'À venda: ${aVenda ? "Sim" : "Não"}',
                  style: const TextStyle(
                    color: Color(0xFF432E2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48, // Largura controlada para os botões
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF432E2E)),
                  onPressed: onEditar,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF432E2E)),
                  onPressed: onDeletar,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
