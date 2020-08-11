import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Audio_Player extends StatefulWidget {
  @override
  _Audio_PlayerState createState() => _Audio_PlayerState();
}

AnimationController _animationIconController1;
AudioCache audioCache;
AudioPlayer audioPlayer;
Duration _duration = new Duration();
Duration _position = new Duration();
Duration _slider = new Duration(seconds: 0);
double durationvalue;
bool issongplaying = false;
List<String> songName = ['Mirage', 'Wishlist', 'Khulke Jeene ka', 'FriendZone'];
List<String> images = [
  "images/image1.jpg",
  "images/image2.jpg",
  "images/image3.jpg",
  "images/image4.jpg"
];
List<String> songs = [
  "music/music1.mp3",
  "music/music2.mp3",
  "music/music3.mp3",
  "music/music4.mp3"
];
int i = 0;

class _Audio_PlayerState extends State<Audio_Player>
    with TickerProviderStateMixin {
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }

  void initState() {
    super.initState();
    i = 0;
    _position = _slider;
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ClipOval(
                    //   child: Image(
                    //     image: AssetImage(images[i]),
                    //     width: (MediaQuery.of(context).size.width) - 200,
                    //     height: (MediaQuery.of(context).size.width) - 200,
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                    Slider(
                      activeColor: Colors.pink,
                      inactiveColor: Colors.grey,
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble() + 2,
                      onChanged: (double value) {
                        setState(() {
                          seekToSecond(value.toInt());
                          value = value;
                        });
                      },
                    ),
                    Text(songName[i], style: TextStyle(color: Colors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.navigate_before,
                            size: 55,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            setState(() {
                              if (i > 0) {
                                i = i - 1;
                                print(i);
                                issongplaying
                                    ? _animationIconController1.reverse()
                                    : _animationIconController1.forward();
                                issongplaying = !issongplaying;
                              }
                              audioCache.play(songs[i]);
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (!issongplaying) {
                                  audioCache.play(songs[i]);
                                } else {
                                  audioPlayer.pause();
                                }
                                issongplaying
                                    ? _animationIconController1.reverse()
                                    : _animationIconController1.forward();
                                issongplaying = !issongplaying;
                              },
                            );
                          },
                          child: ClipOval(
                            child: Container(
                              color: Colors.pink[600],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  size: 55,
                                  progress: _animationIconController1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            size: 55,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            setState(() {
                              if (i < i.bitLength) print(i.bitLength);
                              i = i + 1;
                              print(i);

                              // issongplaying = !issongplaying;
                            });
                            issongplaying
                                ? _animationIconController1.reverse()
                                : _animationIconController1.forward();
                            audioCache.play(songs[i]);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
