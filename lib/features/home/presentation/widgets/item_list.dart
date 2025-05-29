import 'package:flutter/material.dart';

import '../../domain/entities/item.dart';

class ItemList extends StatelessWidget {
  final List<Item> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: CircleAvatar(child: Text(item.id.toString())),
          title: Text(item.name),
          subtitle: Text(item.description),
          onTap: () {
            // Optional: Add navigation or interaction logic here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on ${item.name}')),
            );
          },
        );
      },
    );
  }
}

