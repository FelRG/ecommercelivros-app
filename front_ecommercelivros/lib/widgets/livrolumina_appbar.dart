import 'package:flutter/material.dart';

class LivroLuminaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LivroLuminaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.brown,
      elevation: 0,
      title: Row(
        children: const [
          Icon(Icons.menu_book, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'LivroLumina',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
