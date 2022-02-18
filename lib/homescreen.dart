import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supermario/box.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:supermario/jumpingmario.dart';
import 'package:supermario/shrooms.dart';
import 'button.dart';
import 'mario.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static double marioX= -1;
  static double marioY= 1;
  double marioSize = 50;
  double blockSize = 35;
  static double blockX = -0.3;
  static double blockY = 0.3;
  static double shroomX = -5;
  static double shroomY = 0.3;
  double shroomInitialHeight = shroomY;
  double time = 0;
  double stime= 0;
  double height =0;
  double shroomHeight = 0;
  double initialHeight = marioY;
  String direction = "right";
  bool midrun = false;
  bool midjump = false;
  bool touchesBox = false;
  bool makeBoxBrown = false;
  bool heIsAboveBlock = false;
  bool shroomMoved=false;
  int shroomMovesCount = 0;
  /*var gameFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(
      color: Colors.white, fontSize: 20)
  );*/



  void checkIfAteShrooms(){
    if((marioX - shroomX).abs()<0.05 &&
        (marioY -shroomY).abs()<0.05){
      setState(() {
        // if eaten, move the shroom off the screen
        shroomX = 2;
        marioSize = 90;
      });
    }
  }

  void moveRight(){
    direction = "right";
    checkIfAteShrooms();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkIfAteShrooms();
      if(MyButton(null,null).userIsHoldingButton()==true && (marioX - 0.02) < 1){
        setState(() {
          marioX += 0.02;
          midrun = !midrun;
        });
      }else{
        timer.cancel();
      }
    });


  }
  void moveLeft(){
    direction = "left";
    checkIfAteShrooms();
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkIfAteShrooms();
      if(MyButton(null,null).userIsHoldingButton()==true && (marioX - 0.02) > -1){
        setState(() {
          marioX -= 0.02;
          midrun = !midrun;
        });
      }else{
        timer.cancel();
      }
    });
  }



  void preJump(){
    time = 0;
    initialHeight = marioY;
  }

  void preMoveShroom(){
    stime= 0;
    shroomInitialHeight = shroomY;
  }
  void checkIfBeenAboveBox(){
    heIsAboveBlock = (marioX >= -0.5 && marioX < -0.2 && marioY < -0.2);
    print("he is above the block : $heIsAboveBlock");
  }

  void checkIfHitBox() {
    touchesBox = (marioX >= -0.4 && marioX < -0.2 && marioY <= 0.5);
    if(touchesBox){
      makeBoxBrown = true;
    }
    print("$touchesBox");
  }

  void checkShroomMoved() {
    shroomMoved = true;
    print("(the Shroom moved) is $touchesBox");
  }

  void moveShroom(){
      //if(shroomMoved)checkShroomMoved();
    if(shroomMovesCount ==0 && shroomMoved==false){
      shroomX = blockX;
      shroomY = blockY;
    }else{
      shroomMovesCount++;
    }

      //checkIfHitBox();
      preMoveShroom();
      if(shroomMoved == false) {
        Timer.periodic(
            const Duration(milliseconds: 50), (timer) {
          stime += 0.5;
          shroomHeight = (-4.9 * stime * stime) + (5 * stime);

          if (shroomInitialHeight - shroomHeight > 1 ) {
            setState(() {
              if(shroomY < 0){
              shroomY += 0.5;
              //shroomX += 0.3;
              }else{
                shroomY = 1;
               // shroomX += 0.3;
              }

            });
            timer.cancel();
            shroomMoved = true;
          }
          else {
            setState(() {
              shroomY = shroomInitialHeight - shroomHeight;
              shroomX += 0.19;
            });
          }
        });
      }
  }

  void jump(){
    //this first if statement disables the double jump
    if(midjump == false){
      midjump = true;
      //checkIfHitBox();
      preJump();
      if(touchesBox == false) {
        Timer.periodic(
            const Duration(milliseconds: 50), (timer) {
              //checkIfHitBox();
          time += 0.04;
          height = (-4.9 * time * time) + (5 * time);
          checkIfHitBox();
          if (initialHeight - height > 1 || touchesBox) {
            midjump = false;
            setState(() {
              moveShroom();
              marioY = 1;
            });
            timer.cancel();

            touchesBox = false;
          }
          else {
            setState(() {
              marioY = initialHeight - height;
            });
          }
        });
      }

      if(touchesBox){
        makeBoxBrown = true;
      }
      if(heIsAboveBlock){
        marioY = -0.2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    color: Colors.blue,
                    child: AnimatedContainer(
                      alignment: Alignment(marioX,marioY),
                      duration: Duration(milliseconds: 0),
                      child:midjump
                          ? JumpingMario(
                          direction,
                        marioSize
                      )
                          : MyMario(
                          direction,
                          midrun,
                        marioSize
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment(blockX,blockY),
                    child: makeBoxBrown == false
                        ?Box(blockSize)
                        :Container(
                      width: blockSize,
                      height: blockSize,
                      color: Colors.brown,
                    ),
                  ),
                  Container(
                    alignment: Alignment(shroomX,shroomY),
                      child: MyShroom()
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("Mario", style: TextStyle(color: Colors.white,),/*style: gameFont,*/),
                            SizedBox(height: 10,),
                            Text("0000", style: TextStyle(color: Colors.white,),/*style: gameFont,*/),
                          ],
                        ),
                        Column(
                          children: [
                            Text("World", style: TextStyle(color: Colors.white,),/*style: gameFont,*/),
                            SizedBox(height: 10,),
                            Text("1-1", style: TextStyle(color: Colors.white,),/*style: gameFont,*/),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Time", style: TextStyle(color: Colors.white,),/*style: gameFont,*/),
                            SizedBox(height: 10,),
                            Text("9999", style: TextStyle(color: Colors.white,),/*style: gameFont,*/),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
          Expanded(
            flex: 1,
            child: Container(
            color: Colors.amber,
              child: Container(
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Icon(Icons.arrow_back)
                    MyButton(
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      moveLeft

                    ),
                    //Icon(Icons.arrow_upward)
                    MyButton(
                        Icon(Icons.arrow_upward,
                          color: Colors.white,),
                      jump

                    ),
                    //Icon(Icons.arrow_forward)
                    MyButton(
                        Icon(Icons.arrow_forward,
                          color: Colors.white,),
                      moveRight,
                    ),
                  ],
                ),
              ),
          ),
          ),
        ],
      ),
    );
  }
}
