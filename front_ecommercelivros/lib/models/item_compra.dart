class ItemCompra {
  final int? id;
  final int compraId;
  final int livroId;
  final int quantidade;
  final double precoUnitario;

  ItemCompra({
    this.id,
    required this.compraId,
    required this.livroId,
    required this.quantidade,
    required this.precoUnitario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'compra_id': compraId,
      'livro_id': livroId,
      'quantidade': quantidade,
      'preco_unitario': precoUnitario,
    };
  }

  factory ItemCompra.fromMap(Map<String, dynamic> map) {
    return ItemCompra(
      id: map['id'],
      compraId: map['compra_id'],
      livroId: map['livro_id'],
      quantidade: map['quantidade'],
      precoUnitario: map['preco_unitario'],
    );
  }
}
