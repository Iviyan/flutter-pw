import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(36)),
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset("assets/screen2/Img1_bg.png"),
                    Image.asset("assets/screen2/Img1.png"),
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Peter Mach",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(127, 0, 0, 0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                    )
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text("Mind Deep Relax",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                    )
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 16),
                  child: Text("Join the Community as we prepare over 33 days to relax and feel joy with the mind and happnies session across the World.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    )
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color(0xFF039ea2)),
                      //padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                        ),
                      )
                    ), 
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Text("▷  ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600 )),
                      ),
                      Text("Play Next Session", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 )),
                    ]),
                  ),
                ),
      
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: MusicElement("Sweet Memories", "December 29 Pre-Launch", color: Color(0xFF2F80ED)),
                ),
                const Divider(thickness: 1, color: Color(0xFFDDDDDD)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: MusicElement("A Day Dream", "December 29 Pre-Launch", color: Color(0xFF039EA2)),
                ),
                const Divider(thickness: 1, color: Color(0xFFDDDDDD)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: MusicElement("Mind Explore", "December 29 Pre-Launch", color: Color(0xFFF09235)),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}

class MusicElement extends StatelessWidget {
  const MusicElement(
    this.name,
    this.info, {
    Key? key,
    this.color = const Color(0xFF2F80ED)
    }) : super(key: key);

  final String name;
  final String info;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        height: 42,
        width: 42,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 0, left: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color
        ),
        child: const Text("▷",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
      ),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          Text(info, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Color.fromARGB(127, 0, 0, 0)))
        ],),
      )),
      PopupMenuButton(
        itemBuilder: (BuildContext context) => [],
        icon: const Icon(Icons.more_horiz, size: 30, color: Color(0xFFBBBBBB)),
      )
    ]);
  }
}