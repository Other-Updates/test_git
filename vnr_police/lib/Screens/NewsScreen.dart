import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Screens/artical_news.dart';
import 'package:vnr_police/Screens/photo_capture.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:vnr_police/Utils/constants.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  GlobalKey bottomNavigationKey = GlobalKey();
  dynamic cName;
  dynamic country;
  dynamic catagory;
  dynamic findNews;
  int pageNum = 1;
  bool isPageLoading = false;
  late ScrollController controller;
  int pageSize = 10;
  bool isSwitched = false;
  List news = [];
  bool notFound = false;
  List<int> data = [];
  bool isLoading = false;
  String baseApi = "https://newsapi.org/v2/top-headlines?";

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  toggleDrawer() async {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  getNews({channel, searchKey, reload = false}) async {
    setState(() => notFound = false);

    if (!reload && !isLoading) {
      toggleDrawer();
    } else {
      country = null;
      catagory = null;
    }
    if (isLoading) {
      pageNum++;
    } else {
      setState(() => news = []);
      pageNum = 1;
    }
    baseApi = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";

    baseApi += country == null ? 'country=in&' : 'country=$country&';
    baseApi += catagory == null ? '' : 'category=$catagory&';
    baseApi += 'apiKey=$apiKey';
    if (channel != null) {
      country = null;
      catagory = null;
      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6";
    }
    if (searchKey != null) {
      country = null;
      catagory = null;
      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6";
    }
    //print(baseApi);
    getDataFromApi(baseApi);
  }

  getDataFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      if (jsonDecode(res.body)['totalResults'] == 0) {
        notFound = isLoading ? false : true;
        setState(() => isLoading = false);
      } else {
        if (isLoading) {
          List newData = jsonDecode(res.body)['articles'];
          for (var e in newData) {
            news.add(e);
          }
        } else {
          news = jsonDecode(res.body)['articles'];
        }
        setState(() {
          notFound = false;
          isLoading = false;
        });
      }
    } else {
      setState(() => notFound = true);
    }
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    getNews();
    super.initState();
  }

  _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() => isLoading = true);
      getNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, Routes.DASHBOARD_SCREEN);
              }),
          centerTitle: true,
          backgroundColor: Palette.SecondaryColor,
          title: const Text(
            "News",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                country = null;
                catagory = null;
                findNews = null;
                cName = null;
                getNews(reload: true);
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
            // Switch(
            //   value: isSwitched,
            //   onChanged: (value) => setState(() => isSwitched = value),
            //   activeTrackColor: Colors.white,
            //   activeColor: Colors.white,
            // ),
          ],
        ),
        body: notFound
            ? const Center(
                child: Text("Not Found", style: TextStyle(fontSize: 30)))
            : news.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    backgroundColor: Palette.SecondaryColor,
                  ))
                : ListView.builder(
                    controller: controller,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => ArticalNews(
                                            newsUrl: news[index]['url'])),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      Stack(children: [
                                        news[index]['urlToImage'] == null
                                            ? Container()
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const SizedBox(),
                                                  imageUrl: news[index]
                                                      ['urlToImage'],
                                                ),
                                              ),
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Card(
                                              elevation: 0,
                                              color: new Color(0xff0096FF)
                                                  .withOpacity(0.8),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                child: Text(
                                                    "${news[index]['source']['name']}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2),
                                              )),
                                        ),
                                      ]),
                                      const Divider(),
                                      Text(
                                        "${news[index]['title']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          index == news.length - 1 && isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  backgroundColor: Palette.PrimaryColor,
                                ))
                              : const SizedBox(),
                        ],
                      );
                    },
                    itemCount: news.length,
                  ),

      bottomNavigationBar: FancyBottomNavigation(
        //activeIconColor:Color(0xffb72334) ,
        inactiveIconColor: Color(0xffb72334),
        barBackgroundColor: Colors.white70,
        circleColor: Color(0xffb72334),
        tabs: [
          TabData(
              iconData: Icons.lock_outline,
              title: 'Locked home',
              onclick: () {
                final State<StatefulWidget>? fState =
                    bottomNavigationKey.currentState;
                // fState.setPage(2);
           //     Navigator.pushNamed(context, PhotoCapture.route);
              }),
          TabData(
            iconData: Icons.local_police_outlined,
            title: 'Police station',
            //  onclick: () => Navigator.pushNamed(context, SpeechScreen.route),
          ),
          TabData(
            iconData: Icons.new_releases_outlined,
            title: 'News',
            // onclick: () => Navigator.pushNamed(context, NearbyPlaces.route),
          ),
          TabData(
            iconData: Icons.dashboard,
            title: 'Dashboard',
            // onclick: () => Navigator.pushNamed(context, NearbyPlaces.route),
          ),
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            // currentPage = position;
          });
        },
      ),

    );
  }
}
