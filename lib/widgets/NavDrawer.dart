import 'package:flutter/material.dart';
import 'package:front_app/scope_models/AppModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text(""),
          ),
          ListTile(
            title: const Text("Dashboard"),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/setting');
            },
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              ScopedModel.of<AppModel>(context).logout().then((res) async {
                if (!res['error']) {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/");
                }
              });
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: new Text("Powered by BP"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
