import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {

  String? _email;
  String? _name;
  String? _password;
  String? _cpassword;
  final _myControllerCpassword = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Account"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: _buildRegister(),
      ),
    );
  }

  Widget _buildRegister() {
    return  Container(
      padding: const EdgeInsets.all(20.0),
      child: _buildRegisterWrapper(),
    );
  }

  Widget _buildRegisterWrapper() {
    return SingleChildScrollView(
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        children: <Widget>[
          _buildName(),
          SizedBox(
            height: 8.0,
          ),
          _buildEmail(),
          SizedBox(
            height: 15.0,
          ),
          _buildPassword(),
          SizedBox(
            height: 8.0,
          ),
          _buildConfirmPassword(),
          SizedBox(
            height: 25.0,
          ),
          SizedBox(
            width: double.infinity,
            child: _buildCreateAccount(),
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: double.infinity,
            child: _buildLogin(),
          ),
          SizedBox(
            height: 30.0,
          ),
          const Text("Powered by BP"),
        ],
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "Name",
          filled: true,
          fillColor: Colors.white),
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "Email Address",
          filled: true,
          fillColor: Colors.white),
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password",
          filled: true,
          fillColor: Colors.white),
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Confirm Password",
          filled: true,
          fillColor: Colors.white),
    );
  }

  Widget _buildCreateAccount() {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.greenAccent,
      child: const Text("Create Account"),
      onPressed: () {

      },
    );
  }

  Widget _buildLogin() {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.blueAccent,
      child: const Text("Login"),
      onPressed: () {

      },
    );
  }
}
