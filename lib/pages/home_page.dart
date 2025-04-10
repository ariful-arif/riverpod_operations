import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/controllers/home_controller.dart';
import 'package:pokemon_riverpod/models/page-data.dart';
import 'package:pokemon_riverpod/models/pokemon.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';
import 'package:pokemon_riverpod/widgets/pokemon_card.dart';
import 'package:pokemon_riverpod/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
      return HomePageController(HomePageData.initial());
    });

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favouritePokemons;

  @override
  void initState() {
    _allPokemonListScrollController.addListener(_scrollController);
    super.initState();
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollController);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollController() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favouritePokemons = ref.watch(favouritePokemonProvider);

    return Scaffold(body: _buildUI(context));
  }

  Widget _buildUI(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favouritePokemonList(context),
              _allPokemonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favouritePokemonList(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Favorites", style: TextStyle(fontSize: 25)),
          SizedBox(
            height: height * 0.50,
            width: width,
            child: Column(
              children: [
                if (_favouritePokemons.isEmpty)
                  Text("No Favorite item is here"),
                if (_favouritePokemons.isNotEmpty)
                  SizedBox(
                    height: height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: _favouritePokemons.length,
                      itemBuilder: (context, index) {
                        String pokemon = _favouritePokemons[index];
                        return PokemonCard(pokemonUrl: pokemon);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("All Pokemons", style: TextStyle(fontSize: 25)),
          SizedBox(
            height: height * 0.60,
            child: ListView.builder(
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data!.results!.length,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonUrl: pokemon.url!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
