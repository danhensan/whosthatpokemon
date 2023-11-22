// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:whosthatpokemon/main.dart';
import 'pokemoninformation.dart';

class CorrectPage extends StatelessWidget {
  final PokemonModel pokemon;

  final Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Color.fromARGB(255, 111, 255, 116),
    'normal': Colors.black,
    'poison': Color.fromARGB(255, 229, 83, 255),
    'psychic': Colors.pinkAccent,
    'ice': Color.fromARGB(255, 140, 217, 255),
    'flying': Color.fromARGB(255, 162, 117, 101),
    'ground': Colors.yellow,
    'rock': Colors.grey,
    'dragon': Colors.orange,
    'bug': Color.fromARGB(255, 3, 66, 5),
    'fairy': Color.fromARGB(255, 255, 155, 189),
    'dark': const Color.fromARGB(255, 30, 11, 11),
    'ghost': Color.fromARGB(255, 119, 39, 135),
    'electric': const Color.fromARGB(255, 255, 230, 0),
    'fighting': const Color.fromARGB(255, 255, 155, 118),
    'steel': Colors.blueGrey
  };

  CorrectPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CONGRATULATIONS'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'CONGRATULATIONS, YOU GOT IT RIGHT!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 250,
              height: 250,
              child: Image.network(
                pokemon.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'ID: ${pokemon.id}',
              style: TextStyle(fontSize: 14),
            ),
            Text('NAME: ${pokemon.name.toUpperCase()}',
                style: TextStyle(fontSize: 14)),
            Column(
              children: pokemon.types.map((type) {
                return Container(
                  color: typeColors[type],
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            Column(
              children: <Widget>[
                for (var entry in pokemon.stats.entries)
                  Text("${entry.key.toUpperCase()}: ${entry.value}",
                      style: TextStyle(fontSize: 14)),
              ],
            ),
            Text('HEIGHT: ${pokemon.height}', style: TextStyle(fontSize: 14)),
            Text('WEIGHT: ${pokemon.weight}', style: TextStyle(fontSize: 14)),
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
                child: Text('PLAY AGAIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
