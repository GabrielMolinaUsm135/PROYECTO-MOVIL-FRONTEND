class Mouse {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imageAsset;

  Mouse({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imageAsset,
  });
}

final List<Mouse> listaMouses = [
  Mouse(
    id: 'M1',
    nombre: 'Logitech G203',
    descripcion: 'sensor óptico de hasta 8000 DPI, 6 botones program...',
    precio: 17900,
    imageAsset: 'assets/images/Mouses/logitechg203.png',
  ),
  Mouse(
    id: 'M2',
    nombre: 'Razer Viper Mini',
    descripcion: 'Switch Óptico, 8500 DPI, 6 Botones, Conexión usb',
    precio: 50000,
    imageAsset: 'assets/images/Mouses/razermini.png',
  ),
  Mouse(
    id: 'M3',
    nombre: 'Logitech G502',
    descripcion: 'sensor HERO 25K, 11 botones programables, hasta 25...',
    precio: 53990,
    imageAsset: 'assets/images/Mouses/logitechg502.png',
  ),
];
