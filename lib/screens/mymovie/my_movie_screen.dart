import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';
import '../../model/add/add_model.dart';

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
            mobile: AddMyMovieModalM(addMovieSuccess: _addMovieSuccess),
            tablet: AddMyMovieModalT(addMovieSuccess: _addMovieSuccess),
          ),
        )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final myMovieList = Provider.of<AddModel>(context).myMovieList;
    print(myMovieList.length > 0 ? myMovieList[0].data : '');

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldmyMovieKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#f04c24'),
        child: Icon(Icons.add),
        onPressed: () { _showAddMovieModal(context, screenSize); },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: isLoading
      ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            leading: Text(myMovieList[index].data['movie_title']),
                          )
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