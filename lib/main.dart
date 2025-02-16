import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'telas/tela_lista.dart';

void main() async {
  // Garante que os bindings do Flutter foram inicializados antes de executar o app
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: 'Gerenciador de Planetas',
      theme: ThemeData(primarySwatch: Colors.blue), // Define o tema do app
      home: TelaInicial(), // Define a tela inicial
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo ao Sistema de Planetas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto informativo para o usuário
            Text(
              'Gerencie seus planetas!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Botão para acessar a tela de cadastro de planetas
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaPlaneta()),
                );
              },
              child: Text('Cadastrar Planeta'),
            ),
            
            SizedBox(height: 10),
            
            // Botão para acessar a lista de planetas cadastrados
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaListaPlanetas()),
                );
              },
              child: Text('Ver Lista de Planetas'),
            ),
          ],
        ),
      ),
    );
  }
}
 