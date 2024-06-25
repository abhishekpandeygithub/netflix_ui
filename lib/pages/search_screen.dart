import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_ui/common/utils.dart';
import 'package:netflix_ui/models/movie_recommendation_model.dart';
import 'package:netflix_ui/models/search_model.dart';
import 'package:netflix_ui/pages/movie_detail_screen.dart';
import 'package:netflix_ui/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  FocusNode searchFocusNode = FocusNode();
  bool isSearching = false;

  late Future<MovieRecommendationModel> popularMovies;

  SearchModel? searchModel;

  void search(String query) {
    apiServices.getSearchedMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    popularMovies = apiServices.getPopularMovie();
    searchFocusNode.addListener(() {
      setState(() {
        isSearching = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  labelText: isSearching ? null : 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            searchFocusNode.unfocus();
                            setState(() {
                              isSearching = false;
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      searchModel = null;
                    });
                  } else {
                    search(searchController.text);
                  }
                },
              ),
            ),
            Expanded(
              child: searchController.text.isEmpty
                  ? FutureBuilder<MovieRecommendationModel>(
                      future: popularMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.results?.isEmpty == true) {
                          return const Center(child: Text('No movies found'));
                        } else {
                          var data = snapshot.data!.results;
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Top Searches",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data?.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieDetailScreen(
                                                        movieID:
                                                            data[index].id!,
                                                      )));
                                        },
                                        child: Container(
                                          height: 170,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                  "$imageUrl${data?[index].posterPath}"),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 260,
                                                child: Text(
                                                  data![index].title!,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          );
                        }
                      })
                  : searchModel == null
                      ? const Center(child: Text('No results'))
                      : GridView.builder(
                          shrinkWrap: true,
                          itemCount: searchModel?.results?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 150,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2 / 2,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(
                                          movieID:
                                              searchModel!.results![index].id!),
                                    ));
                              },
                              child: Column(
                                children: [
                                  searchModel!.results![index].backdropPath ==
                                          null
                                      ? Image.asset(
                                          "assets/netflix.png",
                                          height: 115,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              "$imageUrl${searchModel!.results![index].backdropPath}",
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      searchModel!
                                          .results![index].originalTitle!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
