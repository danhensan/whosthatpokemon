// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:whosthatpokemon/main.dart';
import 'pokemoninformation.dart';

class ErrorPage extends StatelessWidget {
  final PokemonModel pokemon;

  const ErrorPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TRY AGAIN!'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'YOU MISSED!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: Image.network(
                pokemon.imageUrl,
                color: Colors.black,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('TRY AGAIN!'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PokemonApp()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('SURRENDER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
