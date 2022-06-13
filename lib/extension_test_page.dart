import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var defaultTextStyle = DefaultTextStyle.of(context);
    print(defaultTextStyle.style.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'This is a text with color styled',
            //   style: TextStyle(color: Colors.brown),
            // ),
            // const Text(
            //   'This is a text with color styled',
            //   style: TextStyle(color: Colors.brown),
            // ).setOpacity(context, 0.7),
            const Text(
              'This is a text with no style given',
            ),
            const Text(
              'This is a text with no style given',
            ).setOpacity(context, 0.3)
          ],
        ),
      ),
    );
  }
}

extension TextModifier on Text {
  Text setOpacity(BuildContext context, double opacity) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }

    if (style == null) {
      Color opaqueColor = effectiveTextStyle!.color!.withOpacity(opacity);

      return Text(
        data!,
        style: defaultTextStyle.style.copyWith(color: opaqueColor),
      );
    } else {
      Color opaqueColor = style!.color!.withOpacity(opacity);

      return Text(
        data!,
        style: style!.copyWith(color: opaqueColor),
      );
    }
  }
}
