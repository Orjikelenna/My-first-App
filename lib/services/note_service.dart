import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class NoteService {
  final CollectionReference _notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // Add a note
  Future<void> addNote(String noteText) async {
    await _notes.add({
      'note': noteText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    await _notes.doc(id).delete();
  }

  // Stream of notes
  Stream<List<Note>> getNotes() {
    return _notes.orderBy('timestamp').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
