import 'package:flutter/material.dart';

class ProdutoCardCarrinho extends StatefulWidget {
  const ProdutoCardCarrinho({super.key});

  @override
  State<ProdutoCardCarrinho> createState() => _ProdutoCardCarrinhoState();
}

class _ProdutoCardCarrinhoState extends State<ProdutoCardCarrinho> {
  int quantidade = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Imagem do produto
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/iconelivro.jpg', // Substitua com o caminho correto da imagem
              width: 120,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),

          // Detalhes do produto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hygge: The Danish Way To Live Well',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'R\$ 36,99',
                    style: TextStyle(
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
                        onPressed: () {
                          if (quantidade > 1) {
                            setState(() => quantidade--);
                          }
                        },
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
                        onPressed: () {
                          setState(() => quantidade++);
                        },
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
                    onPressed: () {
                      // lógica de exclusão
                    },
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
