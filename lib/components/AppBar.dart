import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String title;
  const MyAppBar(
      {super.key,
      this.automaticallyImplyLeading = true,
      this.title = "PDF Reader"});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.red[800],
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: const Icon(Icons.home, color: Colors.white))
      ],
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
