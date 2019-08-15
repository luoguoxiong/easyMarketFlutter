import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart'; // 引入头文件

class SwiperView extends StatefulWidget {
  final List bannerImg;
  SwiperView(this.bannerImg);
  @override
  _SwiperViewState createState() => _SwiperViewState();
}

class _SwiperViewState extends State<SwiperView> {
  List<Widget> imageList;

  @override
  void initState() {
    super.initState();
    setState(() {
      imageList = widget.bannerImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[firstSwiperView()]);
  }

  Widget firstSwiperView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
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
        autoplayDelay: 4000,
        onTap: (index) => print('点击了第$index'),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (imageList[index]);
  }
}
