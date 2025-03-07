import 'package:flutter/widgets.dart';
import 'package:rick_test/constrains/preferences.dart';

class FavoritePage {
  Widget buildFavorite(BuildContext context){
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: RickAndMortyColors.secondaryColor,
        ),
        child: Center(child: Text('FavoritePage will soon', style: RickAndMortyTextStyles.black16,)),
      ),
    );
  }
}