import 'package:flutter/material.dart';
import 'package:math_puzzle/Data.dart';
import 'package:math_puzzle/main.dart';
import 'package:math_puzzle/puzzle_page.dart';

class Clearing_Puzzle extends StatefulWidget {
  int index;
  List skip;

  Clearing_Puzzle(this.index, this.skip);

  @override
  State<Clearing_Puzzle> createState() => _Clearing_PuzzleState();
}

class _Clearing_PuzzleState extends State<Clearing_Puzzle> {
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
      showDialog(context: context, builder: (context) {
        return AlertDialog(title: Text("Are You Sure to Exit"),actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child:Text("No")),
          TextButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return MathsPuzzle();
            },));
          },child:Text("Yes")),
        ],);
      },);
      return true;
    },
      child: Scaffold(backgroundColor: Colors.grey,
        body: SafeArea(
          child: Container(width: double.infinity,height: double.infinity,decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: AssetImage("assets/Images/background.jpg"))),

            child: GridView.builder(
              itemCount: Data.puzzle_img.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    if (widget.skip[index] == "No") {
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return puzzle(widget.index,index);
                        },
                      ));
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: (widget.index >= index)
                          ? Text(
                              "${index + 1}",
                              style: TextStyle(fontFamily: "chalk", fontSize: 50),
                            )
                          : null,
                      decoration: BoxDecoration(
                          border: (widget.index >= index) ? Border.all() : null,
                          borderRadius: (widget.index >= index)
                              ? BorderRadius.circular(25)
                              : null,
                          image: (widget.index >= index)
                              ? (widget.skip[index] == "yes")
                                  ? DecorationImage(
                                      image: AssetImage("assets/Images/tick.png"))
                                  : null
                              : DecorationImage(
                                  image: AssetImage("assets/Images/lock.png")))),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
