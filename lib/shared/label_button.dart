import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final String label;
  final String icon;
  final Function() onTap;
  const LabelButton(
      {Key? key, required this.label, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 36,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

class GredientButton extends StatelessWidget {
  const GredientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff54b02f),Color(0xff007633), ])),
    );
  }
}
