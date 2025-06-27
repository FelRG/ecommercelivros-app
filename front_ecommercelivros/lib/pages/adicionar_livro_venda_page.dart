import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/livro.dart';
import '../persistence/livro_dao.dart';
import '../widgets/livrolumina_appbar.dart';
import '../widgets/livrolumina_bottomnav.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'home_page.dart';

class AdicionarLivroVendaPage extends StatefulWidget {
  const AdicionarLivroVendaPage({super.key});

  @override
  State<AdicionarLivroVendaPage> createState() => _AdicionarLivroVendaPageState();
}

class _AdicionarLivroVendaPageState extends State<AdicionarLivroVendaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _urlImagemController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  String quantidade = '1';
  String estaAVenda = 'Não';
  final List<String> opcoesVenda = ['Sim', 'Não'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LivroLuminaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Adicionar livro para à venda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4C3A32),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Título', 'Título', _tituloController),
              const SizedBox(height: 12),
              _buildTextField('Autor', 'Ex: Thomas Emerson', _autorController),
              const SizedBox(height: 12),
              _buildTextField('Preço Unitário', 'Ex: 15,00', _precoController),
              const SizedBox(height: 12),
              _buildTextField('URL da imagem (opcional)', 'Ex: https://ex.com/img/photo.jpg', _urlImagemController, obrigatorio: false),
              const SizedBox(height: 12),
              _buildDropdownField('Quantidade', '1'),
              const SizedBox(height: 12),
              _buildMultilineTextField('Descrição', 'Ex: Este livro traz dicas...', _descricaoController),
              const SizedBox(height: 12),
              _buildVendaDropdown(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _adicionarLivro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Adicionar livro'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  Future<void> _adicionarLivro() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt('usuario_id');

      if (usuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: usuário não logado.')),
        );
        return;
      }

      final livro = Livro(
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        preco: double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0,
        urlImagem: _urlImagemController.text.isEmpty ? null : _urlImagemController.text.trim(),
        quantidade: int.parse(quantidade),
        descricao: _descricaoController.text.trim(),
        estaAVenda: estaAVenda == 'Sim',
        usuarioId: usuarioId,
      );

      final livroDao = LivroDao();
      await livroDao.insertLivro(livro);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro adicionado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool obrigatorio = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(hint),
          validator: obrigatorio
              ? (value) => value!.isEmpty ? 'Campo obrigatório' : null
              : null,
        ),
      ],
    );
  }


  Widget _buildDropdownField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: quantidade,
          decoration: _inputDecoration(''),
          items: List.generate(20, (index) => (index + 1).toString())
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            setState(() {
              quantidade = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMultilineTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: 4,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildVendaDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Está à venda?', style: _labelStyle()),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: estaAVenda,
          decoration: _inputDecoration(''),
          items: opcoesVenda.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {
              estaAVenda = value!;
            });
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFE7E3E3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF432E2E),
    );
  }
}
