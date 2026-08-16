import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Nutrición',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FormularioNutricion(),
    );
  }
}

class FormularioNutricion extends StatefulWidget {
  const FormularioNutricion({super.key});

  @override
  State<FormularioNutricion> createState() => _FormularioNutricionState();
}

class _FormularioNutricionState extends State<FormularioNutricion> {
  // Controladores para capturar el texto ingresado
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  String _resultado = '';

  // Función para consultar la API
Future<String> _obtenerEstadoBackend() async {
    try {
      // Usamos la IP real de tu PC en la red Wi-Fi local
      final res = await http.get(Uri.parse('http://192.168.0.113:8000/health'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return "${data['message']} (v${data['version']})";
      }
      return 'Error al responder la API (${res.statusCode})';
    } catch (e) {
      return 'API no detectada en local';
    }
  }

  void _calcularIMC() {
    double? peso = double.tryParse(_pesoController.text);
    double? altura = double.tryParse(_alturaController.text);

    if (peso != null && altura != null && altura > 0) {
      double imc = peso / (altura * altura);
      setState(() {
        _resultado = 'Hola ${_nombreController.text}, tu IMC es: ${imc.toStringAsFixed(1)}';
      });
    } else {
      setState(() {
        _resultado = 'Por favor ingresa datos válidos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- TARJETA DE ESTADO DEL BACKEND ---
            FutureBuilder<String>(
              future: _obtenerEstadoBackend(),
              builder: (context, snapshot) {
                String estado = 'Conectando al servidor...';
                Color colorEstado = Colors.orange;

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && !snapshot.data!.contains('Error') && !snapshot.data!.contains('no detectada')) {
                    estado = snapshot.data!;
                    colorEstado = Colors.green;
                  } else {
                    estado = snapshot.data ?? 'Sin respuesta';
                    colorEstado = Colors.red;
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorEstado),
                  ),
                  child: Text(
                    'Estado Servidor: $estado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                );
              },
            ),

            const Text(
              'Ingresa tus datos:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Campo Nombre
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),

            // Campo Peso
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
            ),
            const SizedBox(height: 15),

            // Campo Altura
            TextField(
              controller: _alturaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura (ej. 1.79 en metros)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 25),

            // Botón de cálculo
            ElevatedButton(
              onPressed: _calcularIMC,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Calcular Datos',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // Resultado
            Text(
              _resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}