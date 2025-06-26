import 'package:flutter/material.dart';

class ProdutoCardCarrinho extends StatefulWidget {
  final String titulo;
  final double preco;
  final String imagemUrl;
  final int quantidadeInicial;
  final VoidCallback? onExcluir;
  final ValueChanged<int>? onQuantidadeAlterada;

  const ProdutoCardCarrinho({
    super.key,
    required this.titulo,
    required this.preco,
    required this.imagemUrl,
    required this.quantidadeInicial,
    this.onExcluir,
    this.onQuantidadeAlterada,
  });

  @override
  State<ProdutoCardCarrinho> createState() => _ProdutoCardCarrinhoState();
}

class _ProdutoCardCarrinhoState extends State<ProdutoCardCarrinho> {
  late int quantidade;

  @override
  void initState() {
    super.initState();
    quantidade = widget.quantidadeInicial;
  }

  void _alterarQuantidade(int novaQuantidade) {
    setState(() {
      quantidade = novaQuantidade;
    });
    if (widget.onQuantidadeAlterada != null) {
      widget.onQuantidadeAlterada!(quantidade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100, // limite seguro
              height: 140,
              child: widget.imagemUrl.startsWith('http')
                  ? Image.network(
                widget.imagemUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset('assets/images/iconelivro.jpg', fit: BoxFit.cover),
              )
                  : Image.asset(
                'assets/images/iconelivro.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${widget.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quantidade',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantidade > 1
                            ? () => _alterarQuantidade(quantidade - 1)
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                        ),
                        child: Text(
                          quantidade.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _alterarQuantidade(quantidade + 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: widget.onExcluir,
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

