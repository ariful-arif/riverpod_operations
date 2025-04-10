import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';

class PokemonStatsCards extends ConsumerWidget {
  final String pokemonUrl;
  const PokemonStatsCards({required this.pokemonUrl, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return AlertDialog(
      title: Text("Satistics"),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children:
                data?.stats?.map((s) {
                  return Text("${s.stat?.name?.toUpperCase()} : ${s.baseStat}");
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) {
          return Text('Error : $error');
        },
        loading: () {
          return CircularProgressIndicator(color: Colors.white);
        },
      ),
    );
  }
}
