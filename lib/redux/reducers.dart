import 'package:flutter_app/models/app_state.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/Pokemon.dart';
import 'package:flutter_app/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    pokemons: pokemonsReducer(state.pokemons, action),
    cartPokemons: cartPokemonsReducer(state.cartPokemons, action),
    cards: cardsReducer(state.cards, action),
    cardToken: cardTokenReducer(state.cardToken, action)
  );
}

User userReducer(User user, dynamic action) {

  if(action is GetUserAction) {
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }

  return user;
}

List<Pokemon> pokemonsReducer(List<Pokemon>pokemons, dynamic action) {
  if(action is GetPokemonsAction) {
    return action.pokemons;
  }

  return pokemons;
}

List<Pokemon> cartPokemonsReducer(List<Pokemon>cartPokemons, dynamic action) {
  if(action is GetCartPokemonsAction) {
    return action.cartPokemons;
  }
  else if(action is ToggleCartPokemonAction) {
    return action.cartPokemons;
  }
  return cartPokemons;
}

List<dynamic> cardsReducer(List<dynamic>cards, dynamic action) {
  if(action is GetCardsAction) {
    return action.cards;
  } else if(action is AddCardAction) {
    return List.from(cards)..add(action.card);
  }
  return cards;
}

String cardTokenReducer(String cardToken, dynamic action) {
  if(action is UpdateCardTokenAction) {
    return action.cardToken;
  } else if(action is GetCardTokenAction) {
    return action.cardToken;
  }
  return cardToken;
}



