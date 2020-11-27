import 'package:flutter/material.dart';

/* Packages */
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LoadingProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 10,
      itemCount: 6,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemBuilder: (ctx, index) {
        return LayoutBuilder(
          builder: (_, constraint) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: SkeletonAnimation(
                          curve: Curves.easeInCubic,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: SkeletonAnimation(
                        curve: Curves.easeInCubic,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2.5),
                                height: 10,
                                width: constraint.maxWidth * .7,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2.5),
                                height: 10,
                                width: constraint.maxWidth * .4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2.5),
                                height: 10,
                                width: constraint.maxWidth * .5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(5, index.isEven ? 7 : 5);
      },
    );
  }
}
