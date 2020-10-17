class MediaImageInfo {
  final double aspectRatio;
  final String filePath;
  final int height;
  final int width;

  const MediaImageInfo({
    this.aspectRatio,
    this.filePath,
    this.height,
    this.width,
  });

  factory MediaImageInfo.fromJson(Map<String, dynamic> json) {
    return MediaImageInfo(
      // aspectRatio: json['aspect_ratio'] as double,
      filePath: json['file_path'] as String,
      // height: json['height'] as int,
      // width: json['width'] as int,
    );
  }
}
