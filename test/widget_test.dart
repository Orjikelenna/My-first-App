import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/models/todo.dart';
import 'package:my_first_app/widgets/todo_tile.dart';

void main() {
  group('Todo Model Tests', () {
    test('Todo is created correctly', () {
      final todo = Todo(id: '1', title: 'Buy groceries', isCompleted: false);

      expect(todo.id, equals('1'));
      expect(todo.title, equals('Buy groceries'));
      expect(todo.isCompleted, isFalse);
    });

    test('Todo fromFirestore works correctly', () {
      final data = {
        'title': 'Learn Flutter',
        'isCompleted': true,
        'createdAt': null,
      };

      final todo = Todo.fromFirestore(data, '123');

      expect(todo.id, equals('123'));
      expect(todo.title, equals('Learn Flutter'));
      expect(todo.isCompleted, isTrue);
    });

    test('Todo title is not empty', () {
      final todo = Todo(id: '1', title: 'Test todo', isCompleted: false);

      expect(todo.title.isNotEmpty, isTrue);
    });
  });

  group('TodoTile Widget Tests', () {
    testWidgets('TodoTile displays todo title', (WidgetTester tester) async {
      final todo = Todo(id: '1', title: 'Buy groceries', isCompleted: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoTile(todo: todo, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      expect(find.text('Buy groceries'), findsOneWidget);
    });

    testWidgets('TodoTile shows checkbox', (WidgetTester tester) async {
      final todo = Todo(id: '1', title: 'Test todo', isCompleted: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoTile(todo: todo, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
    });
  });
}
