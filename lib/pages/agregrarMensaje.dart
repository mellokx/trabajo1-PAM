import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trabajo_1/pages/principal.dart';

class AgregarMensaje extends StatefulWidget {
  final String loginLogin;
  final String nombreNombre;
  const AgregarMensaje(
      {super.key, required this.loginLogin, required this.nombreNombre});

  @override
  State<AgregarMensaje> createState() => _AgregarMensajeState();
}

class _AgregarMensajeState extends State<AgregarMensaje> {
  TextEditingController titulo = TextEditingController();
  TextEditingController texto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Agregar Mensaje',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        elevation: 3,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: titulo,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Titulo',
                ),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: texto,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Ingrese el cuerpo del mensaje...',
                ),
                style: const TextStyle(fontSize: 18),
                maxLines: 18,
                maxLength: 620,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF6A62B7),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      if (titulo.text.isEmpty) {
                        var snackBar = const SnackBar(
                            content: Text('Debe ingresar el título'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        if (texto.text.isEmpty) {
                          var snackBar = const SnackBar(
                              content:
                                  Text('Debe ingresar el cuerpo del mensaje'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          http.post(
                            Uri.parse(
                                'https://40fd422c6d4d.sa.ngrok.io/api/mensajes'),
                            body: {
                              'login': widget.loginLogin,
                              'titulo': titulo.text,
                              'texto': texto.text
                            },
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
