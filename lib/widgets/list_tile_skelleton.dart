import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class ListStileSkelleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PKCardSkeleton(isCircularImage: true, isBottomLinesActive: true),
          PKCardSkeleton(isCircularImage: true, isBottomLinesActive: true),
          PKCardSkeleton(isCircularImage: true, isBottomLinesActive: true),
          PKCardSkeleton(isCircularImage: true, isBottomLinesActive: true),
        ],
      ),
    );
  }
}
