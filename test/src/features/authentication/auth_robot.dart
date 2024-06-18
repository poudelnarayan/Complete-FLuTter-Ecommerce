import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> openEmailPasswordSignInScreen() async {
    final emailPasswordSignInButton = find.byKey(MoreMenuButton.signInKey);
    expect(emailPasswordSignInButton, findsOneWidget);
    await tester.tap(emailPasswordSignInButton);
    await tester.pumpAndSettle();
  }

  Future<void> pumpEmailPasswordSignInContent({
    required FakeAuthRepository authRepository,
    required EmailPasswordSignInFormType formType,
    VoidCallback? onSignedIn,
  }) {
    return tester.pumpWidget(ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EmailPasswordSignInContents(
            formType: formType,
            onSignedIn: onSignedIn,
          ),
        ),
      ),
    ));
  }

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pumpAndSettle();
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
    await tester.pump();
  }

  Future<void> signInWithEmailAndPassword() async {
    await enterEmail('test@test.com');
    await enterPassword('test1234');
    await tapEmailAndPasswordSubmitButton();
  }

  Future<void> openAccountScreen() async {
    final accountButton = find.byKey(MoreMenuButton.accountKey);
    expect(accountButton, findsOneWidget);
    await tester.tap(accountButton);
    await tester.pumpAndSettle();
  }

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(
              authRepository,
            )
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(initialLocation: '/', routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const AccountScreen(),
            ),
          ]),
        ),
      ),
    );
    await tester
        .pumpAndSettle(); // Ensure everything is settled after the widget is pumped
  }

  Future<void> tapLogoutButton({bool? pumpOnly}) async {
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    if (pumpOnly != null) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester
        .pumpAndSettle(); // Ensure the dialog is dismissed and UI settles
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  Future<void> tapDialogLogoutButton({bool? pumpOnly}) async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    if (pumpOnly != null) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byKey(loadingKey);
    expect(finder, findsOneWidget);
  }
}
