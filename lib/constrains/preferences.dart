import 'package:flutter/material.dart';

class RickAndMortyColors {
  static const Color mainColor = Color.fromARGB(255, 28, 28, 30); // Тёмный фон
  static const Color secondaryColor = Color.fromARGB(255, 124, 252, 0); // Ядовито-зелёный (порталы)
  static const Color seedColor = Color.fromARGB(255, 0, 255, 255); // Неоново-голубой (костюм Рика)
  static const Color anotherColor = Color.fromARGB(100, 255, 61, 129); // Кислотно-розовый (для акцентов)
}

class RickAndMortyTextStyles {
  static const TextStyle portalGreen30 = TextStyle(
    color: Color.fromARGB(255, 124, 252, 0), // Ядовито-зелёный (порталы)
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle neonBlue24 = TextStyle(
    color: Color.fromARGB(255, 0, 255, 255), // Неоново-голубой (костюм Рика)
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle toxicPink14 = TextStyle(
    color: Color.fromARGB(255, 255, 61, 129), // Кислотно-розовый (для акцентов)
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle white16 = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle darkGrey18 = TextStyle(
    color: Color.fromARGB(255, 44, 44, 46), // Тёмный фон, но не чёрный
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle black30 = TextStyle(
    color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle black24 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle black16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
