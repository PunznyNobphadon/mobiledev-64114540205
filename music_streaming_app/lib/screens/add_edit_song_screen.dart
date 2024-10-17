import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_streaming_app/services/song_service.dart';
import 'package:music_streaming_app/models/song.dart';

class AddEditSongScreen extends StatefulWidget {
  final Song? song;

  AddEditSongScreen({this.song});

  @override
  _AddEditSongScreenState createState() => _AddEditSongScreenState();
}

class _AddEditSongScreenState extends State<AddEditSongScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _songName;
  late String _artist;
  late String _musicLink;

  @override
  void initState() {
    super.initState();
    _songName = widget.song?.songName ?? '';
    _artist = widget.song?.artist ?? '';
    _musicLink = widget.song?.musicLink ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final songService = Provider.of<SongService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song == null ? 'Add Song' : 'Edit Song'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: _songName,
              decoration: InputDecoration(labelText: 'Song Name'),
              validator: (value) => value!.isEmpty ? 'Enter a song name' : null,
              onSaved: (value) => _songName = value!,
            ),
            TextFormField(
              initialValue: _artist,
              decoration: InputDecoration(labelText: 'Artist'),
              validator: (value) => value!.isEmpty ? 'Enter an artist' : null,
              onSaved: (value) => _artist = value!,
            ),
            TextFormField(
              initialValue: _musicLink,
              decoration: InputDecoration(labelText: 'Music Link'),
              validator: (value) => value!.isEmpty ? 'Enter a music link' : null,
              onSaved: (value) => _musicLink = value!,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text(widget.song == null ? 'Add Song' : 'Update Song'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    if (widget.song == null) {
                      await songService.addSong(_songName, _artist, _musicLink);
                    } else {
                      await songService.updateSong(widget.song!.id, _songName, _artist, _musicLink);
                    }
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to ${widget.song == null ? 'add' : 'update'} song: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}