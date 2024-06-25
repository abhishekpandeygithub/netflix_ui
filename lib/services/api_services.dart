import 'dart:convert';

//import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:netflix_ui/common/utils.dart';
import 'package:netflix_ui/models/movie_detail_model.dart';
import 'package:netflix_ui/models/movie_recommendation_model.dart';
import 'package:netflix_ui/models/search_model.dart';
import 'package:netflix_ui/models/tv_series_model.dart';
//import 'package:netflix_ui/models/nowplaying_movie_model.dart';
import 'package:netflix_ui/models/upcoming_movie_model.dart';

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMocies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //  print("success");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Upcoming Movies");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //  print("success");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load Now Playing Movies");
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = "tv/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
     // print("success");
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load top rated tvSeries");
  }

   Future<MovieRecommendationModel> getPopularMovie() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
     print("success");
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load popular movie");
  }




  Future<SearchModel> getSearchedMovie(String searchText) async {
    endPoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endPoint";
    //print("search url is $url");

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MjYwNWU4NTg5Zjk1ZWEyZTg1YWEwNmQwMDhmZGJkYyIsInN1YiI6IjY2NzNlYzI5NTZjMDkzYWQ4YjU0ODg2NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SV1_ev-EZkOaM65PlF0s4_Uq0_Rni7OQ1gR0J-3VavU"
    });

    if (response.statusCode == 200) {
      //  print("success");
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load searched movies");
  }



   Future<MovieDetailModel> getMovieDetail(int movieID) async {
    endPoint = "movie/$movieID";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
     // print("success");
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movie details");
  }


  Future<MovieRecommendationModel> getMovieRecommendations(int movieID) async {
    endPoint = "movie/$movieID/recommendations";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
    // print("succe ss");
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movie details");
  }
}
