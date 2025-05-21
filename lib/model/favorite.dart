// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  @HiveField(0)
  String strDrink;

  @HiveField(1)
  String strDrinkThumb;

  @HiveField(2)
  String idDrink;
  Favorite({
    required this.strDrink,
    required this.strDrinkThumb,
    required this.idDrink,
  });
}
