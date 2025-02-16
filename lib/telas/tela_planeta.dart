import 'package:flutter/material.dart';
import 'package:myapp/modelo/planeta.dart';
import 'package:myapp/controles/controle_planeta.dart';

class TelaCadastroPlaneta extends StatelessWidget {
  const TelaCadastroPlaneta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Planetas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Aqui você pode cadastrar um planeta!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaPlaneta()),
                );
              },
              child: Text('Ir para Cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaPlaneta extends StatefulWidget {
  const TelaPlaneta({super.key});

  @override
  _TelaPlanetaState createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final List<Planeta> planetas = [];
  final _formKey = GlobalKey<FormState>();

  String? _nome;
  double? _distanciaSol;
  double? _tamanho;
  String? _apelido;

  final _nomeController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _tamanhoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(() => setState(() {}));
    _distanciaController.addListener(() => setState(() {}));
    _tamanhoController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _distanciaController.dispose();
    _tamanhoController.dispose();
    super.dispose();
  }

  // Função para cadastrar um novo planeta
  void _cadastrarPlaneta() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final novoPlaneta = Planeta(
        nome: _nome!,
        distanciaSol: _distanciaSol!,
        tamanho: _tamanho!,
        apelido: _apelido,
      );

      await PlanetaDatabase.instance.createPlaneta(novoPlaneta);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Planeta cadastrado com sucesso!')),
      );

      Navigator.pop(context); // Retorna para a tela inicial
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Planetas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para inserir o nome do planeta
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do planeta'),
                autovalidateMode: AutovalidateMode.onUserInteraction,  
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o nome do planeta.'; 
                  }
                  if (value.length < 3) {
                    return 'Deve ter no mínimo 3 caracteres.';
                  }
                  return null;
                },
                onSaved: (value) => _nome = value,
              ),
              // Campo para inserir a distância do Sol
              TextFormField(
                controller: _distanciaController,
                decoration: InputDecoration(labelText: 'Distância do sol (UA)'),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe a distância do sol.';
                  }
                 if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Deve ser um valor positivo e válido.';
                  }
                  return null;
                },
                onSaved: (value) => _distanciaSol = double.parse(value!),
              ),
              // Campo para inserir o tamanho do planeta
              TextFormField(
                controller: _tamanhoController,
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o tamanho do planeta.';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Deve ser um valor positivo e válido.';
                  }
                  return null;
                },
                onSaved: (value) => _tamanho = double.parse(value!),
              ),
              // Campo opcional para inserir um apelido
              TextFormField(
                decoration: InputDecoration(labelText: 'Apelido (opcional)'),
                onSaved: (value) => _apelido = value,
              ),
              SizedBox(height: 20),
              // Botão para cadastrar o planeta
              ElevatedButton(
                onPressed: _cadastrarPlaneta,
                child: Text('Cadastrar Planeta'),
              ),
              SizedBox(height: 20),
              // Lista de planetas cadastrados
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: planetas.length,
                itemBuilder: (context, index) {
                  final planeta = planetas[index];
                  return ListTile(
                    title: Text(planeta.nome),
                    subtitle: Text(
                        'Distância do sol: ${planeta.distanciaSol} UA, Tamanho: ${planeta.tamanho} km, Apelido: ${planeta.apelido ?? "N/A"}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}