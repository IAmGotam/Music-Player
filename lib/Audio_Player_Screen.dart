import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volume/volume.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

AudioCache audioCache;
AudioPlayer audioPlayer;

Duration endTimeDuration = new Duration();
Duration currentTimeDuration = new Duration();

List<String> songNames = [
  'Mirage',
  'WishList',
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

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  ValueNotifier<int> currentMusicIndex = ValueNotifier<int>(0);
  ValueNotifier<String> onChangeStartTime = ValueNotifier<String>("00:00:00");
  ValueNotifier<String> onChangeEndTime = ValueNotifier<String>("00:00:00");
  ValueNotifier<bool> onAudioPlay = ValueNotifier<bool>(false);

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  AudioManager audioManager;
  int maxVol, currentVol;

  void updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    print("maxVol: $maxVol, currentVol: $currentVol");
    setState(() {});
  }

  void setVol(int i) async {
    await Volume.setVol(i);
  }

  Future<void> initPlatformState(AudioManager am) async {
    await Volume.controlVolume(am);
  }

  void initState() {
    super.initState();

    audioManager = AudioManager.STREAM_MUSIC;
    initPlatformState(AudioManager.STREAM_MUSIC);
    updateVolumes();

    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onDurationChanged.listen((duration) {
      endTimeDuration = duration;
      onChangeEndTime.value = duration.toString().split(".")[0];
      setState(() {});
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) {
      currentTimeDuration = position;
      onChangeStartTime.value = position.toString().split(".")[0];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainLayout(),
    );
  }

  Widget mainLayout() {
    return ValueListenableBuilder(
      valueListenable: currentMusicIndex,
      builder: (BuildContext context, int value, Widget child) {
        return Stack(
          children: <Widget>[
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.075,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  Text(
                    'Artist',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                  ),
                  Icon(
                    Icons.error_outline,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: songImg(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: slider(),
                        ),
                        SizedBox(
                          child: showTime(),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Column(
                            children: <Widget>[
                              songName(),
                              singerName(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: playButton(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: voiceSlider(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: songList(value),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget songImg() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: Image.asset(
          images[currentMusicIndex.value],
          fit: BoxFit.fill,
          height: 150,
          width: 150,
        ),
      ),
    );
  }

  Widget songName() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        songNames[currentMusicIndex.value],
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget singerName() {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Text(
        songSingerName[currentMusicIndex.value],
        style: TextStyle(fontSize: 15, color: Colors.lightBlue),
      ),
    );
  }

  Widget slider() {
    return Slider(
      activeColor: Colors.lightBlue,
      inactiveColor: Colors.grey,
      value: currentTimeDuration.inSeconds.toDouble(),
      max: endTimeDuration.inSeconds.toDouble() + 2,
      onChanged: (double value) {
        setState(
          () {
            seekToSecond(value.toInt());
            value = value;
          },
        );
      },
    );
  }

  Widget showTime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: onChangeStartTime,
            builder: (BuildContext context, String value, Widget child) {
              return Text(value);
            },
          ),
          ValueListenableBuilder(
            valueListenable: onChangeEndTime,
            builder: (BuildContext context, String value, Widget child) {
              return Text(value);
            },
          ),
        ],
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
                if (currentMusicIndex.value > 0) {
                  if (!onAudioPlay.value) {
                    currentMusicIndex.value = currentMusicIndex.value - 1;
                    audioCache.play(songs[currentMusicIndex.value]);
                    onAudioPlay.value = !onAudioPlay.value;
                  } else {
                    currentMusicIndex.value = currentMusicIndex.value - 1;
                    audioCache.play(songs[currentMusicIndex.value]);
                  }
                }
              },
              child: FaIcon(
                FontAwesomeIcons.backward,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (onAudioPlay.value) {
                audioPlayer.pause();
              } else {
                audioCache.play(songs[currentMusicIndex.value]);
              }
              onAudioPlay.value = !onAudioPlay.value;
            },
            child: ValueListenableBuilder(
              valueListenable: onAudioPlay,
              builder: (BuildContext context, bool value, Widget child) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500], width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      value ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: InkWell(
              onTap: () {
                if (currentMusicIndex.value < 3) {
                  if (!onAudioPlay.value) {
                    currentMusicIndex.value = currentMusicIndex.value + 1;
                    onAudioPlay.value = !onAudioPlay.value;
                  } else {
                    currentMusicIndex.value = currentMusicIndex.value + 1;
                  }
                }
                audioCache.play(songs[currentMusicIndex.value]);
              },
              child: FaIcon(
                FontAwesomeIcons.forward,
                color: Colors.black,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget voiceSlider() {
    return (currentVol != null || maxVol != null)
        ? Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.volumeMute,
                  color: Colors.grey[500],
                ),
                Expanded(
                  child: Slider(
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                    value: currentVol / 1,
                    max: maxVol / 1,
                    min: 0,
                    onChanged: (double d) {
                      setVol(d.toInt());
                      updateVolumes();
                    },
                  ),
                  flex: 2,
                ),
                FaIcon(
                  FontAwesomeIcons.volumeUp,
                  color: Colors.grey[500],
                ),
              ],
            ),
          )
        : Container();
  }

  Widget songList(int value) {
    return IconButton(
      icon: Icon(
        Icons.keyboard_arrow_up,
        size: 40,
      ),
      onPressed: () {
        songListSheet(context, value);
      },
    );
  }

  songListSheet(BuildContext context, int i) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(true);
              },
              child: Material(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50)),
                              child: Image.asset(
                                'assets/images/background.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Popular',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Show All',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.lightBlue,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: List.generate(
                                    songs.length,
                                    (val) {
                                      return Column(
                                        children: <Widget>[
                                          ListTile(
                                              onTap: () {
                                                setState(
                                                  () {
                                                    currentMusicIndex.value =
                                                        val;
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                );
                                                if (!onAudioPlay.value) {
                                                  audioCache.play(songs[
                                                      currentMusicIndex.value]);
                                                  onAudioPlay.value =
                                                      !onAudioPlay.value;
                                                } else {
                                                  audioCache.play(songs[
                                                      currentMusicIndex.value]);
                                                }
                                              },
//                                                leading: Container(
//                                                  width: 50,
//                                                  height: 50.0,
//                                                  decoration: new BoxDecoration(
//                                                    borderRadius:
//                                                        BorderRadius.all(
//                                                            Radius.circular(
//                                                                10.0)),
//                                                    image: new DecorationImage(
//                                                      fit: BoxFit.fill,
//                                                      image: AssetImage(
//                                                          images[val]),
//                                                    ),
//                                                  ),
//                                                ),
                                              title: Text(
                                                songNames[val],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
//                                                subtitle: RichText(
//                                                  text: TextSpan(
//                                                    text: songSingerName[val],
//                                                    style: TextStyle(
//                                                        fontSize: 16,
//                                                        color:
//                                                            Colors.grey[500]),
//                                                    children: <TextSpan>[],
//                                                  ),
//                                                ),
                                              trailing: Text(
                                                '...',
                                                style: TextStyle(fontSize: 30),
                                              )),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
