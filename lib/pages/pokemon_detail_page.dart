import 'package:flutter/material.dart';
import 'package:flutter_app/models/Pokemon.dart';
import 'package:flutter_app/pages/pokemons_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/models/app_state.dart';
import 'package:flutter_app/redux/actions.dart';

class PokemonDetailPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Pokemon item;
  PokemonDetailPage({this.item});

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
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(item.name)
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Hero(tag: item,child: Image.network(pictureUrl,
                  fit: BoxFit.cover,
                  width: orientation == Orientation.portrait ? 300 : 200,

              ))
            ),
            Text(item.name, style: Theme.of(context).textTheme.title),
            Text('\$${item.price}', style: Theme.of(context).textTheme.body1),
            Padding(padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return state.user != null ? IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: _isInCart(state, item.id),
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(toggleCartPokemonAction(item));
                      final snackbar = SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Cart updated', style: TextStyle(color: Colors.green))
                      );
                      _scaffoldKey.currentState.showSnackBar(snackbar);
                    },
                  ) : Text('');
                }
            )
            ),
            Flexible(child: SingleChildScrollView(child: Padding(
              child: Text(item.description),
              padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
            )))
          ],
        )
      )
    );
  }
}