import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override

  RegisterPageState createState() => RegisterPageState();

}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSubmitting = false, _obscureText = true;

  String _username, _email, _password;

  Widget _showTitle() {
    return Text('Register', style: Theme.of(context).textTheme.headline);
  }

  Widget _showRegisterUsername() {
    return Padding(padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _username = val,
            validator: (val) => val.length < 6 ? 'Username too short' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter Username, min 6 length',
                icon: Icon(Icons.face, color: Colors.grey)
            )
        ));
  }

  Widget _showRegisterEmail() {
    return Padding(padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _email = val,
            validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter email properly',
                icon: Icon(Icons.email, color: Colors.grey)
            )
        ));
  }

  Widget _showRegisterPassword() {
    return Padding(padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            obscureText: _obscureText,
            onSaved: (val) => _password = val,
            validator: (val) => val.length < 6 ? 'Username too short' : null,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey
                  ),
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Username, min 6 length',
                icon: Icon(Icons.lock, color: Colors.grey)
            )
        ));
  }

  Widget _showFormActions() {
    return Padding(padding: EdgeInsets.only(top: 20.0),
        child: Column(
            children: [
            _isSubmitting == true ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)
            ) : RaisedButton(
                child: Text('Submit', style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black)),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                color: Theme.of(context).primaryColor,
                onPressed: _submit,
              ),
              FlatButton(
                child: Text('Existing User? Login'),
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              )
            ]
        ));
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerUser();
      print('form valid');
    } else {
      print('form invalid');
    }
  }
  
  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response = await http.post('http://localhost:1337/auth/local/register', body: {
      'username': _username,
      'email': _email,
      'password': _password
    });

    final responseData = json.decode(response.body);
    if(response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() {
        _isSubmitting = false;
      });
      final String errorMsg = responseData['message'];
      _showErrorSnack(errorMsg);
    }
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
        content: Text(errorMsg, style: TextStyle(color: Colors.red))
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    throw Exception('Error registering: $errorMsg');
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text('User $_username successfully created!', style: TextStyle(color: Colors.green))
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register')
    ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(),
                  _showRegisterUsername(),
                  _showRegisterEmail(),
                  _showRegisterPassword(),
                  _showFormActions()
                ]
              )
            )
          )
        )
      )
    );
  }
}