import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Menu Drawer - Hamburguer',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const UserAccountsDrawerHeader(
                accountEmail: Text("guilherme_angelosilva@hotmail.com"),
                accountName: Text("Guigas's"),
                currentAccountPicture: CircleAvatar(
                  child: Text("Guigas's"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text("Minha Área"),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Login(),
                  //   ),
                  // );
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Barbearia"),
                onTap: () {
                  Navigator.pop(context);

                  //Navegar para outra página
                },
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Contato"),
                onTap: () {
                  Navigator.pop(context);
                  //Navegar para outra página
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Perfil"),
                onTap: () {
                  Navigator.pop(context);
                  //Navegar para outra página
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('img/logotipo.png'))),
        ));
  }
}
