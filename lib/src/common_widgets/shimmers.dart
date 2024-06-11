import 'package:flutter/material.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key, required this.height, required this.width})
      : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade300,
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  const TitlePlaceholder({Key? key, required this.width}) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 20.0,
      color: Colors.grey.shade300,
    );
  }
}

enum ContentLineType { oneLine, twoLines, threeLines }

class ContentPlaceholder extends StatelessWidget {
  const ContentPlaceholder({Key? key, required this.lineType})
      : super(key: key);
  final ContentLineType lineType;

  @override
  Widget build(BuildContext context) {
    int lines;
    switch (lineType) {
      case ContentLineType.oneLine:
        lines = 1;
        break;
      case ContentLineType.twoLines:
        lines = 2;
        break;
      case ContentLineType.threeLines:
        lines = 3;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            width: double.infinity,
            height: 16.0,
            color: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

class SmallcontentPlaceholder extends StatelessWidget {
  const SmallcontentPlaceholder({
    Key? key,
    required this.width,
    this.height = 20,
  }) : super(key: key);
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
    );
  }
}
