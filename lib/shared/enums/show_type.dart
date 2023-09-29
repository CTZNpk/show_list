enum ShowType {
  movie('movie'),
  show('show'),
  anime('anime');


  final String type;
  const ShowType(this.type);

  factory ShowType.fromString(String string){
    return values.firstWhere((element) => element.type == string);
  }
}
