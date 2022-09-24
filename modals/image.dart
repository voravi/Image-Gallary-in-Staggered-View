class Images {
  final String name;
  final String url;
  final String twitterUsername;
  final String location;

  Images({
    required this.name,
    required this.url,
    required this.location,
    required this.twitterUsername,
  });

  factory Images.fromMap({required Map data}) {
    return Images(
      name: data["user"]["name"],
      url: data["urls"]["full"],
      location: data["location"]["title"],
      twitterUsername: data["user"]["twitter_username"],
    );
  }
}
