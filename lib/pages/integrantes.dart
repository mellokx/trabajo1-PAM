import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../dto/credenciales.dart';

class Integrantes extends StatefulWidget {
  const Integrantes({super.key});

  @override
  State<Integrantes> createState() => _IntegrantesState();
}

class _IntegrantesState extends State<Integrantes> {
  late Future<List<Credenciales>> futureCredenciales;

  @override
  void initState() {
    super.initState();
    futureCredenciales = getCredenciales();
  }

  Future<List<Credenciales>> getCredenciales() async {
    final response = await http
        .get(Uri.parse('https://40fd422c6d4d.sa.ngrok.io/api/usuarios'));

    if (response.statusCode == 200) {
      //print(response.body);
      return credencialesFromJson(response.body);
    } else {
      throw Exception('Error chao');
    }
  }

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
          'Lista integrantes',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        elevation: 3,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<List<Credenciales>>(
              future: futureCredenciales,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> lista = [];
                  for (var element in snapshot.data!) {
                    lista.add(integrante(element));
                  }
                  return Column(
                    children: lista,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6A62B7),
                    )
                  )
                );
              }))),
    );
  }

  Widget integrante(Credenciales obj) {
    return TextButton(
      style: TextButton.styleFrom(primary: const Color(0xFF6A62B7)),
      onPressed: () {},
      child: SizedBox(
        height: 50,
        child: Center(
            child: Text(
          obj.nombre,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        )),
      ),
    );
  }
}
