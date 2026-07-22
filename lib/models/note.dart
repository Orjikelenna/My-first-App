class Note {
  final String id;
  final String note;
  final DateTime? timestamp;

  Note({required this.id, required this.note, this.timestamp});

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      note: data['note'] ?? '',
      timestamp: data['timestamp']?.toDate(),
    );
  }
}
