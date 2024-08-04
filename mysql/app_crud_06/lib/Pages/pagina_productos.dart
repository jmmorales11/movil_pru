import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'agregar_producto.dart'; // La página para agregar productos
import 'actualizar_producto.dart'; // La página para actualizar productos

class PaginaProductos extends StatefulWidget {
  const PaginaProductos({super.key});

  @override
  State<PaginaProductos> createState() => _PaginaProductosState();
}

class _PaginaProductosState extends State<PaginaProductos> {
  List _listaDatos = [];
  bool _cargando = true;
  String _mensajeError = '';

  Future _obtenerDatos() async {
    try {
      final respuesta = await http.get(Uri.parse(
          "http://localhost/Moviles/repositorio/movil_pru/mysql/CRUD_06/conexion.php"));
      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        if (datos is List) {
          setState(() {
            _listaDatos = datos;
            _cargando = false;
          });
        } else {
          setState(() {
            _mensajeError = "La respuesta no es una lista: $datos";
            _cargando = false;
          });
          print("La respuesta no es una lista: $datos");
        }
      } else {
        setState(() {
          _mensajeError = "Respuesta del servidor ${respuesta.statusCode}";
          _cargando = false;
        });
        print("Respuesta del servidor ${respuesta.statusCode}");
      }
    } catch (e) {
      setState(() {
        _mensajeError = "Error al obtener datos: $e";
        _cargando = false;
      });
      print(e);
    }
  }

  Future<void> _eliminarProducto(String id) async {
    try {
      final respuesta = await http.post(
        Uri.parse(
            "http://localhost/Moviles/repositorio/movil_pru/mysql/CRUD_06/eliminar.php"),
        body: {'producto_id': id},
      );
      if (respuesta.statusCode == 200) {
        final body = jsonDecode(respuesta.body);
        if (body['mensaje'] == 'Éxito') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Producto eliminado con éxito')),
          );
          _obtenerDatos(); // Recargar la lista de productos
        } else {
          print('Error: ${body['mensaje']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar el producto')),
          );
        }
      } else {
        print('Error: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _obtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _mensajeError.isNotEmpty
              ? Center(child: Text(_mensajeError))
              : ListView.builder(
                  itemCount: _listaDatos.length,
                  itemBuilder: ((context, index) {
                    final producto = _listaDatos[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          producto["nombre_productos"] ??
                              'Nombre no disponible',
                        ),
                        subtitle: Text(
                          producto["precio_producto"] ?? 'Precio no disponible',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActualizarProducto(
                                      id: producto["id_productos"],
                                      nombre: producto["nombre_productos"],
                                      precio: producto["precio_producto"],
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  _obtenerDatos();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _eliminarProducto(producto["id_productos"]),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarProducto(),
            ),
          );
          if (result == true) {
            _obtenerDatos();
          }
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
