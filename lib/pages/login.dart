import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_1/dto/credenciales.dart';
import 'package:trabajo_1/pages/principal.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<Credenciales> _credenciales = [];

  void _cargarCredenciales() async {
    List<Credenciales> temporaryList = [];
    final response = await http
        .get(Uri.parse('https://40fd422c6d4d.sa.ngrok.io/api/usuarios'));
    if (response.statusCode == 200) {
      //print(response.body);
      temporaryList = credencialesFromJson(response.body);
    } else {
      throw Exception('Error status code != 200');
    }
    // Update the UI
    setState(() {
      _credenciales = temporaryList;
    });
  }

  // Call the _loadData() function when the app starts
  @override
  void initState() {
    super.initState();
    _cargarCredenciales();
  }

  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void validarDatos(String username, String password) {
    /*
      Aqui seria primero verificar si son nulos para lanzar cuadro de advertencia,
      luego si es no nulo verificar primero email, si es erroneo alert
      luego verificar pass, si es erroneo alert
      si pasa ambas verificaciones entra a la pagina principa
    */
    String tituloAlert = '';
    int indiceUsername =
        _credenciales.indexWhere((element) => element.login == username);
    if (indiceUsername >= 0) {
      if (_credenciales[indiceUsername].pass == password) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Principal(loginLogin: username, nombreNombre: _credenciales[indiceUsername].nombre)));
      } else {
        tituloAlert = 'La contraseña no es correcta';
      }
    } else {
      tituloAlert = 'El usuario no es correcto';
    }
    if (tituloAlert != '') {
      CoolAlert.show(
        context: context,
        backgroundColor: const Color(0xFF6A62B7),
        type: CoolAlertType.info,
        title: tituloAlert,
        text: 'Inténtelo de nuevo',
        confirmBtnText: 'Volver a intentar',
        confirmBtnColor: const Color(0xFF6A62B7),
        loopAnimation: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 30,
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(53),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sizedBox,
                  const Text('Supermensajes',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 300,
                    height: 234,
                    child: Image.asset('assets/login.jpg', fit: BoxFit.fill),
                  ),
                  sizedBox,
                  TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.deepPurple[50],
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(40)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF6A62B7)),
                          borderRadius: BorderRadius.circular(40)),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFF6A62B7),
                      ),
                      hintText: 'Usuario',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.deepPurple[50],
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(40)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF6A62B7)),
                          borderRadius: BorderRadius.circular(40)),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF6A62B7),
                      ),
                      hintText: 'Contraseña',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF6A62B7),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          if (loginController.text.isEmpty) {
                            var snackBar = const SnackBar(
                                content: Text('Debe ingresar el usuario'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            if (passController.text.isEmpty) {
                              var snackBar = const SnackBar(
                                  content: Text('Debe ingresar la contraseña'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              validarDatos(
                                  loginController.text, passController.text);
                            }
                          }
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
