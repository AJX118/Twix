import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:twix/Database/database.dart';
import 'package:twix/Api/api.dart';

import 'package:twix/Screens/login_screen.dart';
import 'package:twix/Screens/home_screen.dart';

void main() async {
  Connect.isConnected();
  runApp(Twix());
}

class Twix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        builder: (_) => TwixDB(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Builder(builder: (context) => _buildMainScreen(context)),
          ),
        ));
  }

  Widget _buildMainScreen(BuildContext context) {
    final database = Provider.of<TwixDB>(context);
    return FutureBuilder(
        future: database.userDao.getLoggedInUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState ==
                  ConnectionState.active) if (!snapshot.hasError) if (snapshot
              .hasData) {
            StaticData.user = snapshot.data;
            Api.setAuthToken(StaticData.user.token);
            return HomeScreen();
          } else {
            return Login();
          }
          return Container();
        });
  }
}

class StaticData {
  static UserTableData user;
}
