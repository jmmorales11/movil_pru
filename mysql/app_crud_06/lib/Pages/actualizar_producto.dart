import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ActualizarProducto extends StatefulWidget {
  final String id;
  final String nombre;
  final String precio;

  const ActualizarProducto({
    super.key,
    required this.id,
    required this.nombre,
    required this.precio,
  });

  @override
  State<ActualizarProducto> createState() => _ActualizarProductoState();
}

class _ActualizarProductoState extends State<ActualizarProducto> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nombreProducto;
  late TextEditingController precioProducto;

  @override
  void initState() {
    super.initState();
    nombreProducto = TextEditingController(text: widget.nombre);
    precioProducto = TextEditingController(text: widget.precio);
  }

  Future<bool> _actualizar() async {
    try {
      final respuesta = await http.post(
        Uri.parse(
            'http://localhost/Moviles/repositorio/movil_pru/mysql/CRUD_06/actualizar.php'),
        body: {
          'producto_id': widget.id,
          'nombre_productos': nombreProducto.text,
          'precio_producto': precioProducto.text,
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
        title: const Text("Actualizar producto"),
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
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                    return "vacio";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    bool exito = await _actualizar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(exito
                            ? 'Datos actualizados exitosamente'
                            : 'Error al actualizar los datos'),
                      ),
                    );
                    if (exito) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
