import 'package:flutter/material.dart';
import 'package:monster_siren/monster_siren.dart';
import 'package:terra_music/album.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terra Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final client = MonsterSiren();

  List<AlbumsItem> _albums = [];

  void _fetchAllAlbums() async {
    final a = await client.getAlbums();

    setState(() {
      _albums = a;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: Colors.black,
          onRefresh: () {
            _fetchAllAlbums();
            return Future.delayed(const Duration(seconds: 1));
          },
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: [
              for (final album in _albums)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumPage(album: album),
                      ),
                    );
                  },
                  icon: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage, image: album.coverUrl),
                  padding: const EdgeInsets.all(0.0),
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors
          .black87, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
