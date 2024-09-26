import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int number = 0;
  int incrementLimit = 33;
  int total = 0;

  void incrementCounter() {
    setState(() {
      if (number >= incrementLimit) {
        number = 1;
      } else {
        number++;
      }
      total++;
      saveTotal();
    });
  }

  void reset() {
    setState(() {
      number = 0;
    });
  }

  void resetTotal() async {
    setState(() {
      total = 0;
      number = 0;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('total');
  }

  void saveTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('total', total);
  }

  @override
  void initState() {
    super.initState();
    loadTotal();
  }

  void loadTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      total = prefs.getInt('total') ?? 0;
    });
  }

  void changeTarget() {
    setState(() {
      incrementLimit = (incrementLimit == 33) ? 99 : 33;
      number = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'TASBIH COUNTER',
              style: TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              changeTarget();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber[700],
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: FittedBox(
                    child: Text(
                      '$incrementLimit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FittedBox(
                          child: Text(
                            "Total Count",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        FittedBox(
                          child: Text(
                            maxLines: 1,
                            total.toString(),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const FittedBox(
                                      child: Text(
                                        "Confirm Reset",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    content: const Text(
                                      "Do you want to reset the total tasbih count?",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          resetTotal();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Reset",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: FittedBox(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Reset Total\nCount",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      reset();
                    },
                    child: const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: FittedBox(
                          child: Text(
                            "RESET",
                            style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: width * 0.3,
            height: width * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
              border: Border.all(width: 5, color: Colors.green.shade800),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: FittedBox(
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.08),
            child: Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 5, color: Colors.green.shade800),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () {
                      incrementCounter();
                    },
                    child: Container(
                      width: width * 0.5 * 0.90,
                      height: width * 0.5 * 0.90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
