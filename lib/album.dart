import 'package:flutter/material.dart';
import 'package:monster_siren/monster_siren.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:transparent_image/transparent_image.dart';

// album view
class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key, required this.album});

  final AlbumsItem album;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  AlbumDetail? _albumDetail;
  bool _loading = true;
  int hoveringSongIndex = -1;

  void _fetchAlbumDetail() {
    final client = MonsterSiren();
    client.getAlbumDetail(widget.album.id).then((value) {
      if (mounted) {
        setState(() {
          _albumDetail = value;
        });
      }

      //wait for 0.1 sec
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        child: Stack(
          children: [
            if (_albumDetail != null)
              ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0),
                      ],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: _albumDetail!.bannerUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            width: 120,
                            height: 42,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade900),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 36,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 32, right: 32),
                      child: Center(
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: widget.album.coverUrl)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(widget.album.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ),
                    if (_albumDetail != null)
                      AnimatedOpacity(
                        opacity: !_loading ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 8, right: 8, bottom: 32),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 480),
                            child: Column(children: [
                              for (final entry
                                  in _albumDetail!.songs.asMap().entries)
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 84,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: LayoutBuilder(builder: (ctx, _) {
                                          return GestureDetector(
                                            child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                onEnter: (_) {
                                                  if (mounted) {
                                                    setState(() {
                                                      hoveringSongIndex =
                                                          entry.key;
                                                    });
                                                  }
                                                },
                                                onExit: (_) {
                                                  if (mounted) {
                                                    setState(() {
                                                      hoveringSongIndex = -1;
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 48,
                                                      child:
                                                          hoveringSongIndex ==
                                                                  entry.key
                                                              ? Container(
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  '${entry.key + 1}',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: TextScroll(
                                                                entry
                                                                    .value.name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                mode: TextScrollMode
                                                                    .bouncing,
                                                                velocity: const Velocity(
                                                                    pixelsPerSecond:
                                                                        Offset(
                                                                            25,
                                                                            0)),
                                                                delayBefore:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            3000),
                                                                pauseBetween:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            5000),
                                                                selectable:
                                                                    false,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                entry.value
                                                                    .artists
                                                                    .join(', '),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                )
                            ]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
