import 'package:flutter/material.dart';
import 'package:flutter_application_1/vistas/AudifonosView.dart';
import 'package:flutter_application_1/vistas/MouseView.dart';
import 'package:flutter_application_1/vistas/MonitorView.dart';
import 'package:flutter_application_1/vistas/TecladoView.dart';


class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
int _currentIndex = 2;
final List<Map<String, dynamic>> _paginas = [
  {'pagina': TabTeclado(), 'texto': 'Teclados', 'color':0xffd80111, 'icono': Icons.keyboard},
  {'pagina': TabMouse(), 'texto': 'Mouses', 'color':0xffd80133, 'icono': Icons.mouse},
  {'pagina': TabMonitor(), 'texto': 'Monitores', 'color':0xffd80144, 'icono': Icons.tv},
  {'pagina': TabAudifonos(), 'texto': 'Audifonos', 'color':0xffd80163, 'icono': Icons.headphones},
];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_paginas[_currentIndex] ['texto'],style: TextStyle(color:(Colors.white)),),
        backgroundColor: Color(_paginas[_currentIndex]['color']),
      ),
      body: _paginas[_currentIndex]['pagina'],
      bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      items:
      [
        BottomNavigationBarItem(
          icon: Icon(_paginas[0]['icono']),
          label: _paginas[0]['texto'],
          backgroundColor: Color(_paginas[0]['color'])
           ),
           BottomNavigationBarItem(
          icon: Icon(_paginas[1]['icono']),
          label: _paginas[1]['texto'],
          backgroundColor: Color(_paginas[1]['color'])
           ),
           BottomNavigationBarItem(
          icon: Icon(_paginas[2]['icono']),
          label: _paginas[2]['texto'],
          backgroundColor: Color(_paginas[2]['color'])
           ),
           BottomNavigationBarItem(
          icon: Icon(_paginas[3]['icono']),
          label: _paginas[3]['texto'],
          backgroundColor: Color(_paginas[3]['color'])
           ),
           BottomNavigationBarItem(
          icon: Icon(_paginas[4]['icono']),
          label: _paginas[4]['texto'],
          backgroundColor: Color(_paginas[4]['color'])
           ),
      ],
      currentIndex: _currentIndex,
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
      ),

    );
  }
}