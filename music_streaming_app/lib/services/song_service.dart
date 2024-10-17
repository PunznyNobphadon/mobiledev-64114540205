import 'package:pocketbase/pocketbase.dart';
import 'package:music_streaming_app/models/song.dart';

class SongService {
  final PocketBase pb = PocketBase('http://127.0.0.1:8090/');

  Future<List<Song>> getSongs() async {
    final records = await pb.collection('songs').getFullList();
    return records.map((record) => Song.fromJson(record.toJson())).toList();
  }

  Future<void> addSong(String songName, String artist, String musicLink) async {
    await pb.collection('songs').create(body: {
      'song_name': songName,
      'artist': artist,
      'music_link': musicLink,
    });
  }

  Future<void> updateSong(String id, String songName, String artist, String musicLink) async {
    await pb.collection('songs').update(id, body: {
      'song_name': songName,
      'artist': artist,
      'music_link': musicLink,
    });
  }

  Future<void> deleteSong(String id) async {
    await pb.collection('songs').delete(id);
  }
}