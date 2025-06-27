import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../persistence/livro_dao.dart';
import '../widgets/livrolumina_appbar.dart';
import '../widgets/livrolumina_bottomnav.dart';
import 'carrinho_page.dart';
import 'conta_page.dart';
import 'home_page.dart';

class EditarLivroPage extends StatefulWidget {
  final Livro livro;
  const EditarLivroPage({super.key, required this.livro});

  @override
  State<EditarLivroPage> createState() => _EditarLivroPageState();
}

class _EditarLivroPageState extends State<EditarLivroPage> {

  bool _isValidImageUrl(String? url) {
    return url != null && url.startsWith('http') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _precoController;
  late TextEditingController _imagemController;
  late TextEditingController _descricaoController;
  late String _quantidadeSelecionada;
  late String _estaAVenda;

  final List<String> opcoesVenda = ['Sim', 'Não'];

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(text: widget.livro.titulo);
    _autorController = TextEditingController(text: widget.livro.autor);
    _precoController = TextEditingController(text: widget.livro.preco.toStringAsFixed(2));
    _imagemController = TextEditingController(text: widget.livro.urlImagem ?? '');
    _descricaoController = TextEditingController(text: widget.livro.descricao ?? '');
    _quantidadeSelecionada = widget.livro.quantidade.toString();
    _estaAVenda = widget.livro.estaAVenda ? 'Sim' : 'Não';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _precoController.dispose();
    _imagemController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

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
                'Editar livro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4C3A32),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Título', _tituloController, 'Título'),
              const SizedBox(height: 12),
              _buildTextField('Autor', _autorController, 'Ex: Thomas Emerson'),
              const SizedBox(height: 12),
              _buildTextField('Preço', _precoController, 'Ex: 29.90'),
              const SizedBox(height: 12),
              _buildTextField('URL da imagem', _imagemController, 'https://example.com/flutter.jpg'),
              const SizedBox(height: 12),
              Text('Pré-visualização da imagem:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF4C3A32))),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _isValidImageUrl(_imagemController.text)
                    ? Image.network(
                  _imagemController.text,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/iconelivro.jpg',
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              _buildDropdownField('Quantidade', _quantidadeSelecionada),
              const SizedBox(height: 12),
              _buildMultilineTextField('Descrição', _descricaoController, 'Ex: Este livro traz dicas...'),
              const SizedBox(height: 12),
              _buildVendaDropdown(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: _cancelarStyle(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvarAlteracoes,
                      style: _salvarStyle(),
                      child: const Text('Salvar alterações'),
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

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: _inputDecoration(''),
          items: List.generate(101, (i) => i.toString()) // de 0 a 100
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => setState(() => _quantidadeSelecionada = value!),
        ),
      ],
    );
  }

  Widget _buildMultilineTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: 4,
          validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
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
          value: _estaAVenda,
          decoration: _inputDecoration(''),
          items: opcoesVenda.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => _estaAVenda = value!),
        ),
      ],
    );
  }

  void _salvarAlteracoes() async {

    if (_formKey.currentState!.validate()) {
      final novaQuantidade = int.tryParse(_quantidadeSelecionada) ?? 0;

      final livroAtualizado = widget.livro.copyWith(
        titulo: _tituloController.text,
        autor: _autorController.text,
        preco: double.tryParse(_precoController.text) ?? 0.0,
        urlImagem: _imagemController.text,
        quantidade: novaQuantidade,
        descricao: _descricaoController.text,
        estaAVenda: _estaAVenda == 'Sim',
      );

      await LivroDao().updateLivro(livroAtualizado);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livro atualizado com sucesso!')),
        );

        Navigator.pop(context, true); // <- retornar à tela anterior
      }
    }
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

  TextStyle _labelStyle() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF432E2E),
  );

  ButtonStyle _cancelarStyle() => ElevatedButton.styleFrom(
    backgroundColor: Colors.brown,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  ButtonStyle _salvarStyle() => ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
