import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/models/pokemon.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favouritePokemons;

  PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favouritePokemonProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
      data: (data) {
        return _tile(context, false, data);
        // return ListTile(title: Text("data"));
      },
      error: (error, stackTrace) {
        return Text("Error : $error");
      },
      loading: () {
        return _tile(context, true, null);
        // return ListTile(title: Text("data"));
      },
    );
  }

  Widget _tile(BuildContext context, bool isLoadding, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoadding,
      child: ListTile(
        leading:
            pokemon != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
                : CircleAvatar(),
        title: Text(
          pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Currently loading name for Pokemon.",
        ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} movies"),
        trailing: IconButton(
          onPressed: () {
            if (_favouritePokemons.contains(pokemonUrl)) {
              _favoritePokemonsProvider.removeFavouritePokemon(pokemonUrl);
            } else {
              _favoritePokemonsProvider.addFavouritePokemon(pokemonUrl);
            }
          },
          icon: Icon(
            _favouritePokemons.contains(pokemonUrl)
                ? Icons.favorite
                : Icons.favorite_border,
                color: Colors.red,
          ),
        ),
      ),
    );
  }
}
