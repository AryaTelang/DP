import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:bachat_cards/main.dart' as app;

void main() {
  group('Login', () {
    testWidgets('Successful login', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text("SKIP"));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Existing User'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Phone')), '9850267530');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Send OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Wrong phone number', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      await widgetTester.pumpAndSettle(const Duration(seconds: 2));
      await widgetTester.dragFrom(
          widgetTester.getTopLeft(find.byType(GetMaterialApp)),
          const Offset(300, 0));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Logout'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Existing User'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Phone')), '98502675301');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Send OTP'));
      await widgetTester.pumpAndSettle();
      expect(find.text("Please enter a valid phone numner"), findsOneWidget);
    });

    testWidgets("Wrong OTP entered", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Existing User'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Phone')), '9850267530');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Send OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('OTP')), '123450');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      expect(find.text("Error"), findsOneWidget);
    });
  });

  group("View cards", () {
    testWidgets("User has only once loadable cards", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Existing User'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Phone')), '9850267530');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Send OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Account'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('My Cards'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Multi-loadable'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Get Card'), findsNothing);
    });

    testWidgets('User has only multi loadable card', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Get Card'), findsNothing);
    });

    testWidgets("User has both once-loadable and multi-loadable cards",
        (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Get Card'), findsNothing);
    });
  });

  group("Purchase Once-reloadable Cards", () {
    testWidgets("User enters wrong amount", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Get more'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Name')), 'Mayur Komar');
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('Amount')), '');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Get Card'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Please enter amount'), findsOneWidget);
    });

    testWidgets("User enters invalid name", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Get more'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('Name')), '');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Get Card'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Please enter a name'), findsOneWidget);
    });

    testWidgets("Payment failure", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Get more'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Name')), 'Mayur Komar');
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('Amount')), '1');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Get Card'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Failure'));
      await widgetTester.pumpAndSettle();
      expect(find.text("Uh oh...."), findsOneWidget);
    });
  });

  group("Reload Multi-loadable card", () {
    testWidgets("User enter invalid amount", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Multi-loadable'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Add balance'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('Amount')), '');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Add Money'));
      await widgetTester.pumpAndSettle();
      expect(find.text("Please enter amount"), findsOneWidget);
    });

    // TODO:Test after resolving the issue
    // testWidgets("Payment failed", (widgetTester) async{
    //   app.main();
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.pumpWidget(const app.MyApp());
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text("SKIP"));
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text('Existing User'));
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.enterText(
    //       find.byKey(const Key('Phone')), '9850267530');
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text('Send OTP'));
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text('Verify OTP'));
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text('Multi-loadable'));
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text('Add balance'));
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.enterText(find.byKey(const Key('Amount')), '1');
    //   await widgetTester.pumpAndSettle();
    //   await widgetTester.tap(find.text('Add Money'));
    //   await widgetTester.pumpAndSettle();

    // });
  });

  group("Redeem Points", () {
    testWidgets("Not enough points", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Rewards'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Search...'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('search')), "Flipkart");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('Gesture')));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Reward amount')), '10');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Checkout'));
      await widgetTester.pumpAndSettle();
      expect(find.text('You don\'t have enough points'), findsOneWidget);
    });

    testWidgets("Redeem successful", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      await widgetTester.dragFrom(
          widgetTester.getTopLeft(find.byType(GetMaterialApp)),
          const Offset(300, 0));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Logout'));
      await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Existing User'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Phone')), '7014152658');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Send OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Rewards'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Search...'));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(find.byKey(const Key('search')), "Flipkart");
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('Gesture')));
      await widgetTester.pumpAndSettle();
      await widgetTester.enterText(
          find.byKey(const Key('Reward amount')), '10');
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Checkout'));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('Yes'));
      await widgetTester.pumpAndSettle();
      expect(find.text('Points Redeemption Successful'), findsOneWidget);
    });
  });

  group("Transactions", () {
    testWidgets("No transactions available", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpWidget(const app.MyApp());
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text("SKIP"));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Existing User'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(
      //     find.byKey(const Key('Phone')), '9850267530');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Send OTP'));
      // await widgetTester.pumpAndSettle();
      // await widgetTester.enterText(find.byKey(const Key('OTP')), '123456');
      // await widgetTester.pumpAndSettle();
      // await widgetTester.tap(find.text('Verify OTP'));
      await widgetTester.pumpAndSettle();
      await widgetTester.dragFrom(
          widgetTester.getTopLeft(find.byType(GetMaterialApp)),
          const Offset(300, 0));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text('My Transactions'));
      await widgetTester.pumpAndSettle();
      expect(
          find.text('You don\'t have any transactions yet!!!'), findsOneWidget);
    });
  });
}
