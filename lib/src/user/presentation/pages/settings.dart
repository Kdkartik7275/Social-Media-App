import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.keyboard_backspace),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        title: const Text(
          "Settings",
          style: TextStyle(),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            const ListTile(
                title: Text(
                  "About",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  "A Fully Functional Social Media Application Made by Kartik Dhiman",
                ),
                trailing: Icon(Icons.error)),
            const Divider(),
            ListTile(
              title: const Text(
                "Dark Mode",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: const Text("Use the dark mode"),
              trailing: CupertinoSwitch(
                onChanged: (val) {
                  //  notifier.toggleTheme();
                },
                value: false,
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
