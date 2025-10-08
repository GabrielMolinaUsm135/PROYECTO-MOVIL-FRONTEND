import 'package:flutter/material.dart';
import 'package:flutter_application_1/vistas/Pagina1.dart';
import 'package:flutter_application_1/vistas/Pagina2.dart';
import 'package:flutter_application_1/vistas/Pagina3.dart';
import 'package:flutter_application_1/vistas/Pagina4.dart';
import 'package:flutter_application_1/vistas/HomeView.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
int _currentIndex = 2;
List<Map<String, dynamic>> _paginas = [
  {'pagina': Pagina1(), 'texto': 'Pagina 1', 'color':0xffd80111, 'icono': Icons.keyboard},
  {'pagina': Pagina2(), 'texto': 'Pagina 2', 'color':0xffd80133, 'icono': Icons.mouse},
  {'pagina': HomeView(), 'texto': 'Home', 'color':0xffd80100, 'icono': Icons.home},
  {'pagina': Pagina3(), 'texto': 'Pagina 3', 'color':0xffd80144, 'icono': Icons.tv},
  {'pagina': Pagina4(), 'texto': 'Pagina 4', 'color':0xffd80163, 'icono': Icons.headphones},
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