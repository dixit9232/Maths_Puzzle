import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_puzzle/Data.dart';
import 'package:math_puzzle/main.dart';
import 'package:math_puzzle/winning_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class puzzle extends StatefulWidget {
  int index;
  int? index1;

  puzzle(this.index, [this.index1]);

  State<puzzle> createState() => _puzzleState();
}

class _puzzleState extends State<puzzle> {
  TextEditingController t1 = TextEditingController();
  bool temp = false;

  get() async {
    MathsPuzzle.prefs = await SharedPreferences.getInstance();
    if (widget.index1 != null) {
      widget.index = widget.index1!;
    } else {
      widget.index = MathsPuzzle.prefs!.getInt("lvl") ?? 0;
    }
    setState(() {});
  }

  fun(String s) {
    t1.text = t1.text + s;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are You Sure To Exit"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return MathsPuzzle();
                        },
                      ));
                    },
                    child: Text("Yes"))
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade400,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Images/gameplaybackground.jpg"),
                    fit: BoxFit.fill)),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (MathsPuzzle.prefs!.getString("skip_time") != null) {
                          DateTime dt = DateTime.now();
                          String past_time =
                              MathsPuzzle.prefs!.getString("skip_time") ?? "";
                          DateTime dt1 = DateTime.parse(past_time);
                          int sec = dt.difference(dt1).inSeconds;
                          if (sec >= 30) {
                            String skip_time = DateTime.now().toString();
                            MathsPuzzle.prefs!
                                .setString("skip_time", skip_time);
                            MathsPuzzle.prefs!
                                .setString("lvl${widget.index}", "skip");
                            setState(() {
                              widget.index++;
                            });
                            (widget.index1 == null)
                                ? MathsPuzzle.prefs!.setInt("lvl", widget.index)
                                : 0;
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                      "You Have Skip This Level After ${30 - sec} Seconds"),
                                  actions: [
                                    CupertinoButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          String skip_time = DateTime.now().toString();
                          MathsPuzzle.prefs!.setString("skip_time", skip_time);
                          MathsPuzzle.prefs!
                              .setString("lvl${widget.index}", "skip");
                          setState(() {
                            widget.index++;
                          });
                          (widget.index1 == null)
                              ? MathsPuzzle.prefs!.setInt("lvl", widget.index)
                              : 0;
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/skip.png"))),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 200,
                      child: Text(
                        "Puzzle ${widget.index + 1}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/Images/level_board.png"),
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("Enter ${Data.hint[widget.index]}"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"))
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Images/hint.png"))),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              AssetImage("${Data.puzzle_img[widget.index]}"))),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                          height: 150,
                          color: Colors.black,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                        ),
                                        child: TextField(
                                            controller: t1,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)))),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (t1.text.length != 0) {
                                          t1.text = t1.text
                                              .substring(0, t1.text.length - 1);
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/Images/delete.png"))),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTapDown: (details) {
                                      temp = true;
                                      setState(() {});
                                    },
                                    onTapUp: (details) {
                                      temp = false;
                                      setState(() {});
                                    },
                                    onTapCancel: () {
                                      temp = false;
                                      setState(() {});
                                    },
                                    child: OutlinedButton(
                                        style: ButtonStyle(
                                            side: (temp == true)
                                                ? MaterialStatePropertyAll(
                                                    BorderSide(
                                                        width: 5,
                                                        color: Colors.white))
                                                : null),
                                 onPressed: () {
                                          if (t1.text ==
                                              Data.Ans[widget.index]) {
                                            if (widget.index1 == null) {
                                              MathsPuzzle.prefs!.setString(
                                                  "lvl${widget.index}", "yes");
                                              widget.index++;
                                              MathsPuzzle.prefs!
                                                  .setInt("lvl", widget.index);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return winpage(widget.index);
                                                },
                                              ));
                                            } else {
                                              if(MathsPuzzle.prefs!
                                                  .getString("lvl${widget.index}")=="skip"){
                                                MathsPuzzle.prefs!.setString(
                                                    "lvl${widget.index}", "yes");
                                                widget.index++;
                                              }
                                              else if(MathsPuzzle.prefs!.getString("lvl${widget.index}")=="No"){
                                                MathsPuzzle.prefs!.setString(
                                                    "lvl${widget.index}", "yes");
                                                widget.index++;
                                                MathsPuzzle.prefs!.setInt("lvl", widget.index);
                                              }
                                              else{
                                                widget.index++;
                                              }
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return winpage(
                                                      widget.index);
                                                },
                                              ));
                                            }
                                            if (widget.index1 == null) {
                                              widget.index = MathsPuzzle.prefs!
                                                      .getInt("lvl") ??
                                                  0;
                                              MathsPuzzle.prefs!
                                                  .setInt("lvl", widget.index);
                                            }
                                            t1.text = "";
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text("Wrong Ans!!")));
                                          }
                                          widget.index1 = null;
                                          setState(() {});
                                        },
                                        child: Text(
                                          "SUBMIT",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("1"),
                                        child: Text("1"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("2"),
                                        child: Text("2"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("3"),
                                        child: Text("3"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("4"),
                                        child: Text("4"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("5"),
                                        child: Text("5"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("6"),
                                        child: Text("6"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("7"),
                                        child: Text("7"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("8"),
                                        child: Text("8"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("9"),
                                        child: Text("9"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => fun("0"),
                                        child: Text("0"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
