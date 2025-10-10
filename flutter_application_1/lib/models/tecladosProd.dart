class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imageAsset;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imageAsset,
  });
}


final List<Producto> listaProductos = [
  Producto(
    id: 'k1',
    nombre: 'Teclado Razer Huntsman Mini',
    descripcion: 'Teclado mecánico compacto 65%, switches ópticos. Retroiluminación RGB.',
    precio: 120.000,
    imageAsset: 'assets/images/teclados/razer.png',
  ),
  Producto(
    id: 'k2',
    nombre: 'Teclado Redragon Kumara',
    descripcion: 'Tenkeyless con macros y diseño resistente.',
    precio: 45.000,
    imageAsset: 'assets/images/teclados/reddragon.png',
  ),
  Producto(
    id: 'k3',
    nombre: 'Teclado Logitech G213',
    descripcion: 'Perfil bajo, switches silenciosos y diseño elegante para oficina.',
    precio: 75.000,
    imageAsset: 'assets/images/teclados/logitech.png',
  ),
];
