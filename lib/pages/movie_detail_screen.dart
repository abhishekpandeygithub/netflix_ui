import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_ui/common/utils.dart';
import 'package:netflix_ui/models/movie_detail_model.dart';
import 'package:netflix_ui/models/movie_recommendation_model.dart';
import 'package:netflix_ui/services/api_services.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieID;
  const MovieDetailScreen({super.key, required this.movieID});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailModel> movieDetail;

  late Future<MovieRecommendationModel> movieRecommendations;

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetail(widget.movieID);
    movieRecommendations = apiServices.getMovieRecommendations(widget.movieID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.movieID);
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: movieDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data;
              String genreText =
                  movie!.genres!.map((genre) => genre.name).join(', ');
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        //width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("$imageUrl${movie.posterPath}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        movie.title.toString(),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            movie.releaseDate.toString(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            genreText,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movie.overview.toString(),
                        maxLines: 7,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                      future: movieRecommendations,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final movie = snapshot.data;

                          return movie!.results!.isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("More like this"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GridView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: movie.results!.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisExtent: 170,
                                          crossAxisSpacing: 3,
                                          childAspectRatio: 1.5 / 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieDetailScreen(
                                                            movieID: movie
                                                                .results![index]
                                                                .id!),
                                                  ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  movie.results![index]
                                                              .posterPath ==
                                                          null
                                                      ? Image.asset(
                                                          "assets/netflix.png",
                                                          height: 115,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              "$imageUrl${movie.results![index].posterPath}",
                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                );
                        }
                        return const Text("somthing went wrong");
                      }),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
