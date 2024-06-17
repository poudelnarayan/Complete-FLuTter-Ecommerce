import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cancel Logout', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    // The test environment does not update the UI after we
    // an interaction (e.g. tap on a button)
    await tester.tap(logoutButton);
    await tester.pump(); // this will trigger a new frame
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
    expect(dialogTitle, findsNothing);
  });
}
