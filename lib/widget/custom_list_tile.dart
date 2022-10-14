import 'package:flutter/material.dart';

class DomainSpecificInfo extends StatelessWidget {
  final Icon icon;
  final String title;
  final String? subtitle;
  final bool isTitle;

  static const styleTextTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  static const styleTextSubTitle = TextStyle(
    color: Colors.black45,
    fontSize: 18,
  );
  static const styleDefaultText = TextStyle(
    color: Colors.black45,
  );

  const DomainSpecificInfo({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.isTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          isTitle ? const EdgeInsets.symmetric(horizontal: 0) : null,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTitle ? 35 : null,
        ),
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                subtitle!,
                style: isTitle ? styleTextSubTitle : styleDefaultText,
              ),
            )
          : null,
    );
  }
}
