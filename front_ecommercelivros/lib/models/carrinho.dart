class Carrinho {
  final int? id;
  final int usuarioId;
  final int livroId;
  final int quantidade;

  Carrinho({
    this.id,
    required this.usuarioId,
    required this.livroId,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'livro_id': livroId,
      'quantidade': quantidade,
    };
  }

  factory Carrinho.fromMap(Map<String, dynamic> map) {
    return Carrinho(
      id: map['id'],
      usuarioId: map['usuario_id'],
      livroId: map['livro_id'],
      quantidade: map['quantidade'],
    );
  }
}
