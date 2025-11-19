//funcion snackbar para añadir el mensaje que se requiera, dentro de la vista colocar la funcion y definir el mensaje a mostrar
import 'package:flutter/material.dart';

void mostrarSnackbar(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      duration: const Duration(seconds: 2),
    ),
  );
}
