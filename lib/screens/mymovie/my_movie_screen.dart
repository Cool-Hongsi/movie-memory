import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';
import '../../model/add/add_model.dart';
import '../../model/mymovie/my_movie_model.dart';

import './add_my_movie_modal.dart';
import '../../services/hex_color.dart';

class MyMovieScreenM extends StatefulWidget {
  @override
  _MyMovieScreenMState createState() => _MyMovieScreenMState();
}

class _MyMovieScreenMState extends State<MyMovieScreenM> {

  final _scaffoldmyMovieKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  List<String> filterList = [''];

  Future<void> initGetMyMovieList() async {
    setState(() {
      isLoading = true;
    });

    await Provider.of<AddModel>(context, listen: false).getMyMovieList()
    .then((err) {
      if(err == null) { // Success
        setState(() {
          isLoading = false;
        });
        return ;
      }
      // Fail
      _scaffoldmyMovieKey.currentState.showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        )
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  // When User Click MyMovie Navigation
  @override
  void initState() {
    super.initState();
    initGetMyMovieList();
  }

  // When User Add New Movie
  void _addMovieSuccess() {
    _scaffoldmyMovieKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Successfully Added"),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
      )
    );
    // Calling initGetMyMovieList() after delay since the new movie is done to add firebase successfully
    Future.delayed(const Duration(milliseconds: 700), () => initGetMyMovieList());
  }

  // When User Edit Movie
  void _editMovieSuccess() {
    _scaffoldmyMovieKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Successfully Edited"),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
      )
    );
    // Calling initGetMyMovieList() after delay since the new movie is done to add firebase successfully
    Future.delayed(const Duration(milliseconds: 700), () => initGetMyMovieList());
  }

  void _showAddMovieModal(BuildContext ctx, Size screenSize) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      // ),
      builder: (_) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(ctx).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: screenSize.height * .8,
          child: ScreenTypeLayout(
            mobile: AddMyMovieModalM(addMovieSuccess: _addMovieSuccess, moviePoster: null, movieTitle: null),
            tablet: AddMyMovieModalT(addMovieSuccess: _addMovieSuccess, moviePoster: null, movieTitle: null),
          ),
        )
        );
      }
    );
  }

  void _selectedMovieDetail(Map selectedDocument) {
    Navigator.of(context).pushNamed('/mymoviedetail', arguments: {
      'selectedDocument' : selectedDocument, // map
      'editMovieSuccess' : _editMovieSuccess // function
    });
  }

  Future<void> _selectedMovieDelete(String documentId, String imageUrl, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Movie', style: TextStyle(fontFamily: 'Quicksand-Bold'),),
          content: Text('Do you want to delete movie from list?'),
          elevation: 5,
          actions: <Widget>[
            FlatButton(
              child: Text('NO', style: TextStyle(fontFamily: 'Quicksand-Bold', color: Colors.black87)),
              onPressed: () { Navigator.of(context).pop(); },
            ),
            FlatButton(
              child: Text('YES', style: TextStyle(fontFamily: 'Quicksand-Bold', color: HexColor('#d90429'))),
              onPressed: () {
                Provider.of<MyMovieModel>(context, listen: false).selectedMovieDelete(documentId, imageUrl)
                .then((err) {
                  if(err == null){ // success
                    Navigator.of(context).pop();
                    initGetMyMovieList();
                    return ;
                  }
                  // fail
                  _scaffoldmyMovieKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(err),
                      backgroundColor: Theme.of(context).errorColor,
                      duration: const Duration(seconds: 2),
                    )
                  );
                });
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final myMovieList = Provider.of<AddModel>(context).myMovieList;
    // print(myMovieList.length > 0 ? myMovieList[0].data : '');

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldmyMovieKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#d90429'),
        child: Icon(Icons.add),
        onPressed: () { _showAddMovieModal(context, screenSize); },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: isLoading
      ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(HexColor('#d90429')),
        ),
      )
      : myMovieList.length > 0
        ? SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.sort),
                      // Additional Filter.. (ListView Horizon Direction ??)
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: screenSize.height * 1 - screenSize.height * .1 - 74, // Bottom Nav & Filter Bar
                  child: ListView.builder(
                    itemCount: myMovieList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey('movieList'),
                        confirmDismiss: (direction) {
                          if(direction == DismissDirection.startToEnd) {
                            _selectedMovieDelete(myMovieList[index].data['id'], myMovieList[index].data['movie_image'], context);
                          } else {
                            _selectedMovieDelete(myMovieList[index].data['id'], myMovieList[index].data['movie_image'], context);
                          }
                          return ;
                        },
                        background: Container(
                          color: Colors.black87,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: screenSize.width * .12),
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Icon(Icons.delete, color: Colors.white, size: 25)
                        ),
                        secondaryBackground: Container(
                          color: Colors.black87,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: screenSize.width * .12),
                          margin: EdgeInsets.only(bottom: 8.0),
                          child: Icon(Icons.delete, color: Colors.white, size: 25)
                        ),
                        child: GestureDetector(
                          onTap: () { _selectedMovieDetail(myMovieList[index].data); },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(right: screenSize.width * .07),
                              height: screenSize.height * .16,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: screenSize.width * .23,
                                    child: Image.network(
                                      myMovieList[index].data['movie_image'],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  SizedBox(width: screenSize.width * .07),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          myMovieList[index].data['movie_title'],
                                          style: TextStyle(
                                            fontFamily: 'Quicksand-Bold',
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          myMovieList[index].data['watch_date'],
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        if(myMovieList[index].data['movie_rate'] == 1.0)
                                        Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 24),
                                        if(myMovieList[index].data['movie_rate'] == 2.0)
                                        Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 24),
                                        if(myMovieList[index].data['movie_rate'] == 3.0)
                                        Icon(Icons.sentiment_neutral, color: Colors.yellow, size: 24),
                                        if(myMovieList[index].data['movie_rate'] == 4.0)
                                        Icon(Icons.sentiment_satisfied, color: Colors.green, size: 24),
                                        if(myMovieList[index].data['movie_rate'] == 5.0)
                                        Icon(Icons.sentiment_very_satisfied, color: Colors.blue, size: 24)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ),
                        ),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        )
        : Center(
          child: Text(
            'There is no my movie list',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87
            ),
          )
        )
    );
  }
}

class MyMovieScreenT extends StatefulWidget {
  @override
  _MyMovieScreenTState createState() => _MyMovieScreenTState();
}

class _MyMovieScreenTState extends State<MyMovieScreenT> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}