import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PenmenuWidget extends StatelessWidget {
  const PenmenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff000000),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffE61B1B),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF5400),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE600),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff25E600),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff004DE6),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF80FF),
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {}, child: const Text('SS')),
                  TextButton(onPressed: () {}, child: const Text('S')),
                  TextButton(onPressed: () {}, child: const Text('M')),
                  TextButton(onPressed: () {}, child: const Text('L')),
                  TextButton(onPressed: () {}, child: const Text('LL')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
