import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/app_state.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/Pokemon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


/*User Actions*/
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {

  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user = storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  store.dispatch(GetUserAction(user));
};

/*Pokemons Actions*/

ThunkAction<AppState> getPokemonsAction = (Store<AppState>store) async {
  http.Response response = await http.get('http://localhost:1337/pokemons');
  final List<dynamic> responseData = json.decode(response.body);
  List<Pokemon> pokemons = [];
  responseData.forEach((pokemonData) {
  final Pokemon pokemon = Pokemon.fromJson(pokemonData);
  pokemons.add(pokemon);
  });
  store.dispatch(GetPokemonsAction(pokemons));
};


/*Logout Action */
ThunkAction<AppState> logoutUserAction = (Store<AppState>store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};

/* CartPokemonsAction */
ThunkAction<AppState> toggleCartPokemonAction(cartPokemon) {
  return (Store<AppState> store) async {
    final List<Pokemon> cartPokemons = store.state.cartPokemons;
    final User user = store.state.user;
    final int index = cartPokemons.indexWhere((pokemon) => pokemon.id == cartPokemon.id);
    bool isInCart = index > -1 == true;
    List<Pokemon> updatedCartList = List.from(cartPokemons);
    if(isInCart) {
      updatedCartList.removeAt(index);
    } else {
      updatedCartList.add(cartPokemon);
    }
    final List<String> cartPokemonsIds = updatedCartList.map((pokemon) => pokemon.id).toList();
    await http.put('http://localhost:1337/carts/${user.cartId}',
     body: {
      'pokemons': json.encode(cartPokemonsIds)
     },
      headers: {
        'Authorization': 'Bearer ${user.jwt}'
      }
    );
    store.dispatch(ToggleCartPokemonAction(updatedCartList));
  };
}

ThunkAction<AppState> getCartPokemonAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');

  if(storedUser == null) {
    return;
  }
  final User user = User.fromJson(json.decode(storedUser));
  http.Response response = await http.get('http://localhost:1337/carts/${user.cartId}', headers: {
    'Authorization': 'Bearer ${user.jwt}'
  });
  final responseData = json.decode(response.body)['pokemons'];
  List<Pokemon> cartPokemons = [];
  responseData.forEach((pokemonData) {
    final Pokemon pokemon = Pokemon.fromJson(pokemonData);
    cartPokemons.add(pokemon);
  });
  store.dispatch(GetCartPokemonsAction(cartPokemons));
  print('user cart: $responseData');
};

ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerId;
  http.Response response = await http.get('http://localhost:1337/card?$customerId');
  final responseData = json.decode(response.body);
  store.dispatch(GetCardsAction(responseData));
};

/*Card Token Actions */

ThunkAction<AppState> getCardTokenAction = (Store<AppState> store) async {
  final String jwt = store.state.user.jwt;
  http.Response response = await http.get('http://localhost:1337/users/me', headers: {
    'Authorization': 'Bearer $jwt'
  });
  final responseData = json.decode(response.body);
  final String cardToken = responseData['card_token'];
  store.dispatch(GetCardTokenAction(cardToken));
};

class GetCardTokenAction {
  final String  _cardToken;
  String get cardToken => this._cardToken;
  GetCardTokenAction(this._cardToken);
}

class UpdateCardTokenAction {
  final String  _cardToken;
  String get cardToken => this._cardToken;
  UpdateCardTokenAction(this._cardToken);
}

class AddCardAction {
  final dynamic  _card;
  dynamic get card => this._card;
  AddCardAction(this._card);
}

class GetCardsAction {
  final List<dynamic> _cards;
  List<dynamic> get cards => this._cards;
  GetCardsAction(this._cards);
}

class GetCartPokemonsAction {
  final List<Pokemon> _cartPokemons;
  List<Pokemon> get cartPokemons => this._cartPokemons;
  GetCartPokemonsAction(this._cartPokemons);
}

class ToggleCartPokemonAction {
  final List<Pokemon> _cartPokemons;
  List<Pokemon> get cartPokemons => this._cartPokemons;
  ToggleCartPokemonAction(this._cartPokemons);
}

class LogoutUserAction {
  final User _user;
  User get user => _user;
  LogoutUserAction(this._user);
}


class GetPokemonsAction {
  final List<Pokemon> _pokemons;

  List<Pokemon> get pokemons => this._pokemons;

  GetPokemonsAction(this._pokemons);
}


class GetUserAction {
  final User _user;

  User get user => _user;

  GetUserAction(this._user);
}
