import 'package:flutter/material.dart';

class FavoriteShowcase extends StatelessWidget {
  final GlobalKey deleteKey;

  const FavoriteShowcase({super.key, required this.deleteKey});

  @override
  Widget build(BuildContext context) {
    return
        // description: "favorite_delete".tr(),
        Dismissible(
      key: const Key("dummy"),
      onDismissed: (direction) {},
      child: const Card(
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Icon(Icons.book),
          title: Text("Dummy Book"),
          subtitle: Text("Dummy Author"),
        ),
      ),
    );
  }
}
