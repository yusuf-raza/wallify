class WallhavenWallpaper {
  String? id;
  String? url;
  String? shortUrl;
  int? views;
  int? favorites;
  String? source;
  String? purity;
  String? category;
  int? dimensionX;
  int? dimensionY;
  String? resolution;
  String? ratio;
  int? fileSize;
  String? fileType;
  String? createdAt;
  List<String>? colors;
  String? path;
  Thumbs? thumbs;

  WallhavenWallpaper({
    this.id,
    this.url,
    this.shortUrl,
    this.views,
    this.favorites,
    this.source,
    this.purity,
    this.category,
    this.dimensionX,
    this.dimensionY,
    this.resolution,
    this.ratio,
    this.fileSize,
    this.fileType,
    this.createdAt,
    this.colors,
    this.path,
    this.thumbs,
  });

  WallhavenWallpaper.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    shortUrl = json['short_url'];
    views = json['views'];
    favorites = json['favorites'];
    source = json['source'];
    purity = json['purity'];
    category = json['category'];
    dimensionX = json['dimension_x'];
    dimensionY = json['dimension_y'];
    resolution = json['resolution'];
    ratio = json['ratio'];
    fileSize = json['file_size'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    colors = json['colors']?.cast<String>();
    path = json['path'];
    thumbs = json['thumbs'] != null ? Thumbs.fromJson(json['thumbs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['short_url'] = shortUrl;
    data['views'] = views;
    data['favorites'] = favorites;
    data['source'] = source;
    data['purity'] = purity;
    data['category'] = category;
    data['dimension_x'] = dimensionX;
    data['dimension_y'] = dimensionY;
    data['resolution'] = resolution;
    data['ratio'] = ratio;
    data['file_size'] = fileSize;
    data['file_type'] = fileType;
    data['created_at'] = createdAt;
    data['colors'] = colors;
    data['path'] = path;
    if (thumbs != null) {
      data['thumbs'] = thumbs!.toJson();
    }
    return data;
  }
}

class Thumbs {
  String? small;
  String? large;
  String? original;

  Thumbs({this.small, this.large, this.original});

  Thumbs.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    large = json['large'];
    original = json['original'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['large'] = large;
    data['original'] = original;
    return data;
  }
}
