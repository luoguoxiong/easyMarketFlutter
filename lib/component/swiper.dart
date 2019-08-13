import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart'; // 引入头文件

class SwiperView extends StatefulWidget {
  @override
  _SwiperViewState createState() => _SwiperViewState();
}

class _SwiperViewState extends State<SwiperView> {
  // 声明一个list，存放image Widget
  List<Widget> imageList = List();

  @override
  void initState() {
    imageList
      ..add(Image.network(
        'http://yanxuan.nosdn.127.net/65091eebc48899298171c2eb6696fe27.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'http://yanxuan.nosdn.127.net/bff2e49136fcef1fd829f5036e07f116.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'http://yanxuan.nosdn.127.net/8e50c65fda145e6dd1bf4fb7ee0fcecc.jpg',
        fit: BoxFit.fill,
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[firstSwiperView()]);
  }

  Widget firstSwiperView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        child: Swiper(
          itemCount: imageList.length,
          itemBuilder: _swiperBuilder,
          pagination: SwiperPagination(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              builder: DotSwiperPaginationBuilder(
                  color: Colors.grey[200],
                  size: 8,
                  activeColor: Colors.red[400])),
          controller: SwiperController(),
          scrollDirection: Axis.horizontal,
          autoplay: true,
          autoplayDelay: 3000,
          onTap: (index) => print('点击了第$index'),
        ),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (imageList[index]);
  }
}
