import 'package:flutter/material.dart';
import 'package:front_app/pages/Dashboard.dart';
import 'package:front_app/scope_models/AppModel.dart';
import 'package:front_app/widgets/NavDrawer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool _isLoading  = false;

  String? _password;
  String? _cpassword;
  final _myControllerCpassword = TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return ModalProgressHUD(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: _myControllerCpassword,
                        validator: (value) {
                          if(value == null) {
                            return "Password is required!";
                          } else {
                            value = value.trim();
                            if (value.length == 0) return "Password is required!";
                          }
                        },
                        onSaved: (String? value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          filled: true,
                          fillColor: Colors.white
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text("CHANGE PASSWORD"),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState?.save();
                            setState(() {
                              _isLoading = true;
                            });
                            model.changePassword(_password!).then((value) {
                              print(value);
                              if (value['success']) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(value['data']),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text("OK"),
                                          onPressed: () {
                                            _formKey.currentState?.reset();
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("Can not change password"),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text("OK"),
                                            onPressed: () {
                                              _formKey.currentState?.reset();
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            inAsyncCall: _isLoading,
          );
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
