import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PedidoCard extends StatelessWidget {
  final String imagemUrl;
  final String titulo;
  final int quantidade;
  final double valorTotal;
  final int numeroPedido;
  final String data;

  const PedidoCard({
    super.key,
    required this.imagemUrl,
    required this.titulo,
    required this.quantidade,
    required this.valorTotal,
    required this.numeroPedido,
    required this.data,
  });

  @override

  String _formatarData(String dataIso) {
    try {
      final dateTime = DateTime.parse(dataIso);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dataIso; // fallback caso a conversão falhe
    }
  }

  Widget build(BuildContext context) {
    final bool isImageUrlExterna = imagemUrl.startsWith('http');
    final Widget imagemWidget = isImageUrlExterna
        ? Image.network(
      imagemUrl,
      width: 60,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/iconelivro.jpg',
          width: 60,
          height: 80,
          fit: BoxFit.cover,
        );
      },
    )
        : Image.asset(
      imagemUrl.isNotEmpty ? imagemUrl : 'assets/images/iconelivro.jpg',
      width: 60,
      height: 80,
      fit: BoxFit.cover,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imagemWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4C3A32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantidade: $quantidade',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  'Valor total: R\$ ${valorTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'nº $numeroPedido',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4C3A32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _formatarData(data),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
