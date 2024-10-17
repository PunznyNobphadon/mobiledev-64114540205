import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_streaming_app/models/song.dart';
import 'package:music_streaming_app/services/song_service.dart';
import 'package:music_streaming_app/services/auth_service.dart';

class SongListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songService = Provider.of<SongService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Song List')),
      body: FutureBuilder<List<Song>>(
        future: songService.getSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final songs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artist),
                trailing: authService.isAdmin()
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await songService.deleteSong(song.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Song deleted')),
                          );
                        },
                      )
                    : null,
                onTap: () {
                  // TODO: Implement song playback
                },
              );
            },
          );
        },
      ),
      floatingActionButton: authService.isAdmin()
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // TODO: Implement add song screen
              },
            )
          : null,
    );
  }
}