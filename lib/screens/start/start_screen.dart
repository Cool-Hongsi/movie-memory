import 'package:flutter/material.dart';

class StartScreenM extends StatelessWidget {

  final Function slideStartBtn;
  StartScreenM({ this.slideStartBtn });

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/start_image.jpg',
              fit: BoxFit.fitHeight,
            )
          ),
          Positioned(
            bottom: screenSize.height * .05,
            left: 0,
            right: 0,
            child: Container(
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
                      'Movie Memory',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Questrial',
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.compare_arrows, color: Colors.white)
                  ],
                ),
                background: Container(
                  color: Colors.white,
                ),
                key: ValueKey('Movie Memory'),
              ),
            ),
          )
        ],
      ),
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