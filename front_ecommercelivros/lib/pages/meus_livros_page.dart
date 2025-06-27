import 'package:flutter/material.dart';
import 'package:front_ecommercelivros/pages/editar_livro_page.dart';
import '../widgets/livrolumina_appbar.dart';
import '../widgets/livrolumina_bottomnav.dart';
import '../widgets/meu_livro_card.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'home_page.dart';
import '../models/livro.dart';
import '../persistence/livro_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MeusLivrosPage extends StatefulWidget {
  const MeusLivrosPage({super.key});

  @override
  State<MeusLivrosPage> createState() => _MeusLivrosPageState();
}

class _MeusLivrosPageState extends State<MeusLivrosPage> {
  late Future<List<Livro>> _livrosFuture;

  bool _isValidUrl(String? url) {
    return url != null && url.startsWith('http') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  Future<List<Livro>> _carregarLivrosDoUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt('usuario_id');

      if (usuarioId == null) {
        debugPrint('Usuário não logado (ID nulo)');
        return [];
      }

      return await LivroDao().getLivrosDoUsuario(usuarioId);
    } catch (e, stack) {
      debugPrint('Erro ao buscar livros do usuário: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }


  @override
  void initState() {
    super.initState();
    _livrosFuture = _carregarLivrosDoUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const LivroLuminaAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meus livros',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4C3A32),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Livro>>(
                future: _livrosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar livros.'));
                  }

                  final livros = snapshot.data ?? [];

                  if (livros.isEmpty) {
                    return const Center(child: Text('Nenhum livro cadastrado.'));
                  }

                  return ListView.separated(
                    itemCount: livros.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final livro = livros[index];
                      return MeuLivroCard(
                        titulo: livro.titulo,
                        imagemUrl: _isValidUrl(livro.urlImagem) ? livro.urlImagem! : 'assets/images/iconelivro.jpg',
                        valor: livro.preco,
                        quantidade: livro.quantidade,
                        aVenda: livro.estaAVenda,
                        onEditar: () async {
                          final resultado = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarLivroPage(livro: livro),
                            ),
                          );

                          if (resultado == true) {
                            // Recarrega os livros, pois houve alteração
                            setState(() {
                              _livrosFuture = _carregarLivrosDoUsuario();
                            });
                          }
                        },
                        onDeletar: () async {
                          await LivroDao().deleteLivro(livro.id!);
                          setState(() {
                            _livrosFuture = _carregarLivrosDoUsuario();
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LivroLuminaBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ContaPage()));
              break;
            case 2:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CarrinhoPage()));
              break;
          }
        },
      ),
    );
  }
}
