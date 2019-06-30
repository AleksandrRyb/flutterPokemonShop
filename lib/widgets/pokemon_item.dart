import 'package:flutter/material.dart';
import 'package:flutter_app/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/models/Pokemon.dart';
import 'package:flutter_app/pages/pokemon_detail_page.dart';
import 'package:flutter_app/redux/actions.dart';



class PokemonItem extends StatelessWidget {
  final Pokemon item;
  PokemonItem({ this.item });


  @override

  Widget build(BuildContext context) {
    _isInCart(AppState state, String id) {
      final List<Pokemon> cartPokemons = state.cartPokemons;
      final int index = cartPokemons.indexWhere((pokemon) => pokemon.id == id);
      bool isInCart = index > -1 == true;
      if(isInCart) {
        return Colors.cyan[700];
      } else {
        return Colors.white;
      }
    }
    final String pictureUrl = 'http://localhost:1337${item.picture['url']}';
    return  InkWell (
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PokemonDetailPage(item: item);
          }
        )
      ),
      child:GridTile (
      footer: GridTileBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(item.name, style: TextStyle(fontSize: 20.0))
        ),
        subtitle: Text("\$${item.price}", style: TextStyle(fontSize: 16.0)),
        backgroundColor: Colors.black45,
        trailing: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return state.user != null ? IconButton(
              icon: Icon(Icons.shopping_cart),
              color: _isInCart(state, item.id),
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(toggleCartPokemonAction(item));
              },
            ) : Text('');
          }
        )
      ),
      child: Hero(tag: item,child: Image.network(pictureUrl, fit: BoxFit.cover))
    ));
  }
}