class Audifono {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imageAsset;

  Audifono({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imageAsset,
  });
}

final List<Audifono> listaAudifonos = [
  Audifono(
    id: 'A1',
    nombre: 'Hyperx Cloud II',
    descripcion: 'Alcance inalámbrico de 20 m, Con cancelación de ru...',
    precio: 42990,
    imageAsset: 'assets/images/Audifonos/hyperx.png',
  ),
  Audifono(
    id: 'A2',
    nombre: 'Razer Kraken',
    descripcion: 'Modo manos libres incluido, Con cancelación de rui...',
    precio: 299000,
    imageAsset: 'assets/images/Audifonos/razerkraken.png',
  ),
  Audifono(
    id: 'A3',
    nombre: 'Reddragon zeus x',
    descripcion: 'Micrófono flexible, Resistentes al polvo, Inalámb...',
    precio: 79990,
    imageAsset: 'assets/images/Audifonos/reddragon.png',
  ),
];
