import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:easy_market/component/swiper.dart';
import 'package:easy_market/utils/http.dart';
import './channel.dart';
import './brand.dart';
import './news.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  bool isLoading = true;

  List banner, channel, brand, news = [];

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
    setState(() {
      banner = bannerList;
      channel = channelData;
      brand = brandData;
      news = newsData;
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
            ],
          ),
        ),
      );
    }
  }
}
