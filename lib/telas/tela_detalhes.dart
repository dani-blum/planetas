import 'package:flutter/material.dart';
import 'package:myapp/modelo/planeta.dart';

/// Tela que exibe os detalhes de um planeta selecionado.
class TelaDetalhesPlaneta extends StatelessWidget {
  final Planeta planeta; // Objeto do planeta que será exibido.

  const TelaDetalhesPlaneta({super.key, required this.planeta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Planeta')), // Título da tela
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento ao redor do conteúdo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha os textos à esquerda
          children: [
            // Nome do planeta destacado
            Text(
              planeta.nome,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), // Espaço entre os elementos

            // Exibe o apelido caso exista
            if (planeta.apelido != null && planeta.apelido!.isNotEmpty)
              Text(
                'Apelido: ${planeta.apelido}',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 10),

            // Exibe a distância do planeta até o Sol
            Text(
              'Distância do Sol: ${planeta.distanciaSol} UA',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Exibe o tamanho do planeta
            Text(
              'Tamanho: ${planeta.tamanho} km',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
