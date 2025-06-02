import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Example of a slightly more styled AppBar
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          // color: Colors.white, // Assuming AppBar background makes this visible
        ),
      ),
      // elevation: 2.0, // Subtle shadow
      // centerTitle: true, // Optional: center the title
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
