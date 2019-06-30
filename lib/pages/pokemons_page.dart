import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';
import 'package:flutter_app/models/app_state.dart';
import 'package:flutter_app/widgets/pokemon_item.dart';
import 'package:flutter_app/redux/actions.dart';
import 'package:badges/badges.dart';

final gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [0.1, 0.3, 0.5, 0.7, 0.9],
    colors: [
      Colors.deepOrange[300],
      Colors.deepOrange[400],
      Colors.deepOrange[500],
      Colors.deepOrange[600],
      Colors.deepOrange[700],
    ]
  )
);

class PokemonsPage extends StatefulWidget {
  final void Function() onInit;
  PokemonsPage({ this.onInit });

  @override
  PokemonsPageState createState() => PokemonsPageState();
}

class PokemonsPageState extends State<PokemonsPage> {
  void initState() {
    super.initState();
    widget.onInit();

  }

  final _appBar = PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          title: SizedBox(child: state.user != null
              ? Text(state.user.username)
              : FlatButton(child: Text('Register here', style: Theme.of(context)
              .textTheme.body1), onPressed: () => Navigator.pushNamed(context, '/register'))),
          leading: state.user != null
              ? state.cartPokemons.length > 0
                ? Badge(
                    position: BadgePosition.topRight(top: 8, right: 8),
                    animationType: BadgeAnimationType.slide,
                    animationDuration: Duration(milliseconds: 300),
                    badgeColor: Colors.red[400],
                    badgeContent: state.cartPokemons.length > 0
                        ? Text('${state.cartPokemons.length}', style: TextStyle(fontSize: 10.0, color: Colors.white),)
                        : null,
                    child: IconButton(
                        icon: Icon(Icons.store),
                        onPressed: () => Navigator.pushNamed(context, '/cart')
                    ),
                )
                :  IconButton(
                      icon: Icon(Icons.store),
                      onPressed: () => Navigator.pushNamed(context, '/cart')
                  )
              : Text(''),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(logoutUserAction);
                  },
                  builder: (_, callback) {
                    return state.user != null
                        ? IconButton(
                            icon: Icon(Icons.exit_to_app),
                            onPressed: callback
                          )
                        : Text('');
                  }
                )
            )
          ]
        );
      }
    )
  );


  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: _appBar,
      body: Container(
        decoration: gradientBackground,
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return Column(
              children: [
                Expanded(
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: GridView.builder(
                      itemCount: state.pokemons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: orientation == Orientation.portrait ? 1 : 1.2
                      ),
                      itemBuilder: (context, i) => PokemonItem(item: state.pokemons[i])
                    )
                  )
                )
              ]
            );
          }
        )
      ),
    );
  }
}