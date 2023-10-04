import 'package:show_list/shared/enums/plan_type.dart';

class FollowingStringModel {
  FollowingStringModel(
      {required this.planType,
      required this.dataDate,
      required this.title,
      required this.userName,
      this.userRating});

  factory FollowingStringModel.fromMap(Map map) {
    return FollowingStringModel(
      planType: PlanType.fromString(map['planType']),
      title: map['title'],
      userName: map['userName'],
      userRating: map['userRating'],
      dataDate: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String userName;
  String title;
  PlanType planType;
  int? userRating;
  DateTime dataDate;

  Map<String, dynamic> toMap() {
    return {
      'planType': planType.name,
      'userName': userName,
      'userRating': userRating,
      'title': title,
      'time': dataDate.millisecondsSinceEpoch,
    };
  }
}
