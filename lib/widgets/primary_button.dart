import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.onPressed, required this.text, this.prefixIcon});

  final void Function() onPressed;
  final String text;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    double screenWith = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fixedSize: Size.fromWidth(screenWith),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(prefixIcon!=null)
            Padding(padding: const EdgeInsets.only(right: 10)
                ,child: Icon(prefixIcon, color: Colors.white,)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,fontStyle: FontStyle.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}
