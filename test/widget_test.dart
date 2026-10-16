import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uts_teori_game_app/main.dart';

void main() {
  testWidgets('NexusGame Store Home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify header and search bar render properly
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Menembak'), findsOneWidget);
  });
}
