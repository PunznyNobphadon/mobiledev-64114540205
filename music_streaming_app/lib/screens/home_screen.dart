import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_streaming_app/services/auth_service.dart';
import 'package:music_streaming_app/services/song_service.dart';
import 'package:music_streaming_app/models/song.dart';
import 'login_screen.dart';
import 'add_edit_song_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final songService = Provider.of<SongService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddEditSongScreen(song: song)),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this song?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          try {
                            await songService.deleteSong(song.id);
                            setState(() {});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete song: ${e.toString()}')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditSongScreen()),
          );
          if (result == true) {
            setState(() {});
          }
        },
      ),
    );
  }
}