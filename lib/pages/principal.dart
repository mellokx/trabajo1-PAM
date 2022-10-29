import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trabajo_1/dto/mensajes.dart';
import 'package:trabajo_1/pages/agregrarMensaje.dart';

import 'integrantes.dart';

class Principal extends StatefulWidget {
  final String loginLogin;
  final String nombreNombre;
  const Principal(
      {super.key, required this.loginLogin, required this.nombreNombre});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Future<List<Mensajes>> futureMensajes;

  @override
  void initState() {
    super.initState();
    futureMensajes = getMensajes();
  }

  Future<List<Mensajes>> getMensajes() async {
    final response = await http
        .get(Uri.parse('https://40fd422c6d4d.sa.ngrok.io/api/mensajes'));

    if (response.statusCode == 200) {
      //print(response.body);
      return mensajesFromJson(response.body);
    } else {
      throw Exception('Error status code != 200');
    }
  }

  void alertSalir(BuildContext context) {
    CoolAlert.show(
      context: context,
      showCancelBtn: true,
      backgroundColor: const Color(0xFF6A62B7),
      type: CoolAlertType.warning,
      title: '¿Está seguro que desea salir?',
      confirmBtnText: 'Salir',
      confirmBtnColor: const Color(0xFF6A62B7),
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      cancelBtnText: 'Volver',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      loopAnimation: false,
    );
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
                Icons.menu,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Supermensajes',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        elevation: 3,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: const Color(0xFF6A62B7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    '  Bienvenido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    '  ${widget.nombreNombre}',
                    style: const TextStyle(color: Colors.white, fontSize: 26),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ListTile(
              hoverColor: const Color(0xFF6A62B7),
              style: ListTileStyle.list,
              title: const Text(
                'Agregar',
                style: TextStyle(fontSize: 22),
              ),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgregarMensaje(
                              loginLogin: widget.loginLogin,
                              nombreNombre: widget.nombreNombre,
                            )));
                futureMensajes = getMensajes();
                var list = await futureMensajes;
                //print(list);
                if (list.isNotEmpty) {
                  setState(() {
                    print('Recargando todo');
                  });
                }
              },
            ),
            ListTile(
              style: ListTileStyle.list,
              title: const Text(
                'Integrantes',
                style: TextStyle(fontSize: 22),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Integrantes()));
              },
            ),
            ListTile(
              style: ListTileStyle.list,
              title: const Text(
                'Salir',
                style: TextStyle(fontSize: 22),
              ),
              onTap: () {
                Navigator.pop(context);
                alertSalir(context);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF6A62B7),
        key: _refreshIndicatorKey,
        onRefresh: () async {
          futureMensajes = getMensajes();
          var list = await futureMensajes;
          if (list.isNotEmpty) {
            setState(() {
              print('Recargando todo');
            });
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            alertSalir(context);
            return false;
          },
          child: SingleChildScrollView(
              child: FutureBuilder<List<Mensajes>>(
                  future: futureMensajes,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List<Widget> lista = [];
                      for (var element in snapshot.data!) {
                        lista.add(cuadro(element));
                      }
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: lista,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFF6A62B7),
                        )));
                  }))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AgregarMensaje(
                        loginLogin: widget.loginLogin,
                        nombreNombre: widget.nombreNombre,
                      )));
          futureMensajes = getMensajes();
          var list = await futureMensajes;
          //print(list);
          if (list.isNotEmpty) {
            setState(() {
              print('Recargando todo');
            });
          }
        },
        backgroundColor: const Color(0xFF6A62B7),
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget cuadro(Mensajes obj) {
    return Card(
      color: const Color.fromARGB(255, 233, 232, 255),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        text: obj.login),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    '${obj.fecha.day}/${obj.fecha.month}/${obj.fecha.year} ${obj.fecha.hour}:${obj.fecha.minute}',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.grey,
            ),
            Text(
              obj.titulo,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            Text(
              obj.texto,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
