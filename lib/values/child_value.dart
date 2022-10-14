class ChildValue {
  String name;
  List<String> prefferdFood;
  List<String> hateFood;
  String favoriteFood;

  ChildValue(this.name, this.prefferdFood, this.hateFood, this.favoriteFood);

  ChildValue.empty() : this("", [], [], "");
}
