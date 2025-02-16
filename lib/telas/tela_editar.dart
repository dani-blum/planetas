import 'package:flutter/material.dart';
import 'package:myapp/modelo/planeta.dart';
import 'package:myapp/controles/controle_planeta.dart';

// Tela para editar informações de um planeta já cadastrado
class TelaEditarPlaneta extends StatefulWidget {
  final Planeta planeta;

  const TelaEditarPlaneta({super.key, required this.planeta});

  @override
  _TelaEditarPlanetaState createState() => _TelaEditarPlanetaState();
}

class _TelaEditarPlanetaState extends State<TelaEditarPlaneta> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  late TextEditingController _nomeController;
  late TextEditingController _distanciaController;
  late TextEditingController _tamanhoController;
  late TextEditingController _apelidoController;

  @override
  void initState() {
    super.initState();
    // Inicializa os campos com os valores do planeta recebido
    _nomeController = TextEditingController(text: widget.planeta.nome);
    _distanciaController = TextEditingController(text: widget.planeta.distanciaSol.toString());
    _tamanhoController = TextEditingController(text: widget.planeta.tamanho.toString());
    _apelidoController = TextEditingController(text: widget.planeta.apelido ?? '');
  }

  @override
  void dispose() {
    // Libera os controladores para evitar vazamento de memória
    _nomeController.dispose();
    _distanciaController.dispose();
    _tamanhoController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  // Método para atualizar os dados do planeta no banco de dados
  void _atualizarPlaneta() async {
    if (_formKey.currentState!.validate()) {
      final planetaAtualizado = Planeta(
        id: widget.planeta.id,
        nome: _nomeController.text,
        distanciaSol: double.parse(_distanciaController.text),
        tamanho: double.parse(_tamanhoController.text),
        apelido: _apelidoController.text.isNotEmpty ? _apelidoController.text : null,
      );
      await PlanetaDatabase.instance.updatePlaneta(planetaAtualizado);
      Navigator.pop(context); // Retorna à tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Planeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _distanciaController,
                decoration: InputDecoration(labelText: 'Distância do sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe a distância' : null,
              ),
              TextFormField(
                controller: _tamanhoController,
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o tamanho' : null,
              ),
              TextFormField(
                controller: _apelidoController,
                decoration: InputDecoration(labelText: 'Apelido (opcional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarPlaneta,
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
