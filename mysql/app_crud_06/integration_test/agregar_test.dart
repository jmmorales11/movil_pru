import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app_crud_06/Pages/agregar_producto.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Prueba de integración para AgregarProducto', (WidgetTester tester) async {
    // Carga directamente la página de agregar producto
    await tester.pumpWidget(MaterialApp(
      home: AgregarProducto(),
    ));

    // Verifica que se cargue la página de agregar producto
    expect(find.byType(AgregarProducto), findsOneWidget);

    // Introduce datos en los campos de texto
    await tester.enterText(find.byKey(Key('nombreProducto')), 'NuevoProducto');
    await tester.enterText(find.byKey(Key('precioProducto')), '3.50');
    await tester.pumpAndSettle();

    // Simula el guardado de datos
    await tester.tap(find.byKey(Key('guardarButton')));
    await tester.pumpAndSettle();

    // Verifica que se muestra un SnackBar con el mensaje de éxito
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Datos guardados exitosamente'), findsOneWidget);
  });
}