import 'dart:io';

import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:monster_siren/monster_siren.dart';
import 'package:terra_music/album.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:window_size/window_size.dart';

void main() async {
  // 画面サイズ制限
  WidgetsFlutterBinding.ensureInitialized(); // 呪文

  // 一応OSチェック
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Terra Music');
    setWindowMinSize(const Size(640, 640));
    setWindowMaxSize(Size.infinite);
  }

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

    if (mounted) {
      setState(() {
        _albums = a;
      });
    }
  }

  int _responsiveColumnsCount(Breakpoint breakpoint) {
    switch (breakpoint.window) {
      case WindowSize.xsmall:
        return 2;
      case WindowSize.small:
        return 4;
      case WindowSize.medium:
        return 4;
      case WindowSize.large:
        return 5;
      case WindowSize.xlarge:
        return 6;
      default:
        return 4;
    }
  }

  bool _isLargeWindow(Breakpoint breakpoint) {
    switch (breakpoint.window) {
      case WindowSize.xsmall:
        return false;
      case WindowSize.small:
        return false;
      case WindowSize.medium:
        return true;
      case WindowSize.large:
        return true;
      case WindowSize.xlarge:
        return true;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final breakpoint = Breakpoint.fromConstraints(constraints);

      return Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Row(
                children: [
                  if (_isLargeWindow(breakpoint))
                    SizedBox(
                      width: 280,
                      child: Container(),
                    ),
                  Expanded(
                    child: Navigator(
                      key: GlobalKey(),
                      onGenerateRoute: (routeSettings) {
                        return MaterialPageRoute(
                          builder: (context) => SafeArea(
                            bottom: false,
                            child: RefreshIndicator(
                              color: Colors.black,
                              onRefresh: () {
                                _fetchAllAlbums();
                                return Future.delayed(
                                    const Duration(seconds: 1));
                              },
                              child: GridView.count(
                                crossAxisCount:
                                    _responsiveColumnsCount(breakpoint),
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                                padding: const EdgeInsets.all(8.0),
                                children: [
                                  for (final album in _albums)
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AlbumPage(album: album),
                                          ),
                                        );
                                      },
                                      icon: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: album.coverUrl),
                                      padding: const EdgeInsets.all(0.0),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (_isLargeWindow(breakpoint))
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade900),
                  width: 280,
                  child: Column(
                    children: const [
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Placeholder(),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          );
        }),
        backgroundColor: Colors
            .black87, // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
