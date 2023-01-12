import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/home_page_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/applovin_ads_widget.dart';
import 'package:shimmer/shimmer.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key, required this.genre});
  static const String routeName = 'genre-page';

  final Map<String, String> genre;

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  List<MovieItemModel> featured = [];
  bool isLoading = false;
  List<Map<String, dynamic>> announcements = [];
  int pageKey = 2;
  Map<String, dynamic>? title;
  List<Map> genres = [];
  final TextEditingController searchController = TextEditingController();

  final PagingController<int, MovieItemModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _pagingController.addPageRequestListener((pageKey) {
        fetchMore(pageKey);
      });
    }
  }

  // Future<void> getData() async {
  //   try {
  //     Map<String, dynamic> data = await HomePageServices()
  //         .getByGenre(page: 1, slug: widget.genre['slug']);

  //     if (data['current_page'] >= data['total_pages']) {
  //       _pagingController.appendLastPage(data['last_uploaded']);
  //     } else {
  //       _pagingController.appendPage(data['last_uploaded'], 2);
  //     }
  //   } catch (e) {
  //     _pagingController.error = e;
  //     debugPrint(e.toString());
  //   }
  //   // isLoading = false;
  //   // setState(() {});
  // }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
    // _scrollController.dispose();
  }

  Future<void> fetchMore(page) async {
    try {
      Map<String, dynamic> data = await HomePageServices()
          .getByGenre(page: page, slug: widget.genre['slug']);
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
            children: [Text('Genre : ${widget.genre['label'] ?? Action}')],
          ),
          centerTitle: false,
        ),
        bottomNavigationBar:
            Constants.showAds && Constants.applovinBannerAdUnitId.isNotEmpty
                ? ApplovinAdsWidget().bannerAds
                : null,
        body: RefreshIndicator(
          onRefresh: () async {
            // featured.clear();
            pageKey = 1;
            _pagingController.refresh();
            setState(() {});
            // getData();
            return await Future.delayed(const Duration(seconds: 1));
          },
          child: PagedGridView<int, MovieItemModel>(
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
                    highlightColor: const Color.fromRGBO(245, 245, 245, 1),
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
            shrinkWrap: true,
            showNewPageErrorIndicatorAsGridChild: true,
            showNewPageProgressIndicatorAsGridChild: true,
            showNoMoreItemsIndicatorAsGridChild: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 3
                        : 5,
                crossAxisSpacing: 20,
                childAspectRatio: 152 / 228,
                mainAxisSpacing: 20),
          ),
        ));
  }
}
