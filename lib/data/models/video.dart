class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String imageLink;

  // final int size;
  // final String type;
  // final String iso_639_1;
  // final String iso_3166_1;

  const Video({
    this.id,
    this.key,
    this.name,
    this.site,
    this.imageLink,

    // this.size,
    // this.type,
    // this.iso_639_1,
    // this.iso_3166_1,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      site: json['site'] as String,
      imageLink: 'https://i.ytimg.com/vi/${json['key']}/hqdefault.jpg',
    );
  }
}
