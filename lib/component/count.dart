import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

Color borderColor = Color.fromARGB(255, 0, 191, 255);

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

  onClickBtn(String type) {
    if (type == 'remove' && number > min) {
      onChange(number - 1);
    } else if (type == 'add' && number < max) {
      onChange(number + 1);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: Rem.getPxToRem(80),
      width: Rem.getPxToRem(280),
      decoration: BoxDecoration(
          border: Border.all(
        color: borderColor,
      )),
      child: Row(
        children: <Widget>[
          Container(
            width: Rem.getPxToRem(80),
            color: this.min >= this.number ? Colors.grey[200] : Colors.white,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color:
                      this.min >= this.number ? Colors.grey[500] : Colors.black,
                ),
                onPressed: () {
                  this.onClickBtn('remove');
                },
              ),
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
            width: Rem.getPxToRem(80),
            color: this.max <= this.number ? Colors.grey[200] : Colors.white,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color:
                      this.max <= this.number ? Colors.grey[500] : Colors.black,
                ),
                onPressed: () {
                  this.onClickBtn('add');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
