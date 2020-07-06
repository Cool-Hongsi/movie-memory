import 'package:flutter/material.dart';
import '../../model/appconfig/app_locale.dart';

class StartScreenM extends StatelessWidget {

  final Function slideStartBtn;
  StartScreenM({ this.slideStartBtn });

  // Widget delaySlideText() {
  //   // To match logo image loading time
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     return Text(
  //       'Slide To Start',
  //       style: TextStyle(
  //         color: Colors.black87,
  //         fontFamily: 'Quicksand-Bold',
  //         fontSize: 18
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screenSize.width * .55,
              child: Image.asset('assets/images/movie_memory_logo.png'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.transparent,
              height: screenSize.height * 0.1,
              child: Dismissible(
                onDismissed: (direction) {
                  slideStartBtn();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate('slideToStart'),
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Quicksand-Bold',
                        fontSize: 18
                      ),
                    )
                  ],
                ),
                background: Container(
                  color: Colors.black87,
                ),
                key: ValueKey('Movie Memory'),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class StartScreenT extends StatelessWidget {

  final Function slideStartBtn;
  StartScreenT({ this.slideStartBtn });

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}