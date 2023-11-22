import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

main() async {}

class AbilityModel {
  String name;
  String effect;

  AbilityModel(this.name, this.effect);

  factory AbilityModel.fromJson(Map<String, dynamic> json) {
    return AbilityModel(
      json['ability']['name'],
      json['effect_entries'][0]['effect'],
    );
  }
}

class PokemonModel {
  String name;
  String imageUrl;
  String url;
  int id;
  double height;
  double weight;
  List<String> types;
  List<AbilityModel> abilities;
  Map<String, int> stats;

  PokemonModel(this.name, this.imageUrl, this.url, this.id, this.height,
      this.weight, this.types, this.abilities, this.stats);

  factory PokemonModel.fromJson(
      Map<String, dynamic> json, List<AbilityModel> abilities) {
    return PokemonModel(
      json['name'],
      json['imageUrl'],
      json['url'],
      json['id'],
      json['height'] / 10,
      json['weight'] / 10,
      List<String>.from(json['types'].map((type) => type['type']['name'])),
      abilities,
      {
        for (var statsInfo in json['stats'])
          statsInfo['stat']['name']: statsInfo['base_stat']
      },
    );
  }
}

const variables = {
  "limit": 1,
  "offset": 1,
};

const gqlQuery = '''query pokemons(\$limit: Int, \$offset: Int) {
  pokemons(limit: \$limit, offset: \$offset) {
    count
    next
    previous
    status
    message
    results {
      url 
      image
    }
  }
}''';

Future<List<PokemonModel>> fetchPokemon() async {
  final rng = Random();
  final offset = rng.nextInt(898) + 1;
  final response = await http.post(
    Uri.parse('https://graphql-pokeapi.graphcdn.app/'),
    body: jsonEncode({
      "query": gqlQuery,
      "variables": {"limit": 3, "offset": offset}
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  final pokeMap = jsonDecode(response.body);
  final results = pokeMap["data"]["pokemons"]["results"];
  final pokemonList = <PokemonModel>[];

  for (var pokeData in results) {
    final url = pokeData["url"];
    final imageUrl = pokeData["image"];

    var detailedInfo = await fetchPokemonInfo(url);

    detailedInfo['imageUrl'] = imageUrl;
    detailedInfo['url'] = url;

    List<AbilityModel> abilityList = [];
    for (var ability in detailedInfo['abilities']) {
      AbilityModel abilityInfo =
          await fetchAbilityInfo(ability['ability']['url']);
      abilityList.add(abilityInfo);
    }

    final pokemon = PokemonModel.fromJson(detailedInfo, abilityList);

    pokemonList.add(pokemon);
  }

  return pokemonList;
}

Future<Map<String, dynamic>> fetchPokemonInfo(String url) async {
  final response = await http.get(Uri.parse(url));
  final pokeMap = jsonDecode(response.body);

  return pokeMap;
}

Future<AbilityModel> fetchAbilityInfo(String url) async {
  final abilityResponse = await http.get(Uri.parse(url));
  final abilityMap = jsonDecode(abilityResponse.body);

  var effectEntries = abilityMap['effect_entries'];
  Map<String, dynamic> englishEffectEntry = effectEntries.firstWhere(
    (entry) => entry['language']['name'] == 'en',
    orElse: () => {},
  );

  if (englishEffectEntry.isEmpty) {
    throw Exception('No English effect entry found');
  }

  return AbilityModel(abilityMap["name"], englishEffectEntry["effect"]);
}
