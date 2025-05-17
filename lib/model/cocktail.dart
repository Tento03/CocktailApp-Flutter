
class Cocktail {
  List<Drinks>? drinks;

  Cocktail({this.drinks});

  Cocktail.fromJson(Map<String, dynamic> json) {
    drinks = json["drinks"] == null ? null : (json["drinks"] as List).map((e) => Drinks.fromJson(e)).toList();
  }

  static List<Cocktail> fromList(List<Map<String, dynamic>> list) {
    return list.map(Cocktail.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(drinks != null) {
      _data["drinks"] = drinks?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Drinks {
  String? strDrink;
  String? strDrinkThumb;
  String? idDrink;

  Drinks({this.strDrink, this.strDrinkThumb, this.idDrink});

  Drinks.fromJson(Map<String, dynamic> json) {
    strDrink = json["strDrink"];
    strDrinkThumb = json["strDrinkThumb"];
    idDrink = json["idDrink"];
  }

  static List<Drinks> fromList(List<Map<String, dynamic>> list) {
    return list.map(Drinks.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["strDrink"] = strDrink;
    _data["strDrinkThumb"] = strDrinkThumb;
    _data["idDrink"] = idDrink;
    return _data;
  }
}