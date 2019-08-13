import 'package:flutter/material.dart';
import '../component/swiper.dart';
// import '../utils/http.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new SingleChildScrollView(
        child: Container(
          height: 1000,
          child: new Column(
            children: <Widget>[
              new SwiperView(),
            ],
          ),
        ),
      ),
    );

    // return FutureBuilder(
    //     future: HttpUtils().get('/api'),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       print(snapshot);
    //       return new Text('1');
    //     });
  }
}
