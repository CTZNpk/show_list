enum PlanType {
  planToWatch('planToWatch'),
  watching('watching'),
  finished('finished');


  final String type;
  const PlanType(this.type);

  factory PlanType.fromString(String string){
    return values.firstWhere((element) => element.type == string);
  }
}

