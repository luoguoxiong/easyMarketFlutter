import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

// Color borderColor = Color.fromARGB(255, 0, 191, 255);
Color borderColor = Colors.grey;

class Count extends StatelessWidget {
  Count({
    this.number,
    this.min,
    this.max,
    this.onChange,
  });

  final ValueChanged<int> onChange;
  final int number;
  final int min;
  final int max;

  final int a = 1;

  onClickBtn(String type) {
    if (type == 'remove' && number > min) {
      onChange(number - 1);
    } else if (type == 'add' && number < max) {
      onChange(number + 1);
    }
  }

// 相当于render
  Widget build(BuildContext context) {
    return Container(
      height: Rem.getPxToRem(70),
      width: Rem.getPxToRem(260),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: Rem.getPxToRem(70),
            color: this.min >= this.number ? Colors.grey[200] : Colors.white,
            child: InkResponse(
              child: Center(
                child: Icon(
                  Icons.remove,
                  color:
                      this.min >= this.number ? Colors.grey[500] : Colors.black,
                ),
              ),
              onTap: () {
                this.onClickBtn('remove');
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: borderColor),
                  right: BorderSide(color: borderColor),
                ),
              ),
              child: Center(
                child: Text(
                  '${this.number}',
                  style: TextStyle(fontSize: Rem.getPxToRem(32)),
                ),
              ),
            ),
          ),
          Container(
            width: Rem.getPxToRem(70),
            color: this.max <= this.number ? Colors.grey[200] : Colors.white,
            child: InkResponse(
              child: Center(
                child: Icon(
                  Icons.add,
                  color:
                      this.max <= this.number ? Colors.grey[500] : Colors.black,
                ),
              ),
              onTap: () {
                this.onClickBtn('add');
              },
            ),
          ),
        ],
      ),
    );
  }
}
