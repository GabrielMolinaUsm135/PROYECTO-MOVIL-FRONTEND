import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

Container panelUserEmail() {
  return Container(
    padding: EdgeInsets.all(10),
    width: double.infinity,
    color: Colors.black,
    child: Row(
      children: [
        Icon(MdiIcons.email, color: Colors.white),
        FutureBuilder(
          future: getEmailUsuario(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('...');
            }
            return Text(
              snapshot.data.toString(),
              style: TextStyle(color: Colors.white),
            );
          },
        ),
      ],
    ),
  );
}

Future<String> getEmailUsuario() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('user_email') ?? '';
}
