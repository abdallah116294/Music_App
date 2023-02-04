import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  double value = 0;
  //create instance of The Music player
  final player = AudioPlayer();
  //setting the duration
  Duration? duration = const Duration(seconds: 0);
  //create the function to initiate the music into the player
  void initPlayer() async {
    await player.setSource(AssetSource('music.mp3'));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.transparent,
      //   title: const Text('Music Streeming Appp'),
      //   centerTitle: true,
      // ),
      body: Stack(children: [
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/cover.jpg'))),
          child: //add blur
              BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(color: Colors.black54),
          ),
        ),
        //layout of the app
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                'assets/cover.jpg',
                width: 250.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'summer Vibes ',
              style: TextStyle(
                  color: Colors.white, fontSize: 28, letterSpacing: 4),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(value / 60).floor()}:${(value % 60).floor()}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 195, 167, 167),
                  ),
                ),
                Slider.adaptive(
                  value: value,
                  min: 0.0,
                  max: duration!.inSeconds.toDouble(),
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                  onChangeEnd: (newValue) async {
                    setState(() {
                      value = newValue;
                      print(newValue);
                    });
                    player.pause();
                    await player.seek(Duration(seconds: newValue.toInt()));
                    await player.resume();
                  },
                  activeColor: Colors.white,
                ),
                Text(
                  '${duration!.inMinutes}:${duration!.inSeconds % 60}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            //this without two button to get the previous and next button 
            // Container(
            //   width: 60,
            //   height: 60,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(60.0),
            //       color: Colors.black87,
            //       border: Border.all(color: Colors.pink)),
            //   child: InkWell(
            //     onTap: () async {
            //       if (isPlaying) {
            //         await player.pause();
            //         // setState(() {
            //         //   isPlaying = false;
            //         // });
            //         isPlaying = true;
            //       } else {
            //         await player.resume();
            //         // setState(() {
            //         //   isPlaying = true;
            //         // });
            //         player.onPositionChanged.listen((poistion) {
            //           setState(() {
            //             value = poistion.inSeconds.toDouble();
            //           });
            //         });
            //         isPlaying = false;
            //       }
            //       // setState(() async {
            //       //   duration = await player.getDuration();
            //       // });
            //     },
            //     child: Icon(
            //       isPlaying ? Icons.pause : Icons.play_arrow,
            //       color: Colors.white,
            //     ),
            //   ),
            // )
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        player.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        player.setPlaybackRate(1);
                      },
                      child: Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.pink),
                    ),
                    width: 60.0,
                    height: 60.0,
                    child: InkWell(
                      onTap: () async {
                        //setting the play function
                        await player.resume();
                        player.onPositionChanged.listen(
                          (Duration d) {
                            setState(() {
                              value = d.inSeconds.toDouble();

                              print(value);
                            });
                          },
                        );
                        print(duration);
                      },
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        player.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        player.setPlaybackRate(1);
                      },
                      child: Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        )
      ]),
    );
  }
}
