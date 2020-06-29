import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as syspaths;

class DetailMovie {

  String moviePoster;
  String movieTitle;
  
  DetailMovie(Map movieDetail){
    if(movieDetail['Poster'] == "N/A" || !movieDetail.containsKey('Poster')){
      if(movieDetail['Title'] == "N/A" || !movieDetail.containsKey('Title')){
        this.moviePoster = "N/A"; this.movieTitle = "N/A";
      } else {
        this.moviePoster = "N/A"; this.movieTitle = movieDetail['Title'];
      }
    } else {
      if(movieDetail['Title'] == "N/A" || !movieDetail.containsKey('Title')){
        this.moviePoster = movieDetail['Poster']; this.movieTitle = "N/A";
      } else {
        this.moviePoster = movieDetail['Poster']; this.movieTitle = movieDetail['Title'];
      }
    }
  }

  Future<File> convertUrlToFile(String url) async {

    try {
      var response = await http.get(url);
      
      // Real Device Path
      final appDir = await syspaths.getApplicationDocumentsDirectory();

      // To save exact unique last path for url
      List<String> urlSplit = url.split('/');
      
      // Create File with path
      File _file = new File(appDir.path + '/' + urlSplit[urlSplit.length - 1]);

      // Save url image data to file with above path
      _file.writeAsBytesSync(response.bodyBytes);

      return _file;
    } catch (err) {
      print(err);
      return null;
    }
  }

}