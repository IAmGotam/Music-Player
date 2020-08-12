import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
String currentTime = "00:00";
String completeTime = "00:00";

List<String> songNames = [
  'Mirage',
  'Wishlist',
  'Khulke Jeene ka',
  'FriendZone'
];
List<String> songSingerName = [
  'Deno James',
  'Deno James',
  'Darshan Raval',
  'A R Rahman'
];
List<String> images = [
  "assets/images/image1.jpg",
  "assets/images/image2.jpg",
  "assets/images/image3.jpg",
  "assets/images/image4.jpg"
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

    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: mainLayout(),
    );
  }

  Widget mainLayout() {
    return Column(
      children: <Widget>[
        Expanded(
          child: titleText(),
          flex: 2,
        ),
        Expanded(
          child: songImg(),
          flex: 9,
        ),
        Expanded(
          child: songName(),
        ),
        Expanded(
          child: singerName(),
        ),
        Expanded(
          child: slider(),
        ),
        showTime(),
      ],
    );
  }

  Widget bottomBar() {
    return Container(
      height: 165,
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          playButton(),
          IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up,
                size: 30,
              ),
              onPressed: () {
                songListSheet(context, i);
              })
        ],
      ),
    );
  }

  Widget titleText() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text(
        'Music Player',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget songImg() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [
            new BoxShadow(
              color: Colors.black,
              blurRadius: 20.0,
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height / 2.5,
        width: 250,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(images[i], fit: BoxFit.fill)),
      ),
    );
  }

  Widget songName() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        songNames[i],
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget singerName() {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Text(
        songSingerName[i],
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget slider() {
    return Slider(
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
    );
  }

  Widget showTime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(currentTime), Text(completeTime)],
      ),
    );
  }

  Widget playButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 40),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (i > 0) {
                    i = i - 1;
                    print(i);
                    if (issongplaying == false &&
                        _animationIconController1.forward() == true) {
                      _animationIconController1.reverse();
                    } else {
                      _animationIconController1.forward();
                    }
                  }
                });

                audioCache.play(songs[i]);
              },
              child: Icon(
                Icons.skip_previous,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  if (!issongplaying) {
                    audioCache.play(songs[i]);
                    _animationIconController1.forward();
                  } else {
                    audioPlayer.pause();
                    _animationIconController1.reverse();
                  }
                  issongplaying = !issongplaying;
                },
              );
            },
            child: ClipOval(
              child: Container(
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    size: 60,
                    progress: _animationIconController1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (i < 3) {
                    i = i + 1;
                    print(i);
                    if (issongplaying == false &&
                        _animationIconController1.forward() == true) {
                      _animationIconController1.reverse();
                    } else {
                      _animationIconController1.forward();
                    }
                  }
                });
                audioCache.play(songs[i]);
              },
              child: Icon(
                Icons.skip_next,
                color: Colors.black,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget songList() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_up,
            size: 40,
          ),
          onPressed: () {
            songListSheet(context, i);
          }),
    );
  }

  void songListSheet(BuildContext context, int i) {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Container(
                  height: 5.0,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Column(
              children: List.generate(
                songs.length,
                (i) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                            width: 50,
                            height: 50.0,
                            decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(images[i])))),
                        title: Text(
                          songNames[i],
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            text: songSingerName[i],
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[500]),
                            children: <TextSpan>[
//                          TextSpan(text: songTime[i], style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        trailing: FaIcon(
                          FontAwesomeIcons.heart,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.grey[300],
                      )
                    ],
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
