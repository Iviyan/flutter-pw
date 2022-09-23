import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  State<Screen3> createState() => _Screen3State();
}

var image = Stack(alignment: Alignment.center, children: [
      Image.asset("assets/screen2/Img1_bg.png"),
      Image.asset("assets/screen2/Img1.png"),
    ]);

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    List<String> filters = ["All", "Bible In a Year", "Dailies", "Minutes", "Noven"];
    String selectedFilter = "All";

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                  child: Row(children: const [
                    Text("Meditate", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    Spacer(),
                    Icon(Icons.search, size: 28)
                    ]),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(thickness: 1, color: Color(0xFFDDDDDD)),
                ),
                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: 
                  filters.mapIndexed((index, filter) => Padding(
                    padding: EdgeInsets.only(right: index == filters.length - 1 ? 0 : 6),
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(filter == selectedFilter ? 0xFF039EA2 : 0xFFE6FeFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: Text(filter, style: TextStyle(
                        color: Color(filter == selectedFilter ? 0xFFFFFFFF : 0xFF039EA2)
                      )),
                    ),
                  )).toList()
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
                  child: MeditationCard("A Song of Moon", "Start with the basics", "9 Sessions", image),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(thickness: 1, color: Color(0xFFDDDDDD)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: MeditationCard("The Sleep Hour", "Asha Mukherjee", "3 Sessions",
                        style: MeditationCardStyle.small, image)),
                      const SizedBox(width: 10),
                      Expanded(child: MeditationCard("Easy on the Mission", "Peter Mach", "5 minutes",
                        style: MeditationCardStyle.small, image)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(thickness: 1, color: Color(0xFFDDDDDD)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: MeditationCard("Relax with Me", "Amanda James", "3 Sessions",
                        style: MeditationCardStyle.small, image)),
                      const SizedBox(width: 10),
                      Expanded(child: MeditationCard("Sun and Energy", "Mitcheal Hui", "5 minutes",
                        style: MeditationCardStyle.small, image)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Divider(thickness: 1, color: Color(0xFFDDDDDD)),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}

enum MeditationCardStyle {
  normal,
  small
}

class MeditationCard extends StatelessWidget {
  const MeditationCard(
    this.name,
    this.info,
    this.value,
    this.image,
    {
    Key? key,
    this.style = MeditationCardStyle.normal
    }) : super(key: key);

  final String name;
  final String info;
  final String value;
  final Widget image;
  final MeditationCardStyle style;
  

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      image,
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Text(name, style: TextStyle(fontSize: style == MeditationCardStyle.normal ? 22 : 16, fontWeight: FontWeight.w700)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        child: Text(info,
          style: style == MeditationCardStyle.normal 
            ? const TextStyle(fontSize:  16)
            : const TextStyle(fontSize:  13, color: Color.fromARGB(127, 0, 0, 0))
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(Icons.favorite_border, size: 18),
          ),
          Text(value, style: const TextStyle(fontSize:  13, color: Color.fromARGB(127, 0, 0, 0))),
          const Spacer(),
          const Text("Start", style: TextStyle(fontSize:  13, color: Color.fromARGB(127, 0, 0, 0))),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 1),
            child: Text(">", style: style == MeditationCardStyle.normal 
              ? const TextStyle(fontSize:  13, color: Color(0xFF1E2B72))
              : const TextStyle(fontSize:  11)
            ),
          )
        ],),
      )
    ]);
  }
}