import 'package:cosmetica_project/core/widgets/otp_code_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<String>> _pump(WidgetTester tester) async {
  final codes = <String>[];
  await tester.pumpWidget(
    MaterialApp(
      home: Directionality(
        // The app is RTL; the code must still read left to right.
        textDirection: TextDirection.rtl,
        child: Scaffold(body: OtpCodeField(onChanged: codes.add)),
      ),
    ),
  );
  return codes;
}

/// The digit shown in each box, left to right ('' when empty).
List<String> _boxes(WidgetTester tester) {
  final texts = tester
      .widgetList<Text>(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Text),
        ),
      )
      .toList();
  final ordered = texts.toList()
    ..sort((a, b) => tester
        .getTopLeft(find.byWidget(a))
        .dx
        .compareTo(tester.getTopLeft(find.byWidget(b)).dx));
  return ordered.map((t) => t.data ?? '').toList();
}

void main() {
  testWidgets('digits fill the boxes from the left', (tester) async {
    final codes = await _pump(tester);

    await tester.enterText(find.byType(TextField), '12');
    await tester.pump();

    expect(_boxes(tester), ['1', '2', '', '', '', '']);
    expect(codes.last, '12');
  });

  testWidgets('tapping a later box still types into the next free one',
      (tester) async {
    await _pump(tester);
    await tester.enterText(find.byType(TextField), '1');
    await tester.pump();

    // Tap the last (right-most) box, then type.
    await tester.tapAt(tester.getTopRight(find.byType(TextField)) +
        const Offset(-10, 10));
    await tester.pump();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.selection.baseOffset, 1);

    await tester.enterText(find.byType(TextField), '19');
    await tester.pump();
    expect(_boxes(tester), ['1', '9', '', '', '', '']);
  });

  testWidgets('deleting removes the last digit', (tester) async {
    final codes = await _pump(tester);
    await tester.enterText(find.byType(TextField), '123');
    await tester.pump();

    await tester.enterText(find.byType(TextField), '12');
    await tester.pump();

    expect(_boxes(tester), ['1', '2', '', '', '', '']);
    expect(codes.last, '12');
  });

  testWidgets('fits a narrow screen without overflowing', (tester) async {
    // Reset password: 360px phone minus 8% padding on each side ≈ 302px.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 302,
              child: OtpCodeField(onChanged: (_) {}),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(OtpCodeField)).width, lessThan(303));
  });

  testWidgets('keeps the full box size on a wide screen', (tester) async {
    await _pump(tester);
    await tester.enterText(find.byType(TextField), '1');
    await tester.pump();

    final box =
        find.ancestor(of: find.text('1'), matching: find.byType(Container));
    // 46px box plus its 3px margin on each side.
    expect(tester.getSize(box.first).width, 46 + 6);
  });

  testWidgets('a pasted code fills every box; extra and non-digits dropped',
      (tester) async {
    final codes = await _pump(tester);

    await tester.enterText(find.byType(TextField), '12a3456789');
    await tester.pump();

    expect(_boxes(tester), ['1', '2', '3', '4', '5', '6']);
    expect(codes.last, '123456');
  });
}
