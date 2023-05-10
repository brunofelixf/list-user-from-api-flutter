import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Usuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<Usuario>> usuarios;

  @override
  void initState(){
    super.initState();
    usuarios = pegarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Usuários')
      ),
      body: Center(
        child: FutureBuilder<List<Usuario>>(
          future: usuarios,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  Usuario usuario = snapshot.data![index];
                  return ListTile(
                    title: Text(usuario.name!),
                    subtitle: Text(usuario.website!),
                  );
                });
            } else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<Usuario>> pegarUsuario() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var response = await http.get(url);

    if(response.statusCode == 200){
      List listaUsuarios = json.decode(response.body);
      return listaUsuarios.map((json) => Usuario.fromJson(json)).toList();
    } else{
      throw Exception('Erro não foi possível carregar os usuários');
    }
  }

}



