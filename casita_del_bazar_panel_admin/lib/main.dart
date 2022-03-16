import 'package:casita_del_bazar_panel_admin/pages/home_page.dart';
import 'package:casita_del_bazar_panel_admin/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'clases/subitems/productOrder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UsersProviders())],
      child: MaterialApp(
        title: 'Admin Casita del Bazar',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: getApplicationsRoutes(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          );
        },
      ),
    );
  }
}
