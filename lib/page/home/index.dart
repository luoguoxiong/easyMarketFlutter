import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_market/component/swiper.dart';
import 'package:easy_market/api/index.dart';
import './channel.dart';
import './brand.dart';
import './news.dart';
import './hot.dart';
import './topic.dart';
import './goods.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  bool isLoading = true;

  List banner, channel, brand, news, hot, topic, category = [];

  @override
  void initState() {
    super.initState();
    _getDio();
  }

  _getDio() async {
    Response data = await Api.getHomeData();
    // 轮播图数据
    var bannerData = data.data['banner'];
    List<Widget> bannerList = List();
    bannerData.forEach((item) => bannerList.add(CachedNetworkImage(
          imageUrl: item['image_url'],
          errorWidget: (context, url, error) => new Icon(Icons.error),
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
    // 推荐商品
    var categoryList = data.data['categoryList'];
    setState(() {
      banner = bannerList;
      channel = channelData;
      brand = brandData;
      news = newsData;
      hot = hotData;
      topic = topicList;
      category = categoryList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    } else {
      return new SafeArea(
        child: new ListView(
          children: <Widget>[
            // todo卡顿问题
            Column(
              children: <Widget>[
                SwiperView(banner),
                Channel(channel),
                Brand(brand),
                News(news),
                Hot(hot),
                Topic(topic),
                Goods(category),
              ],
            )
          ],
        ),
      );
    }
  }
}
