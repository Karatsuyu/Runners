import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runners/widgets/login_form.dart';

void main() {
  group('Pruebas del LoginForm', () {

    testWidgets('El widget debe mostrar los campos y el botón', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(onLogin: (email, pass) {}),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Ingresar'), findsOneWidget);
    });

    testWidgets('Al presionar botón se llama a onLogin', (tester) async {
      bool llamadaRealizada = false;
      String emailCapturado = '';
      String passCapturado = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (email, pass) {
                llamadaRealizada = true;
                emailCapturado = email;
                passCapturado = pass;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'test@mail.com');
      await tester.enterText(find.byType(TextField).last, 'secreto123');
      await tester.tap(find.text('Ingresar'));
      await tester.pump();

      expect(llamadaRealizada, true);
      expect(emailCapturado, 'test@mail.com');
      expect(passCapturado, 'secreto123');
    });

  });
}
