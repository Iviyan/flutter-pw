import 'package:flutter/material.dart';

class Screen4 extends StatefulWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Color(0xFF039EA2)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(flex: 4, child: SizedBox()),
            const Text("medinow",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 2
              )
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text("Meditate With Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                )
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            const RoundedButton("Sign in with Apple"),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: RoundedButton("Continue with Email or Phone", color: Color(0xFFCDFDFE)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text("Continue with Google", textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),),
            ),
            const Expanded(flex: 2, child: SizedBox()),
            
            Expanded(flex: 4, child: Padding(
              padding: const EdgeInsets.only(bottom: 26),
                child: Image.asset("assets/screen4/Imgb.png")
              ),
            ),
          ]
        ),
      )
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton(
    this.text, {
    Key? key,
    this.color = Colors.white
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            //padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
              ),
            ),

          ), 
          child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black)),
        ),
      );
  }
}