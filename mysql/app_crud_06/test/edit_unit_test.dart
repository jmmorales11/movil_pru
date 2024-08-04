import 'package:app_crud_06/validate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

class ActualizarProducto {
  final http.Client client;

  ActualizarProducto({required this.client});

  Future<bool> actualizar(String id, String nombreProducto, String precioProducto, String baseUrl) async {
    // Validar el nombre del producto
    if (!validarNombreProducto(nombreProducto)) {
      return false;
    }
    // Validar el precio del producto
    if (!validarPrecioProducto(precioProducto)) {
      return false;
    }
    try {
      final respuesta = await client.post(
        Uri.parse(baseUrl),
        body: {
          'producto_id': id,
          'nombre_productos': nombreProducto,
          'precio_producto': precioProducto,
        },
      );

      if (respuesta.statusCode == 200) {
        final body = jsonDecode(respuesta.body);
        if (body['mensaje'] == 'Éxito') {
          return true;
        } else {
          print('Error: ${body['mensaje']}');
          if (body.containsKey('error')) {
            print("Detalles del error ${body['error']}");
          } else {
            print('Respuesta del servidor ${respuesta.statusCode}');
          }
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

void main() {
  String baseUrlEdit = "http://localhost:8080/moviles/movil_pru/mysql/CRUD_06/actualizar.php";

  group('ActualizarProducto', () {
    test('Actualización exitosa con validaciones correctas', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Éxito'}), 200);
      });

      final actualizarProducto = ActualizarProducto(client: mockClient);
      final resultado = await actualizarProducto.actualizar('123', 'Lechuga', '20.00', baseUrlEdit);

      expect(resultado, true);
    });

    test('Error en nombre del producto durante la edición', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Éxito'}), 200);
      });

      final actualizarProducto = ActualizarProducto(client: mockClient);
      final resultado = await actualizarProducto.actualizar('123', 'Lechuga##', '20.00', baseUrlEdit);

      expect(resultado, false);
    });

    test('Error en precio del producto durante la edición', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Éxito'}), 200);
      });

      final actualizarProducto = ActualizarProducto(client: mockClient);
      final resultado = await actualizarProducto.actualizar('123', 'Lechuga', '20.000', baseUrlEdit);

      expect(resultado, false);
    });

    test('Error al actualizar con error del servidor', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Error', 'error': 'Detalle del error'}), 200);
      });

      final actualizarProducto = ActualizarProducto(client: mockClient);
      final resultado = await actualizarProducto.actualizar('123', 'Lechuga', '20.00', baseUrlEdit);

      expect(resultado, false);
    });
  });
}
