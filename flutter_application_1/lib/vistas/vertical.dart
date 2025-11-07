import 'package:flutter/material.dart';
import 'package:flutter_application_1/vistas/AudifonosView.dart';
import 'package:flutter_application_1/vistas/MonitorView.dart';
import 'package:flutter_application_1/vistas/MouseView.dart';
import 'package:flutter_application_1/vistas/TecladoView.dart';

class Verticaltab extends StatefulWidget {
  const Verticaltab({super.key});

  @override
  State<Verticaltab> createState() => _VerticaltabState();
}

class _VerticaltabState extends State<Verticaltab> {
  int selectedIndex = 0;
  late final PageController _pageController;
  List<String> Categoria = ['Teclados', 'Mouses', 'Monitores', 'Audifonos'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: ListView.separated(
            itemCount: 4,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 5);
            },
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // actualiza la selección visual
                  setState(() {
                    selectedIndex = index;
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });

                  final String categoria = Categoria[index];
                  if (categoria == 'Teclados') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TabTeclado()),
                    );
                  }
                  if (categoria == 'Mouses') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TabMouse()),
                    );
                  }
                  if (categoria == 'Monitores') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TabMonitor()),
                    );
                  }
                  if (categoria == 'Audifonos') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TabAudifonos()),
                    );
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: (selectedIndex == index) ? 50 : 0,
                        width: 5,
                        color: Colors.orange,
                      ),
                      Expanded(
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          duration: const Duration(milliseconds: 500),
                          height: 50,
                          color: (selectedIndex == index)
                              ? Colors.blueGrey.withOpacity(0.2)
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: Text('${Categoria[index]}'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            
          )
        )
      ],
    );
  }
}