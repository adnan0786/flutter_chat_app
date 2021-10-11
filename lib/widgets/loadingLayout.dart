import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 15;

    return Shimmer.fromColors(
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      baseColor: Theme.of(context).backgroundColor,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 2),
      child: ListView.builder(
          itemCount: 12,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 16),
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: containerWidth,
                                  height: containerHeight,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  width: containerWidth * 0.75,
                                  height: containerHeight,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 20,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(30)),
                    height: containerHeight,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
