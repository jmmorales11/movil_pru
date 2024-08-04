import 'package:app_crud_06/validate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

class AgregarProducto {
  final http.Client client;

  AgregarProducto({required this.client});

  Future<bool> guardar(String nombreProducto, String precioProducto, String baseUrl) async {
    if (!validarNombreProducto(nombreProducto)) {
      return false;
    }
    if (!validarPrecioProducto(precioProducto)) {
      return false;
    }
    try {
      final respuesta = await client.post(
        Uri.parse(baseUrl),
        body: {
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

  String baseUrlCreate = "http://localhost:8080/moviles/movil_pru/mysql/CRUD_06/create.php";
  group('AgregarProducto', () {
    test('Guardado exitosamente con validaciones correctas', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Éxito'}), 200);
      });

      final agregarProducto = AgregarProducto(client: mockClient);
      final resultado = await agregarProducto.guardar('Lechuga', '20.00', baseUrlCreate);

      expect(resultado, true);
    });

    test('Error en nombre del producto', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Éxito'}), 200);
      });

      final agregarProducto = AgregarProducto(client: mockClient);
      final resultado = await agregarProducto.guardar('Lechuga##', '20.00', baseUrlCreate);

      expect(resultado, false);
    });

    test('Error en precio del producto', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Éxito'}), 200);
      });

      final agregarProducto = AgregarProducto(client: mockClient);
      final resultado = await agregarProducto.guardar('Lechuga', '20.000', baseUrlCreate);

      expect(resultado, false);
    });

    test('Error al guardar con error del servidor', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'mensaje': 'Error', 'error': 'Detalle del error'}), 200);
      });

      final agregarProducto = AgregarProducto(client: mockClient);
      final resultado = await agregarProducto.guardar('Lechuga', '200.00', baseUrlCreate);

      expect(resultado, false);
    });
  });
}
