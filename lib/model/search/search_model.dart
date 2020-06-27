import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './search.dart';

class SearchModel with ChangeNotifier {

  List<Search> movieList = [];
  Map movieDetail = {};

  // final String rapidMovieAPIUrl = DotEnv().env['RAPID_MOVIE_API_URL'];
  // Map<String, String> headers = {
  //   "x-rapidapi-host": DotEnv().env['RAPID_MOVIE_HOST'],
  //   "x-rapidapi-key": DotEnv().env['RAPID_MOVIE_KEY']
  // };

  Future<String> searchMovieWithTitle(String movieTitle) async {

    // Need to initialize to when user search again
    List<Search> movieListSample = [];
    
    final response = await http.get('${DotEnv().env['RAPID_MOVIE_API_URL']}?r=json&s=$movieTitle', headers: {
      "x-rapidapi-host": DotEnv().env['RAPID_MOVIE_HOST'],
      "x-rapidapi-key": DotEnv().env['RAPID_MOVIE_KEY']
    });

    Map responseData = json.decode(response.body);

    if(responseData['Search'] == null) {
      return 'There is no result\nPlease type correct movie name';
    }

    responseData['Search'].map((el) {
      Search search = new Search(
        title: el['Title'],
        year: el['Year'],
        imdbID: el['imdbID'],
        poster: el['Poster']
      );
      movieListSample.add(search);
    }).toList();

    movieList = [...movieListSample];

    notifyListeners();
    return null;
  } 

  Future<String> searchMovieDetailWithID(String imdbID) async {

    final response = await http.get('${DotEnv().env['RAPID_MOVIE_API_URL']}?r=json&i=$imdbID', headers: {
      "x-rapidapi-host": DotEnv().env['RAPID_MOVIE_HOST'],
      "x-rapidapi-key": DotEnv().env['RAPID_MOVIE_KEY']
    });

    Map responseData = json.decode(response.body);

    if(responseData == null) {
      return 'There is an error in calling data, please try again';
    }

    movieDetail = responseData;
    
    notifyListeners();
    return null;
  } 

}