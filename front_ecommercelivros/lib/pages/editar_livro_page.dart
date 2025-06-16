import 'package:flutter/material.dart';
import '../models/livro.dart';
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
  final _formKey = GlobalKey<FormState>();

  String estaAVenda = 'Sim';
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
                'Editar livro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4C3A32),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Título', 'Título', 'Aprendendo Flutter'),
              const SizedBox(height: 12),
              _buildTextField('Autor', 'Ex: Thomas Emerson', 'Thomas Emerson'),
              const SizedBox(height: 12),
              _buildTextField('Preço Unitário', 'Ex: 15,00', '29,90'),
              const SizedBox(height: 12),
              _buildTextField('URL da imagem (opcional)', 'Ex: https://ex.com/img/photo.jpg',
                  'https://example.com/flutter.jpg'),
              const SizedBox(height: 12),
              _buildDropdownField('Quantidade', '5'),
              const SizedBox(height: 12),
              _buildMultilineTextField('Descrição', 'Ex: Este livro traz dicas...', 'Guia completo para aprender Flutter e Dart.'),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Salvar alterações do livro
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildTextField(String label, String hint, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: initialValue,
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
          items: List.generate(20, (index) => (index + 1).toString())
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildMultilineTextField(String label, String hint, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          maxLines: 4,
          initialValue: initialValue,
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
          items: opcoesVenda
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
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
