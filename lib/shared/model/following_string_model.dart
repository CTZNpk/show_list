class FollowingStringModel {
  FollowingStringModel({required this.followingData, required this.dataDate});

  factory FollowingStringModel.fromMap(Map map) {
    return FollowingStringModel(
      followingData: map['info'],
      dataDate: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String followingData;
  DateTime dataDate;

  Map<String,dynamic> toMap() {
    return {
      'info': followingData,
      'time': dataDate.millisecondsSinceEpoch,
    };
  }
}
