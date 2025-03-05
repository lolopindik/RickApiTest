import 'package:flutter/material.dart';
import 'package:rick_test/constrains/preferences.dart';

class HomePage {
  Widget buildHomePage(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        15,
        20,
        15,
        MediaQuery.of(context).size.height * 0.2,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio:
            0.7, // Adjusted to make cards taller (lower value = taller cards)
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: RickAndMortyColors.secondaryColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2, // Makes image area taller
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red, // TODO: Replace with Image widget
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text('Image', style: RickAndMortyTextStyles.black24),
                  ),
                ),
              ),
              Expanded(
                flex: 1, // Smaller text area relative to image
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: RickAndMortyColors.anotherColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Item $index', // TODO: Replace with name&desription
                      style: RickAndMortyTextStyles.neonBlue24,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
