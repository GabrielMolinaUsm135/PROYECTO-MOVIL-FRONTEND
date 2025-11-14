class Monitor {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imageAsset;

  Monitor({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imageAsset,
  });
}


final List<Monitor> listaProductos = [
  Monitor(
    id: 'm1',
    nombre: 'Monitor Acer KG241Y',
    descripcion: 'Monitor Full HD 24", 165hz, 1ms, FreeSync, HDMI y VGA.',
    precio: 180000,
    imageAsset: 'assets/images/Monitores/acer.png',
  ),
  Monitor(
    id: 'm2',
    nombre: 'Monitor MSI Optix G241',
    descripcion: 'Monitor Full HD 27", 180hz, 1ms, FreeSync, HDMI y DisplayPort.',
    precio: 245000,
    imageAsset: 'assets/images/Monitores/msi.png',
  ),
  Monitor(
    id: 'm3',
    nombre: 'Monitor Master G MGMG2730',
    descripcion: 'Monitor Full HD 27", 180hz, 1ms, FreeSync, HDMI y DisplayPort.',
    precio: 150000,
    imageAsset: 'assets/images/Monitores/masterg.png',
  ),
];