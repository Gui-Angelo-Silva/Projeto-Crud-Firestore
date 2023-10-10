import 'dart:async';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lojas extends StatefulWidget {
  const Lojas({Key? key}) : super(key: key);

  @override
  State<Lojas> createState() => _LojasState();
}

class _LojasState extends State<Lojas> {
  // text fields' controllers

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  //final TextEditingController _imageController = TextEditingController();

  final CollectionReference _lojas =
      FirebaseFirestore.instance.collection('lojas');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';

      _nomeController.text = documentSnapshot['nome'];
      _bairroController.text = documentSnapshot['bairro'];
      _cidadeController.text = documentSnapshot['cidade'];
      _ufController.text = documentSnapshot['uf'];
      _cepController.text = documentSnapshot['cep'];

      //_imageController.text = documentSnapshot['image'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,

// prevent the soft keyboard from covering text fields

                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da Loja'),
                ),
                TextField(
                  controller: _bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro'),
                ),
                TextField(
                  controller: _cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
                TextField(
                  controller: _ufController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                TextField(
                  controller: _cepController,
                  decoration: const InputDecoration(labelText: 'Cep'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Salvar' : 'Alterar'),
                  onPressed: () async {
                    final String? nome = _nomeController.text;
                    final String? bairro = _bairroController.text;
                    final String? cidade = _cidadeController.text;
                    final String? uf = _ufController.text;
                    final String? cep = _cepController.text;

                    if (nome != null &&
                        bairro != null &&
                        cidade != null &&
                        uf != null &&
                        cep != null) {
                      if (action == 'create') {
// Persist a new product to Firestore

                        await _lojas.add({
                          "nome": nome,
                          "bairro": bairro,
                          "cidade": cidade,
                          "uf": uf,
                          "cep": cep
                        });
                      }

                      if (action == 'update') {
// Update the product

                        await _lojas.doc(documentSnapshot!.id).update({
                          "nome": nome,
                          "bairro": bairro,
                          "cidade": cidade,
                          "uf": uf,
                          "cep": cep
                        });
                      }
                      // Clear the text fields

                      _nomeController.text = '';
                      _bairroController.text = '';
                      _cidadeController.text = '';
                      _ufController.text = '';
                      _cepController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id

  Future<void> _deleteProduct(String lojasId) async {
    await _lojas.doc(lojasId).delete();

    // Show a snackbar

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Loja excluída!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBoersChocolate'),
      ),

      // Using StreamBuilder to display all products from Firestore in real-time

      body: StreamBuilder(
        stream: _lojas.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['nome']),
                    subtitle: Text(documentSnapshot['bairro']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
// Press this button to edit a single product

                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),

// This icon button is used to delete a single product

                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      // Add new product

      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class pressed {}
