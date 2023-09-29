class ShortProfileModel {
  ShortProfileModel({
    required this.uid,
    required this.userName,
    required this.profilePic,
    required this.followersCount,
  });

  factory ShortProfileModel.fromMap(Map map) {
    return ShortProfileModel(
      uid: map['uid'],
      userName: map['userName'],
      profilePic: map['profilePic'],
      followersCount: map['followers_count'],
    );
  }

  final String uid;
  final String userName;
  final String profilePic;
  int followersCount;

  Map toMap() {

    return {
      'uid': uid,
      'userName': userName,
      'profilePic': profilePic,
      'followers_count': followersCount,
    };
  }
}
