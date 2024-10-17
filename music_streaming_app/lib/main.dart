import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/song_list_screen.dart';
import 'services/auth_service.dart';
import 'services/song_service.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Text('An error occurred: ${details.exception}'),
      ),
    );
  };
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => SongService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Streaming App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          if (authService.pb.authStore.isValid) {
            return SongListScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}