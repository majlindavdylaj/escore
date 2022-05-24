class Post {

  final String? puid;
  final String? uuid;
  final String? video;
  final String? description;

  Post({
    this.puid,
    this.uuid,
    this.video,
    this.description,
  });

  Post.fromJson(Map<String, dynamic> json)
      : puid = json['puid'],
        uuid = json['uuid'],
        video = json['video'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'puid': puid,
        'uuid': uuid,
        'video': video,
        'description': description
      };

}