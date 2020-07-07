import 'package:flutter/material.dart';
import 'package:justgroove/my_colors.dart';

class MyBorderedContainer extends StatelessWidget{

  final Widget child;
  final Color backgroundColor;

  @override
  MyBorderedContainer ({@required this.child, this.backgroundColor, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
           color: MyColors.dark,
        ),
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,                           
      ),
      child: this.child,
    );
  }
}


class MyBorderedTextContainer extends StatelessWidget{
  final String text;
  final double textSize;
  final Color textColor;
  final Color backgroundColor;

  @override
  MyBorderedTextContainer({@required this.text, this.textSize, this.textColor, this.backgroundColor, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBorderedContainer(
      backgroundColor: this.backgroundColor,
      child: Container(
        padding: EdgeInsets.all(4),
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: this.textSize,
              color: this.textColor,
            ),
          ),
        ),
      ),
    );
  }
}