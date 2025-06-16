class Livro {
  final int? id;
  final String titulo;
  final String autor;
  final double preco;
  final String? urlImagem;
  final int quantidade;
  final String? descricao;
  final bool estaAVenda;
  final int usuarioId;

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.preco,
    this.urlImagem,
    required this.quantidade,
    this.descricao,
    required this.estaAVenda,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'preco': preco,
      'urlImagem': urlImagem,
      'quantidade': quantidade,
      'descricao': descricao,
      'estaAVenda': estaAVenda ? 1 : 0,
      'usuario_id': usuarioId,
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      preco: map['preco'],
      urlImagem: map['urlImagem'],
      quantidade: map['quantidade'],
      descricao: map['descricao'],
      estaAVenda: map['estaAVenda'] == 1,
      usuarioId: map['usuario_id'],
    );
  }

  Livro copyWith({
    int? id,
    String? titulo,
    String? autor,
    double? preco,
    String? urlImagem,
    int? quantidade,
    String? descricao,
    bool? estaAVenda,
    int? usuarioId,
  }) {
    return Livro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      preco: preco ?? this.preco,
      urlImagem: urlImagem ?? this.urlImagem,
      quantidade: quantidade ?? this.quantidade,
      descricao: descricao ?? this.descricao,
      estaAVenda: estaAVenda ?? this.estaAVenda,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

}
