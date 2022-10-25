import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerTextLoading extends StatelessWidget {
  const CustomShimmerTextLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 189, 189, 189),
      highlightColor: const Color.fromRGBO(245, 245, 245, 1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Constants.whiteColor.withOpacity(0.5),
        ),
        height: 30,
      ),
    );
  }
}

class CustomShimmerList extends StatelessWidget {
  const CustomShimmerList({super.key, this.count = 10});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 189, 189, 189),
            highlightColor: const Color.fromRGBO(245, 245, 245, 1),
            // enabled: _enabled,
            child: Column(
              children: List.generate(
                count,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: 40.0,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 80.0,
                        height: 25.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomShimmerNotificationList extends StatelessWidget {
  const CustomShimmerNotificationList({super.key, this.count = 10});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 189, 189, 189),
            highlightColor: const Color.fromRGBO(245, 245, 245, 1),
            // enabled: _enabled,
            child: Column(
              children: List.generate(
                count,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: 80.0,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: 40.0,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
