import 'package:cosmetica_project/core/localization/app_localizations.dart';
import 'package:cosmetica_project/features/business_signup_feature/presentation/widgets/selected_document_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpTile(
  WidgetTester tester, {
  required String fileName,
  VoidCallback? onChange,
  VoidCallback? onRemove,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SelectedDocumentTile(
          fileName: fileName,
          filePath: 'missing/$fileName',
          fileSize: 2 * 1024 * 1024 + 300 * 1024,
          onChange: onChange ?? () {},
          onRemove: onRemove ?? () {},
        ),
      ),
    ),
  );
  // Let the JSON translations load.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows the file name, size and the selected state',
      (tester) async {
    await _pumpTile(tester, fileName: 'register.pdf');

    expect(find.text('register.pdf'), findsOneWidget);
    expect(find.textContaining('تم اختيار الملف'), findsOneWidget);
    expect(find.textContaining('2.3 MB'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
  });

  testWidgets('any other format is accepted and shown with a file icon',
      (tester) async {
    await _pumpTile(tester, fileName: 'register.docx');

    expect(find.text('register.docx'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.insert_drive_file_outlined), findsOneWidget);
  });

  testWidgets('tapping the tile changes the file, the close button removes it',
      (tester) async {
    var changed = 0;
    var removed = 0;
    await _pumpTile(
      tester,
      fileName: 'register.jpg',
      onChange: () => changed++,
      onRemove: () => removed++,
    );

    await tester.tap(find.text('register.jpg'));
    await tester.tap(find.byIcon(Icons.close));

    expect(changed, 1);
    expect(removed, 1);
  });
}
