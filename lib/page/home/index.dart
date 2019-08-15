import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:easy_market/component/swiper.dart';
import 'package:easy_market/utils/http.dart';
import './channel.dart';
import './brand.dart';
import './news.dart';
import './hot.dart';
import './topic.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  bool isLoading = true;

  List banner, channel, brand, news, hot, topic = [];

  @override
  void initState() {
    super.initState();
    _getDio();
  }

  _getDio() async {
    var httpUtils = HttpUtils();
    var parmas = {};
    Response data = await httpUtils.get('/api', parmas);
    // 轮播图数据
    var bannerData = data.data['banner'];
    List<Widget> bannerList = List();
    bannerData.forEach((item) => bannerList.add(Image.network(
          item['image_url'],
          fit: BoxFit.fill,
        )));
    // channel数据
    var channelData = data.data['channel'];
    // 制造商数据
    var brandData = data.data['brandList'];
    // 新品推荐
    var newsData = data.data['newGoodsList'];
    // 人气推荐
    var hotData = data.data['hotGoodsList'];
    // 专题精选
    var topicList = data.data['topicList'];
    setState(() {
      banner = bannerList;
      channel = channelData;
      brand = brandData;
      news = newsData;
      hot = hotData;
      topic = topicList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: new Text('loading...'),
      );
    } else {
      return new SafeArea(
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SwiperView(banner),
              Channel(channel),
              Brand(brand),
              News(news),
              Hot(hot),
              Topic(topic),
            ],
          ),
        ),
      );
    }
  }
}
