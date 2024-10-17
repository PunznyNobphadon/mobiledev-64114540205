class Song {
  final String id;
  final String songName;
  final String artist;
  final String musicLink;
  final DateTime created;
  final DateTime updated;

  Song({
    required this.id,
    required this.songName,
    required this.artist,
    required this.musicLink,
    required this.created,
    required this.updated,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      songName: json['song_name'],
      artist: json['artist'],
      musicLink: json['music_link'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }
}