// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:whosthatpokemon/correctpage.dart';
import 'package:whosthatpokemon/errorpage.dart';
import 'pokemoninformation.dart';

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late Future<List<PokemonModel>> pokemonList;

  @override
  void initState() {
    super.initState();
    pokemonList = fetchPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PokemonModel>>(
      future: pokemonList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<SizedBox> buttons = snapshot.data!.map((pokemon) {
            return SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return pokemon.name == snapshot.data![0].name
                            ? CorrectPage(pokemon: snapshot.data![0])
                            : ErrorPage(pokemon: snapshot.data![0]);
                      },
                    ),
                  );
                },
                child: Text(pokemon.name.toUpperCase()),
              ),
            );
          }).toList();
          buttons.shuffle();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("WHO'S THAT POKEMON?"),
              backgroundColor: Colors.blue,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: Image.network(
                          snapshot.data![0].imageUrl,
                          color: Colors.black,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 223),
                          ...buttons,
                          SizedBox(height: 50),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text('SURRENDER'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
