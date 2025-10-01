import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro Aluno',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AlunoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AlunoScreen extends StatefulWidget {
  const AlunoScreen({Key? key}) : super(key: key);

  @override
  State<AlunoScreen> createState() => _AlunoScreenState();
}

class _AlunoScreenState extends State<AlunoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _nota1Controller = TextEditingController();
  final TextEditingController _nota2Controller = TextEditingController();

  bool _exibirSituacao = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _matriculaController.dispose();
    _nota1Controller.dispose();
    _nota2Controller.dispose();
    super.dispose();
  }

  String _determinarSituacao(double media) {
    if (media >= 7) return 'Aprovado';
    if (media >= 4) return 'Recuperação';
    return 'Reprovado';
  }

  void _processar() {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeController.text.trim();
    final matricula = _matriculaController.text.trim();

    final nota1Str = _nota1Controller.text.trim().replaceAll(',', '.');
    final nota2Str = _nota2Controller.text.trim().replaceAll(',', '.');

    final nota1 = double.tryParse(nota1Str);
    final nota2 = double.tryParse(nota2Str);

    if (nota1 == null || nota2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira valores numéricos válidos para as notas.')),
      );
      return;
    }

    final media = (nota1 + nota2) / 2;
    final situacao = _determinarSituacao(media);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resultado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: $nome'),
            Text('Matrícula: $matricula'),
            Text('Média: ${media.toStringAsFixed(2)}'),
            if (_exibirSituacao) Text('Situação: $situacao'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Validators
  String? _validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  String? _validateNota(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    final normalized = value.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return 'Digite um número válido';
    if (parsed < 0 || parsed > 10) return 'Nota deve estar entre 0 e 10';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aluno')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.school, size: 96),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: _validateNotEmpty,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _matriculaController,
                decoration: const InputDecoration(
                  labelText: 'Matrícula',
                  border: OutlineInputBorder(),
                ),
                validator: _validateNotEmpty,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nota1Controller,
                decoration: const InputDecoration(
                  labelText: 'Primeira Nota',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateNota,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nota2Controller,
                decoration: const InputDecoration(
                  labelText: 'Segunda Nota',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateNota,
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                title: const Text('Exibir Situação'),
                value: _exibirSituacao,
                onChanged: (v) => setState(() => _exibirSituacao = v),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processar,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('Processar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
