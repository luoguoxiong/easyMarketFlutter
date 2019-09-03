/*
 * @Description: 常用的一些方法
 * @Author: luoguoxiong
 * @Date: 2019-08-29 17:25:44
 */
// 数组分组
List listToSort({List toSort, int chunk}) {
  var newList = [];
  for (var i = 0; i < toSort.length; i += chunk) {
    var end = i + chunk > toSort.length ? toSort.length : i + chunk;
    newList.add(toSort.sublist(i, end));
  }
  return newList;
}
