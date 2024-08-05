import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app_crud_06/main.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Prueba de integración para PaginaProductos', (WidgetTester tester) async {
    // Carga la aplicación
    await tester.pumpWidget(MyApp());

    // Navega a la página de productos
    await tester.pumpAndSettle();

    // Verifica que los productos se muestran en la interfaz
    expect(find.text('galletas'), findsOneWidget);
    expect(find.text('pepsi'), findsOneWidget);

    // Simula la eliminación de un producto (suponiendo que la primera eliminación es 'jugos')
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Navega a la página de agregar producto
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  });
}