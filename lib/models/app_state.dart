import 'package:meta/meta.dart';
import 'package:flutter_app/models/Pokemon.dart';
import 'package:flutter_app/models/User.dart';

@immutable
class AppState {
  final User user;
  final List<Pokemon> pokemons;
  final List<Pokemon> cartPokemons;
  final List<dynamic> cards;
  final String cardToken;



  AppState({
    @required this.user,
    @required this.pokemons,
    @required this.cartPokemons,
    @required this.cards,
    @required this.cardToken
  });

  factory AppState.initial() {
    return AppState(
      user: null,
      pokemons: [],
      cartPokemons: [],
      cards: [],
      cardToken: ''
    );
  }
}