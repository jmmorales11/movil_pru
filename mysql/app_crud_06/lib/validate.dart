// validate.dart
bool validarNombreProducto(String nombre) {
  final regex = RegExp(r"^[a-zA-Z0-9áéíóúñÁÉÍÓÚÑ\s]+$");
  return regex.hasMatch(nombre);
}

bool validarPrecioProducto(String precio) {
  final regex = RegExp(r"^(?:[0-9]|[1-9][0-9])(\.[0-9]{2})?$");
  return regex.hasMatch(precio);
}
