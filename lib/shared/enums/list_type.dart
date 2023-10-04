enum ListType {
  followingList('followingList'),
  followersList('followersList'),
  requestList('requestList');

  final String type;
  const ListType(this.type);

  factory ListType.fromString(String string) {
    return values.firstWhere((element) => element.type == string);
  }
}
