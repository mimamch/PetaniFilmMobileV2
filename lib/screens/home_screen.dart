import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:marquee/marquee.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/screens/components/search_delegate.dart';
import 'package:petani_film_v2/screens/genre_screen/genre_screen.dart';
import 'package:petani_film_v2/services/home_page_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/applovin_ads_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieItemModel> featured = [];
  bool isLoading = false;
  List<Map<String, dynamic>> announcements = [];
  int pageKey = 2;
  Map<String, dynamic>? title;
  List<Map> genres = [];
  final TextEditingController searchController = TextEditingController();

  final PagingController<int, MovieItemModel> _pagingController =
      PagingController(firstPageKey: 2);
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _scrollController.addListener(() {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          fetchMore(pageKey);
          pageKey++;
        }
      });
      getData();
    }
  }

  Future<void> getData() async {
    try {
      Map<String, dynamic> data =
          await HomePageServices().getHomePageItem(page: 1);
      featured = data['featured'] ?? [] as List<MovieItemModel>;
      announcements = data['annoucements'] ?? [];
      title = {
        "title1": data['title1'] ?? "Rekomendasi",
        "title2": data['title2'] ?? "Baru Diperbarui",
      };
      genres = List<Map>.from(data['genres']);
      if (data['current_page'] >= data['total_pages']) {
        _pagingController.appendLastPage(data['last_uploaded']);
      } else {
        _pagingController.appendPage(data['last_uploaded'], 2);
      }
    } catch (e) {
      _pagingController.error = e;
      debugPrint(e.toString());
    }
    // isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
    _scrollController.dispose();
  }

  Future<void> fetchMore(page) async {
    try {
      Map<String, dynamic> data =
          await HomePageServices().getHomePageItem(page: page);
      if (data['current_page'] >= data['total_pages']) {
        _pagingController.appendLastPage(data['last_uploaded']);
      } else {
        _pagingController.appendPage(data['last_uploaded'], page + 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/splash_icon.png',
                width: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('PETANI FILM')
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
                color: Constants.whiteColor,
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(
                  Icons.search,
                  color: Constants.whiteColor,
                )),
          ],
        ),
        bottomNavigationBar:
            Constants.showAds && Constants.applovinBannerAdUnitId.isNotEmpty
                ? ApplovinAdsWidget().bannerAds
                : null,
        body: RefreshIndicator(
          onRefresh: () async {
            featured.clear();
            pageKey = 2;
            _pagingController.refresh();
            setState(() {});
            getData();
            return await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                // const Text(
                //   'Pencarian',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: CustomTextField(
                //           controller: searchController,
                //           onSubmitted: (value) {
                //             if (searchController.text.isEmpty) return;
                //             context.pushNamed('search',
                //                 params: {"query": searchController.text});
                //           },
                //           inputType: TextInputType.text,
                //           maxLines: 1,
                //           action: TextInputAction.go,
                //           placeholder: 'Cari Film / Series'),
                //     ),
                //     const SizedBox(
                //       width: 5,
                //     ),
                //     IconButton(
                //         color: Constants.whiteColor,
                //         onPressed: () {
                //           if (searchController.text.isEmpty) return;
                //           context.pushNamed('search',
                //               params: {"query": searchController.text});
                //         },
                //         icon: const Icon(
                //           Icons.search,
                //           color: Constants.whiteColor,
                //         )),
                //   ],
                // ),
                if (announcements.isNotEmpty) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  ...announcements
                      .map((e) => GestureDetector(
                            onTap: () async {
                              if (e['action'] == 'launch_url' &&
                                  e['link'] != null) {
                                launchUrlString(e['link'],
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                color: e['color'] == null
                                    ? Constants.greyColor
                                    : Color(int.parse(e['color']
                                        .toString()
                                        .replaceAll('#', '0xff'))),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              child: Marquee(
                                text: e['label'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                blankSpace: size.width,
                                pauseAfterRound: const Duration(seconds: 1),
                                startAfter: const Duration(seconds: 1),
                              ),
                            ),
                          ))
                      .toList(),
                ],
                const SizedBox(
                  height: 5,
                ),
                if (genres.isNotEmpty) ...[
                  if (title != null && title?['title1'] != null)
                    const Text(
                      'Berdasarkan Genre',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: (genres)
                          .map((e) => GestureDetector(
                                onTap: () {
                                  context.pushNamed(GenreScreen.routeName,
                                      queryParams: Map<String, String>.from(e));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: Constants.primaryblueColor,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Text(
                                    e['label'] ?? '',
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(
                  height: 5,
                ),
                if (featured.isNotEmpty) ...[
                  if (title != null && title?['title1'] != null)
                    Text(
                      title!['title1'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        ...(featured
                            .map((e) => Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 150,
                                  child: HomeFeaturedItem(movie: e),
                                ))
                            .toList())
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
                if (title != null && title?['title2'] != null)
                  Text(
                    title!['title2'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(
                  height: 10,
                ),
                PagedGridView<int, MovieItemModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<MovieItemModel>(
                    itemBuilder: (context, item, index) {
                      return HomeMovieItem(
                        movie: item,
                      );
                    },
                    firstPageProgressIndicatorBuilder: (context) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        3,
                        (index) => Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 163, 163, 163),
                          highlightColor:
                              const Color.fromRGBO(245, 245, 245, 1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: (size.width - 60) / 3,
                              height: (size.width - 60) / 2,
                              color: Constants.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    newPageProgressIndicatorBuilder: (context) =>
                        const HomeMovieItemShimmer(),
                    newPageErrorIndicatorBuilder: (context) => Center(
                      child: Text(
                        _pagingController.error?.toString() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Text(
                        _pagingController.error?.toString() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  showNewPageErrorIndicatorAsGridChild: true,
                  showNewPageProgressIndicatorAsGridChild: true,
                  showNoMoreItemsIndicatorAsGridChild: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 3
                          : 5,
                      crossAxisSpacing: 20,
                      childAspectRatio: 152 / 228,
                      mainAxisSpacing: 20),
                ),
              ]),
        ));
  }
}
