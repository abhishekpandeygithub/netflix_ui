import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:netflix_ui/common/utils.dart';
import 'package:netflix_ui/models/upcoming_movie_model.dart';
import 'package:netflix_ui/pages/movie_detail_screen.dart';

class MovieCardWidget extends StatelessWidget {
  final Future<UpcomingMovieModel> future;
  final String headLineText;

  const MovieCardWidget(
      {super.key, required this.future, required this.headLineText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpcomingMovieModel>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headLineText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(5),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                      movieID: data![index].id!),
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.network(
                                "$imageUrl${data?[index].posterPath}"),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        });
  }
}
