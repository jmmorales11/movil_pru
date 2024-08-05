// agregar_producto.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../validate.dart';

class AgregarProducto extends StatefulWidget {
  const AgregarProducto({super.key});

  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreProducto = TextEditingController();
  TextEditingController precioProducto = TextEditingController();
  String baseUrlCreate = "http://localhost/CRUD_06/create.php";

  Future<bool> _guardar() async {
    if (!validarNombreProducto(nombreProducto.text)) {
      print("Nombre del producto no válido");
      return false;
    }
    if (!validarPrecioProducto(precioProducto.text)) {
      print("Precio del producto no válido");
      return false;
    }
    try {
      final respuesta = await http.post(
        Uri.parse(baseUrlCreate),
        body: {
          'nombre_productos': nombreProducto.text,
          'precio_productos': precioProducto.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar producto"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreProducto,
                key: Key('nombreProducto'),
                decoration: InputDecoration(
                  hintText: "Nombre Producto",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vacio";
                  } else if (!validarNombreProducto(value)) {
                    return "Nombre del producto no válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: Key('precioProducto'),
                controller: precioProducto,
                decoration: InputDecoration(
                  hintText: "Precio Producto",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vacio";
                  } else if (!validarPrecioProducto(value)) {
                    return "Precio del producto no válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: Key('guardarButton'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    bool exito = await _guardar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(exito
                            ? 'Datos guardados exitosamente'
                            : 'Error al guardar los datos'),
                      ),
                    );
                    if (exito) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
