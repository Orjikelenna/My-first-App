import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  const NoteTile({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.note),
      subtitle: note.timestamp != null
          ? Text(
              '${note.timestamp!.day}/${note.timestamp!.month}/${note.timestamp!.year}',
            )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
