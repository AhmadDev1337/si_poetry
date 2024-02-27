// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, avoid_print, depend_on_referenced_packages, prefer_final_fields, avoid_unnecessary_containers, unused_element, deprecated_member_use, sized_box_for_whitespace

// ignore_for_file:
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PoetryItem {
  final String episode;
  final String page;
  final DetailPage detailPage;

  PoetryItem({
    required this.episode,
    required this.page,
    required this.detailPage,
  });

  factory PoetryItem.fromJson(Map<String, dynamic> json) {
    return PoetryItem(
      episode: json['episode'],
      page: json['page'],
      detailPage: DetailPage.fromJson(json['detailPage']),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PoetryItem> poetries = [];
  Timer? _timer;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8363980854824352/1084911954',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.show();
          log('Ad onAdLoaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-8363980854824352/1255112972',
      request: AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('Ad onAdLoaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError err) {
          log('Ad onAdFailedToLoad: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    fetchPoetry();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  Future<void> fetchPoetry() async {
    final response =
        await http.get(Uri.parse('https://pastebin.com/raw/0tCkGWFW'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final poetriesJson = jsonData['poetries'] as List<dynamic>;

      setState(() {
        poetries = poetriesJson
            .map((poetryJson) => PoetryItem.fromJson(poetryJson))
            .toList();
      });
    } else {
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: SpinKitWave(
              color: Colors.cyan,
              size: 25,
            ),
          ),
        ),
      );
    }
  }

  bool _isMorningOrAfternoon() {
    final currentHour = DateTime.now().hour;
    return (currentHour >= 6 && currentHour < 18) ||
        (currentHour >= 18 && currentHour < 6);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getDayOfTheWeek() {
    final daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final now = DateTime.now();
    final dayIndex = now.weekday;
    return daysOfWeek[dayIndex];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Si Poetry",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFE0C9A6),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/background utama.png",
              fit: BoxFit.fill,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff836953),
                              ),
                              child: Center(
                                child: Icon(
                                  IconlyLight.heart,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              () {
                                int currentHour = DateTime.now().hour;
                                if (currentHour >= 6 && currentHour < 12) {
                                  return 'Good Morning !';
                                } else if (currentHour >= 12 &&
                                    currentHour < 18) {
                                  return 'Good Afternoon !';
                                } else if (currentHour >= 18 &&
                                    currentHour < 24) {
                                  return 'Good Evening !';
                                } else {
                                  return 'Good Night !';
                                }
                              }(),
                              style: GoogleFonts.tiroDevanagariMarathi(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: () {
                                  int currentHour = DateTime.now().hour;
                                  if ((currentHour >= 6 && currentHour < 15) ||
                                      (currentHour >= 15 && currentHour < 18)) {
                                    return Color(0xff836953);
                                  } else {
                                    return Color(0xff836953);
                                  }
                                }(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Anonymous",
                          style: GoogleFonts.uncialAntiqua(
                              color: Colors.brown.shade900),
                        ),
                        SizedBox(height: 55),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/gender-mark-2-svgrepo-com.svg",
                              width: 20,
                              color: Color(0xff836953),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Male",
                              style: GoogleFonts.carattere(
                                color: Color(0xff836953),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/taurus-svgrepo-com (1).svg",
                              width: 15,
                              color: Color(0xff836953),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Scorpio",
                              style: GoogleFonts.carattere(
                                color: Color(0xff836953),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              '${DateTime.now().hour}:${DateTime.now().minute}',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                color: () {
                                  int currentHour = DateTime.now().hour;
                                  if ((currentHour >= 6 && currentHour < 18) ||
                                      (currentHour >= 18 && currentHour < 6)) {
                                    return Colors.brown;
                                  } else {
                                    return Colors.brown;
                                  }
                                }(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: poetries.length,
                            itemBuilder: (context, index) {
                              final poetry = poetries[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      poetry.episode,
                                                      style:
                                                          GoogleFonts.carattere(
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xFF0D0D0D),
                                                      ),
                                                    ),
                                                    Icon(
                                                      IconlyLight.arrow_right_2,
                                                      color: Color(0xFF0D0D0D),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Divider(
                                                  color: Color(0xFF0D0D0D),
                                                  indent: 5,
                                                  endIndent: 5,
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      _loadInterstitialAd();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatPage(poetry: poetry),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 9.9,
                    height: 50,
                    child: AdWidget(ad: _bannerAd!),
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF836953),
                    ),
                    child: Icon(Icons.date_range_rounded, color: Colors.white),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        '${_getDayOfTheWeek()}',
                        style: GoogleFonts.tiroDevanagariMarathi(
                          fontSize: 15,
                          color: Color(0xff836953),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF836953),
                    ),
                    child: Icon(Icons.music_note_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage {
  final String pageTitle;
  final List<Message> messages;

  DetailPage({required this.pageTitle, required this.messages});

  factory DetailPage.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>;
    final messages = messagesJson
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();

    return DetailPage(
      pageTitle: json['pageTitle'],
      messages: messages,
    );
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
    );
  }
}

class ChatPage extends StatefulWidget {
  final PoetryItem poetry;

  ChatPage({required this.poetry});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> chatMessages = [];
  BannerAd? _bannerAd;

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-8363980854824352/4564991965',
      request: AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('Ad onAdLoaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError err) {
          log('Ad onAdFailedToLoad: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _loadBannerAd();
  }

  Future<void> fetchMessages() async {
    final messages = widget.poetry.detailPage.messages;

    setState(() {
      chatMessages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Si Poetry",
      home: Scaffold(
        backgroundColor: Color(0xffE0C9A6),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/background detail.png",
              fit: BoxFit.fill,
            ),
            Container(
              constraints: const BoxConstraints.expand(
                height: double.infinity,
                width: double.infinity,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final message = chatMessages[index];

                        if (message.sender.startsWith('receiver')) {
                          return getReceiverView(message.sender, message.text);
                        } else {
                          return getSenderView(message.sender, message.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 9.9,
                height: 50,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 190,
              left: 190,
              child: Text(
                widget.poetry.page,
                style: GoogleFonts.libreBaskerville(
                  color: Color(0xFF836953),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReceiverView(String sender, String text) => ChatBubble(
        clipper: ChatBubbleClipper9(type: BubbleType.receiverBubble),
        backGroundColor: Color(0xFFeae4e0),
        margin: EdgeInsets.only(top: 20, left: 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            text,
            strutStyle: StrutStyle(
              height: 1.5,
            ),
            style: GoogleFonts.libreBaskerville(
              color: Color(0xFF404040),
            ),
          ),
        ),
      );

  Widget getSenderView(String sender, String text) => ChatBubble(
        clipper: ChatBubbleClipper9(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20, right: 10),
        backGroundColor: Color(0xFFc1b1a5),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            text,
            strutStyle: StrutStyle(
              height: 1.5,
            ),
            style: GoogleFonts.libreBaskerville(
              color: Color(0xFF404040),
            ),
          ),
        ),
      );
}
