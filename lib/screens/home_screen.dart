import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/home_page_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:petani_film_v2/shared/widget/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieItemModel> featured = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  final PagingController<int, MovieItemModel> _pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _pagingController.addPageRequestListener((pageKey) {
        if (pageKey == 1) {
          getData();
        } else {
          fetchMore(pageKey);
        }
      });
    }
  }

  Future<void> getData() async {
    try {
      Map<String, dynamic> data =
          await HomePageServices().getHomePageItem(page: 1);

      featured = data['featured'] ?? [] as List<MovieItemModel>;
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('PETANI FILM'),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Text(
                'Search',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                        controller: searchController,
                        inputType: TextInputType.text,
                        maxLines: 1,
                        placeholder: 'Cari Film / Series'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      color: Constants.whiteColor,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Constants.whiteColor,
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (featured.isNotEmpty) ...[
                const Text(
                  'Populer',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                CarouselSlider.builder(
                    itemCount: featured.length,
                    itemBuilder: (context, index, realIndex) {
                      return HomeFeaturedItem(movie: featured[index]);
                    },
                    options: CarouselOptions(
                      height: 150,
                      autoPlay: true,
                      viewportFraction: 0.3,
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
              const Text(
                'Baru Diperbarui',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    childAspectRatio: 152 / 228,
                    mainAxisSpacing: 20),
              ),
            ]));
  }
}
