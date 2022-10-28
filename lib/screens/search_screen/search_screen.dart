import 'package:flutter/material.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/screens/components/movie_item.dart';
import 'package:petani_film_v2/services/home_page_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.query});
  final String query;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<MovieItemModel>? data;
  String? error;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      error = null;
      data = await HomePageServices().getSearchQuery(query: widget.query);
    } catch (e) {
      error = e.toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil Pencarian ${widget.query}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: data == null && error == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Text(
                    error!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemBuilder: (context, index) => HomeMovieItem(
                    movie: data![index],
                  ),
                  itemCount: data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 3
                          : 5,
                      crossAxisSpacing: 20,
                      childAspectRatio: 152 / 228,
                      mainAxisSpacing: 20),
                ),
    );
  }
}
