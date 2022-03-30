import 'package:flutter/material.dart';
import 'package:front_app/scope_models/AppModel.dart';
import 'package:front_app/widgets/NavDrawer.dart';
import 'package:scoped_model/scoped_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> {
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  List<dynamic> _data = <dynamic>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    ScopedModel.of<AppModel>(context).dashboard().then((result) {
      setState(() {
        _isLoading = false;
        // _result = result;

        _data = _result!['data'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: _isLoading ? _buildLoader() : _buildDashboard(),
      drawer: NavDrawer(),
    );
  }

  Widget _buildDashboard() {
    if (_result!["success"] == false) {
      Navigator.pushReplacementNamed(context, "/");
    }
    if (_data.length == 0) {
      return Center(
        child: Text("Welcome to my APP!"),
      );
    } else {
      return Container(
        child: Center(
          child: Text("Dashboard"),
        ),
      );
    }
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }


}
