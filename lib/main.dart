import 'package:flutter/material.dart';
import 'package:flutter_app/pages/register_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/cart_page.dart';
import 'package:flutter_app/pages/pokemons_page.dart';
import 'package:flutter_app/models/app_state.dart';
import 'package:flutter_app/redux/reducers.dart';
import 'package:flutter_app/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_logging/redux_logging.dart';

void main() {
  final store = Store<AppState>(appReducer, initialState: AppState.initial(), middleware: [thunkMiddleware,
  LoggingMiddleware.printer()]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({ this.store });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(store: store, child: MaterialApp(
      routes: {
        '/': (BuildContext context) => PokemonsPage(
          onInit: () {
            StoreProvider.of<AppState>(context).dispatch(getUserAction);
            StoreProvider.of<AppState>(context).dispatch(getPokemonsAction);
            StoreProvider.of<AppState>(context).dispatch(getCartPokemonAction);
          }
        ),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
        '/cart': (BuildContext context) => CartPage(
          onInit: () {
            StoreProvider.of<AppState>(context).dispatch(getCardsAction);
            StoreProvider.of<AppState>(context).dispatch(getCardTokenAction);
          }
        ),
      },
      title: 'Flutter Pokemon-Shop',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow[400],
        accentColor: Colors.cyan[400],
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 18.0)
        )
      ),
//      home: RegisterPage(),
    ));
  }
}

