// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:os_organizze_web/core/helpers/functions.dart';
import 'package:os_organizze_web/models/user_model.dart';
import 'package:os_organizze_web/views/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

final TextEditingController _userController = TextEditingController();
final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey();

bool isSignUp = false;

double containerHeight = 262;

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 320,
                  //height: ,
                  child: isSignUp ? SignUpForm() : SignInForm()),
            )
          ],
        ),
      ),
    );
  }

  Widget SignUpForm() {
    var _sizedBoxHeight;
    return Form(
      key: _formKey,
      child: SizedBox(
        height: _sizedBoxHeight,
        child: Column(
          children: [
            Image.asset("images/logo_gps.png"),
            // Image.network(
            //     'https://www.gpssa.com.br/wp-content/uploads/2020/05/logo_gps.png'),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 12),
              child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.short_text),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Nome',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Não pode estar em branco!';
                    }
                    // if (value.length < 6) {
                    //   return 'Deve conter mais de 5 dígitos';
                    // }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Sobrenome',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Não pode estar em branco!';
                    }
                    // if (value.length < 6) {
                    //   return 'Deve conter mais de 5 dígitos';
                    // }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Usuário',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Não pode estar em branco!';
                    }
                    // if (value.length < 6) {
                    //   return 'Deve conter mais de 5 dígitos';
                    // }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.key),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Senha',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Não pode estar em branco!';
                    }
                    // if (value.length < 8) {
                    //   return 'A senha deve conter mais de 7 dígitos';
                    // }
                    return null;
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => setState(() {
                          isSignUp = !isSignUp;
                        }),
                    child: const Text("Voltar")),
                SizedBox(
                    //width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                (const Color(0xFF112535))),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //_userSignUp();
                            Functions.showAlertSnackbar("ATENÇÃO",
                                "Função ainda não está pronta", context);
                          } else {
                            setState(() {
                              _sizedBoxHeight = 427;
                            });
                          }
                        },
                        child: const Text(
                          "Cadastrar",
                          //style: TextStyle(fontSize: 15),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget SignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Image.asset("images/logo_gps.png"),
          // Image.network(
          //     'https://www.gpssa.com.br/wp-content/uploads/2020/05/logo_gps.png'),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 12),
            child: TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Usuário',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Não pode estar em branco!';
                  }
                  // if (value.length < 6) {
                  //   return 'Deve conter mais de 5 dígitos';
                  // }
                  return null;
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Senha',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Não pode estar em branco!';
                  }
                  // if (value.length < 8) {
                  //   return 'A senha deve conter mais de 7 dígitos';
                  // }
                  return null;
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => setState(() {
                        isSignUp = !isSignUp;
                      }),
                  child: const Text("Cadastre-se")),
              SizedBox(
                  //width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              (const Color(0xFF112535))),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            containerHeight = 262;
                            _userLogin();
                          });
                        } else {
                          setState(() {
                            containerHeight = 306;
                          });
                        }
                      },
                      child: const Text(
                        "Entrar",
                        //style: TextStyle(fontSize: 15),
                      ))),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _userSignUp() async {
    try {
      var url = Uri.parse('http://localhost:8000/user/');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            "first_name": _firstNameController.text,
            "last_name": _lastNameController.text,
            "username": _userController.text,
            "password": _passwordController.text,
          }));
      if (response.statusCode == 201) {
        setState(() {
          isSignUp = false;
        });
        Get.snackbar("Atenção",
            "- ${_userController.text} - cadastrado com sucesso!\nAguarde ativação pelo administrador para utilizar o sistema.",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.only(top: 8));
        _firstNameController.clear();
        _lastNameController.clear();
        _userController.clear();
        _passwordController.clear();
      } else if (response.body.contains('already exists')) {
        Get.snackbar("Atenção",
            "Usuário - ${_userController.text} - já cadastrado!\nAguarde ativação pelo administrador.",
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error),
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.only(top: 8));
      } else {
        Get.snackbar("Atenção", "Erro ao cadastrar usuário",
            backgroundColor: Colors.red,
            icon: const Icon(Icons.error),
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.only(top: 8));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _userLogin() async {
    try {
      var url = Uri.parse('http://localhost:8000/token/');
      final response = await http.post(url, headers: {
        // "Access-Control-Allow-Origin": "*"
      }, body: {
        "username": _userController.text,
        "password": _passwordController.text
      });
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        //Se status ok e o corpo da resposta não estiver vazio, decodifica a
        //resposta

        var decodeJson = jsonDecode(response.body);
        if (kDebugMode) {
          print("Senha ok, adquirindo Token");
        }

        //Recebe o token na String 'token'
        String token = decodeJson['access'];

        //Tenta requisitar os dados da API passando a Token
        try {
          var url = Uri.parse('http://localhost:8000/user/');
          final response = await http.get(url, headers: {
            "Authorization": "Bearer $token",
            //"Access-Control-Allow-Origin": "*"
          });
          if (response.statusCode == 200 && response.body.isNotEmpty) {
            if (kDebugMode) {
              print(response.body);
            }
            var decodedJson = jsonDecode(response.body);
            decodedJson.forEach((item) {
              UserModel user = UserModel.fromJson(item);
              if (user.username == _userController.text) {
                if (kDebugMode) {
                  print(user.userlevel);
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeView(user: user, token: token)));
              }
            });
          } else if (response.statusCode == 401) {
            Get.snackbar("ERRO", jsonDecode(response.body)['detail'],
                backgroundColor: Colors.red,
                icon: const Icon(Icons.error),
                duration: const Duration(seconds: 5),
                margin: const EdgeInsets.only(top: 8));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      } else {
        if (kDebugMode) {
          print('Erro ao tentar gerar Token');
          print(jsonDecode(response.body)['detail']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
