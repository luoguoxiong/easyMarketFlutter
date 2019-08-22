import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_market/component/swiper.dart';
import 'package:easy_market/api/index.dart';
import 'package:easy_market/utils/rem.dart';
import './topic.dart';

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
      var sliversList = [
        buildSwiper(),
        buildChannel(),
        buildTitle('品牌制造商直供', false),
        buildBrand(),
        buildTitle('新品首发'),
        buildNews(),
        buildTitle('人气推荐', false),
        buildHot(),
        buildTopic(),
      ];
      for (var i = 0; i < category.length; i++) {
        sliversList.add(buildTitle(category[i]['name']));
        sliversList
            .add(buildCategory(category[i]['goodsList'], category[i]['name']));
      }
      return new SafeArea(
        child: CustomScrollView(
          slivers: sliversList,
        ),
      );
    }
  }

// 轮播图
  SliverList buildSwiper() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return SwiperView(banner);
      }, childCount: 1),
    );
  }

// 渠道
  SliverGrid buildChannel() {
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.3,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: new Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                      bottom: Rem.getPxToRem(4),
                      left: Rem.getPxToRem(25),
                      top: Rem.getPxToRem(25),
                      right: Rem.getPxToRem(25)),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: channel[index]['icon_url'],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: new Container(
                  color: Colors.white,
                  child: Center(
                    child: new Text(
                      channel[index]['name'],
                      style: TextStyle(
                        fontSize: Rem.getPxToRem(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        childCount: 5,
      ),
    );
  }

// 製造商
  SliverGrid buildBrand() {
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text(
                    brand[index]['name'],
                    style: TextStyle(fontSize: Rem.getPxToRem(30)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    '${brand[index]['floor_price']}元起',
                    style: TextStyle(
                        fontSize: Rem.getPxToRem(24), color: Colors.grey),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(
                top: Rem.getPxToRem(10), left: Rem.getPxToRem(20)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(brand[index]['new_pic_url']))),
          );
        },
        childCount: brand.length,
      ),
    );
  }

//  新品
  SliverGrid buildNews() {
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: .9,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Rem.getPxToRem(20)),
                  child: CachedNetworkImage(
                    imageUrl: news[index]['list_pic_url'],
                    height: Rem.getPxToRem(250),
                    width: double.infinity,
                  ),
                ),
                flex: 300,
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      '${news[index]['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Rem.getPxToRem(30)),
                    ),
                  ),
                ),
                flex: 40,
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      '￥${news[index]['retail_price']}',
                      style: TextStyle(
                          color: Colors.red, fontSize: Rem.getPxToRem(28)),
                    ),
                  ),
                ),
                flex: 40,
              ),
            ],
          ),
        );
      }, childCount: news.length),
    );
  }

// 人气推荐
  SliverList buildHot() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: Colors.grey[300], width: .5))),
          padding: EdgeInsets.fromLTRB(Rem.getPxToRem(30), Rem.getPxToRem(10),
              Rem.getPxToRem(30), Rem.getPxToRem(10)),
          child: Container(
            height: Rem.getPxToRem(220),
            child: Row(
              children: <Widget>[
                Container(
                  child: CachedNetworkImage(
                    imageUrl: hot[index]['list_pic_url'],
                    fit: BoxFit.cover,
                  ),
                  height: Rem.getPxToRem(220),
                  width: Rem.getPxToRem(220),
                ),
                Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: Rem.getPxToRem(20)),
                      margin: EdgeInsets.only(left: Rem.getPxToRem(10)),
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: Rem.getPxToRem(60),
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  hot[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Rem.getPxToRem(28)),
                                ),
                              )),
                          Container(
                            height: Rem.getPxToRem(60),
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                hot[index]['goods_brief'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: Rem.getPxToRem(24),
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
                            height: Rem.getPxToRem(60),
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '￥${hot[index]['retail_price']}',
                                style: TextStyle(
                                    fontSize: Rem.getPxToRem(30),
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        );
        ;
      }, childCount: hot.length),
    );
  }

// 专题精选
  SliverList buildTopic() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Topic(topic);
      }, childCount: 1),
    );
  }

// 某类型的商品
  SliverGrid buildCategory(goods, typeName) {
    return SliverGrid(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: .9,
        ),
        delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (goods.length == index) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Container(
                    height: Rem.getPxToRem(140),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: Rem.getPxToRem(80),
                          child: Center(
                            child: Text(
                              '更多$typeName好物',
                              style: TextStyle(fontSize: Rem.getPxToRem(26)),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/more.png',
                          height: Rem.getPxToRem(60),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CachedNetworkImage(
                        imageUrl: goods[index]['list_pic_url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    flex: 350,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          goods[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    flex: 50,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text(
                          '￥${goods[index]['retail_price']}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    flex: 60,
                  ),
                ],
              ),
            );
          },
          childCount: goods.length + 1,
        ));
  }

// 标题
  SliverList buildTitle(String title, [bool isBorder = true]) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          height: Rem.getPxToRem(100),
          decoration: BoxDecoration(
              color: Colors.white,
              border: isBorder
                  ? Border(
                      bottom: BorderSide(color: Colors.grey[200], width: .5))
                  : null),
          margin: EdgeInsets.only(top: Rem.getPxToRem(20)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  wordSpacing: 2,
                  fontSize: Rem.getPxToRem(30)),
            ),
          ),
        );
      }, childCount: 1),
    );
  }
}
