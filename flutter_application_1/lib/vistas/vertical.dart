import 'package:flutter/material.dart';

class Verticaltab extends StatefulWidget {
  const Verticaltab({super.key});

  @override
  State<Verticaltab> createState() => _VerticaltabState();
}

class _VerticaltabState extends State<Verticaltab> {
  int selectedIndex = 0;
  late final PageController _pageController;

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
                  setState(() {
                    selectedIndex = index;
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
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
                            child: Text('Titulo $index'),
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
            children: const [
              Center(child: Text('Pagina 1')),
              Center(child: Text('Pagina 2')),
              Center(child: Text('Pagina 3')),
              Center(child: Text('Pagina 4')),
            ],
          ),
        )
      ],
    );
  }
}