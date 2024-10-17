import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_streaming_app/services/song_service.dart';
import 'package:music_streaming_app/models/song.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  String _songName = '';
  String _artist = '';
  String _musicLink = '';

  @override
  Widget build(BuildContext context) {
    final songService = Provider.of<SongService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Song Name'),
                    validator: (value) => value!.isEmpty ? 'Enter a song name' : null,
                    onSaved: (value) => _songName = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Artist'),
                    validator: (value) => value!.isEmpty ? 'Enter an artist' : null,
                    onSaved: (value) => _artist = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Music Link'),
                    validator: (value) => value!.isEmpty ? 'Enter a music link' : null,
                    onSaved: (value) => _musicLink = value!,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Add Song'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          await songService.addSong(_songName, _artist, _musicLink);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Song added successfully')),
                          );
                          _formKey.currentState!.reset();
                          setState(() {}); // Refresh the song list
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to add song: ${e.toString()}')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Song>>(
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await songService.deleteSong(song.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Song deleted')),
                              );
                              setState(() {}); // Refresh the song list
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to delete song: ${e.toString()}')),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}