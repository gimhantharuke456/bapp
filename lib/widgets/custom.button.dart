import 'package:bapp/app.styles.dart';
import 'package:bapp/services/color.manager.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.black, // Default text color
    this.width, // Default to null, will use container's constraints if not specified
    this.height = 50.0, // Default height
    this.borderRadius = 4.0, // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = AppStyles().primaryColor();
    return FutureBuilder<int?>(
        future: ColorManager().prefferedColor(),
        builder: (context, AsyncSnapshot<int?> snapshot) {
          return Container(
            width: width ?? MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                textStyle:
                    TextStyle(color: textColor, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              onPressed: onPressed,
              child: Text(text, style: TextStyle(color: textColor)),
            ),
          );
        });
  }
}
