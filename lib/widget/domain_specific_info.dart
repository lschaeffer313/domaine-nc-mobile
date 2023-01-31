import 'package:flutter/material.dart';

class DomainSpecificInfo extends StatelessWidget {
  final Icon icon;
  final String title;
  final String? subtitle;

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
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: null,
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: null,
        ),
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                subtitle!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
          : null,
    );
  }
}
