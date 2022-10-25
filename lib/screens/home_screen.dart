import 'package:flutter/material.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/home_page_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieItemModel> lastUploaded = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData();
    }
  }

  Future<void> getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<MovieItemModel> data = await HomePageServices().getHomePageItem();
      lastUploaded = data;
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PETANI FILM'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                children: [
                    const Text(
                      'Last Uploaded',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                      itemCount: lastUploaded.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 15,
                              childAspectRatio: 152 / 228,
                              mainAxisSpacing: 15),
                      itemBuilder: (context, index) {
                        return HomeMovieItem(
                          movie: lastUploaded[index],
                        );
                      },
                    ),
                  ]));
  }
}
