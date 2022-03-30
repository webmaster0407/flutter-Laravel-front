import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:front_app/scope_models/AppModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPage();
  }
}
class _AuthPage extends State<AuthPage> {

  String? _email;
  String? _password;
  bool _isLoading = false;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: _buildLogin(),
      ),
    );
  }

  Widget _buildLogin() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(40.0),
      child: _buildLoginWrapper(),
    );
  }

  Widget _buildLoginWrapper() {
    return SingleChildScrollView(
      child: _buildLoginWrapperContent(),
    );
  }

  Widget _buildLoginWrapperContent() {
    return Column(
      children: <Widget>[
        _buildLogo(),
        _buildLoginForm(),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset('assets/logo.png');
  }

  Widget _buildLoginForm() {
    return Center(
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formState,
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          SizedBox(
            height: 15.0,
          ),
          _buildPasswordField(),
          SizedBox(
            height: 40.0,
          ),
          SizedBox(
            width: double.infinity,
            child: _buildLoginButton(),
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: double.infinity,
            child: _buildRegister(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return 'Email is Required';
        } else {
          value = value.trim();
          if (value.length == 0) return 'Email is Required';
        }
      },
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.white
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return 'Password is Required';
        } else {
          value = value.trim();
          if (value.length == 0) return 'Password is Required';
        }
        // if (value?.trim().length <= 0) {
        //   return 'Password is Required';
        // }
      },
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _loginButton(context, child, model);
      },
    );
  }

  Widget _loginButton(BuildContext context, Widget child, AppModel model) {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.greenAccent,
      child: const Text("Login"),
      onPressed: () {
        if (!_formState.currentState!.validate()) {
          return;
        }
        _formState.currentState!.save();
        setState(() {
          _isLoading = true;
        });

        model.login(_email, _password).then((res) {
          setState(() {
            _isLoading = false;
          });
          if (res["error"]) {
            // Alert User
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(res["msg"]),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            );
          } else {
            // Dashboard
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        });
      },
    );
  }

  Widget _buildRegister() {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.blueAccent,
      child: const Text("Create Account"),
      onPressed: () {
        // Navigator.pushReplacementNamed(context, routeName)
      },
    );
  }

}

