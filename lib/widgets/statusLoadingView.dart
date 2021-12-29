import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StatusLoadingView extends StatelessWidget {
  const StatusLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      baseColor: Theme.of(context).backgroundColor,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 2),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          shape: BoxShape.circle),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
