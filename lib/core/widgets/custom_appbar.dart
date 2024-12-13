import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      forceMaterialTransparency: true,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.asset(
          "assets/images/book_logo.png",
        ),
      ),
      centerTitle: true,
      title: const Text(
        "Sharh al-Aqoid\nan-Nasafiya",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          height: 1,
          color: Color(0xff39aa35),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
