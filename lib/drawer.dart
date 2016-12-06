// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({ TextStyle style, String url, String text }) : super(
    style: style,
    text: text ?? url,
    recognizer: new TapGestureRecognizer()..onTap = () {
      UrlLauncher.launch(url);
    }
  );
}

class GalleryDrawerHeader extends StatefulWidget {
  const GalleryDrawerHeader({ Key key }) : super(key: key);

  @override
  _GalleryDrawerHeaderState createState() => new _GalleryDrawerHeaderState();
}

class _GalleryDrawerHeaderState extends State<GalleryDrawerHeader> {
  bool _logoHasName = true;
  bool _logoHorizontal = true;
  Map<int, Color> _swatch = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final double systemTopPadding = MediaQuery.of(context).padding.top;

    return new DrawerHeader(
      decoration: new FlutterLogoDecoration(
        margin: new EdgeInsets.fromLTRB(12.0, 12.0 + systemTopPadding, 12.0, 12.0),
        style: _logoHasName ? _logoHorizontal ? FlutterLogoStyle.horizontal
                                              : FlutterLogoStyle.stacked
                                              : FlutterLogoStyle.markOnly,
        swatch: _swatch,
        textColor: const Color(0xFF616161), // : const Color(0xFF9E9E9E),
      ),
      duration: const Duration(milliseconds: 750),
      child: new GestureDetector(
        onLongPress: () {
          setState(() {
            _logoHorizontal = !_logoHorizontal;
            if (!_logoHasName)
              _logoHasName = true;
          });
        },
        onTap: () {
          setState(() {
            _logoHasName = !_logoHasName;
          });
        },
        onDoubleTap: () {
          setState(() {
            final List<Map<int, Color>> options = <Map<int, Color>>[];
            if (_swatch != Colors.blue)
              options.addAll(<Map<int, Color>>[Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue]);
            if (_swatch != Colors.amber)
              options.addAll(<Map<int, Color>>[Colors.amber, Colors.amber, Colors.amber]);
            if (_swatch != Colors.red)
              options.addAll(<Map<int, Color>>[Colors.red, Colors.red, Colors.red]);
            if (_swatch != Colors.indigo)
              options.addAll(<Map<int, Color>>[Colors.indigo, Colors.indigo, Colors.indigo]);
            if (_swatch != Colors.pink)
              options.addAll(<Map<int, Color>>[Colors.pink]);
            if (_swatch != Colors.purple)
              options.addAll(<Map<int, Color>>[Colors.purple]);
            if (_swatch != Colors.cyan)
              options.addAll(<Map<int, Color>>[Colors.cyan]);
            _swatch = options[new math.Random().nextInt(options.length)];
          });
        }
      )
    );
  }
}

class MainDrawer extends StatelessWidget {
  MainDrawer({
    Key key,
    this.showPerformanceOverlay,
    this.onShowPerformanceOverlayChanged,
    this.checkerboardRasterCacheImages,
    this.onCheckerboardRasterCacheImagesChanged,
    this.onPlatformChanged,
  }) : super(key: key) {
  }

  final bool showPerformanceOverlay;
  final ValueChanged<bool> onShowPerformanceOverlayChanged;

  final bool checkerboardRasterCacheImages;
  final ValueChanged<bool> onCheckerboardRasterCacheImagesChanged;

  final ValueChanged<TargetPlatform> onPlatformChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    final Widget mountainViewItem = new DrawerItem(
      // on iOS, we don't want to show an Android phone icon
      icon: new Icon(defaultTargetPlatform == TargetPlatform.iOS ? Icons.star : Icons.phone_android),
      onPressed: () { onPlatformChanged(TargetPlatform.android); },
      selected: Theme.of(context).platform == TargetPlatform.android,
      child: new Row(
        children: <Widget>[
          new Expanded(child: new Text('Android')),
          new Radio<TargetPlatform>(
            value: TargetPlatform.android,
            groupValue: Theme.of(context).platform,
            onChanged: onPlatformChanged,
          )
        ]
      )
    );

    final Widget cupertinoItem = new DrawerItem(
      // on iOS, we don't want to show the iPhone icon
      icon: new Icon(defaultTargetPlatform == TargetPlatform.iOS ? Icons.star_border : Icons.phone_iphone),
      onPressed: () { onPlatformChanged(TargetPlatform.iOS); },
      selected: Theme.of(context).platform == TargetPlatform.iOS,
      child: new Row(
        children: <Widget>[
          new Expanded(child: new Text('iOS')),
          new Radio<TargetPlatform>(
            value: TargetPlatform.iOS,
            groupValue: Theme.of(context).platform,
            onChanged: onPlatformChanged,
          )
        ]
      )
    );

    final Widget fileAnIssueItem = new DrawerItem(
      icon: new Icon(Icons.report),
      onPressed: () {
        UrlLauncher.launch('https://github.com/flutter/flutter/issues/new');
      },
      child: new Text('File an issue')
    );

    final Widget aboutItem = new AboutDrawerItem(
      icon: new FlutterLogo(),
      applicationVersion: '2016 Q3 Preview',
      applicationIcon: new FlutterLogo(),
      applicationLegalese: '© 2016 The Chromium Authors',
      aboutBoxChildren: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: new RichText(
            text: new TextSpan(
              children: <TextSpan>[
                new TextSpan(
                  style: aboutTextStyle,
                  text: "Flutter is an early-stage, open-source project to help "
                  "developers build high-performance, high-fidelity, mobile "
                  "apps for iOS and Android from a single codebase. This "
                  "gallery is a preview of Flutter's many widgets, behaviors, "
                  "animations, layouts, and more. Learn more about Flutter at "
                ),
                new LinkTextSpan(
                  style: linkStyle,
                  url: 'https://flutter.io'
                ),
                new TextSpan(
                  style: aboutTextStyle,
                  text: ".\n\nTo see the source code for this app, please visit the "
                ),
                new LinkTextSpan(
                  style: linkStyle,
                  url: 'https://goo.gl/iv1p4G',
                  text: 'flutter github repo'
                ),
                new TextSpan(
                  style: aboutTextStyle,
                  text: "."
                )
              ]
            )
          )
        )
      ]
    );

    final List<Widget> allDrawerItems = <Widget>[
      new GalleryDrawerHeader(),
      mountainViewItem,
      cupertinoItem,
      new Divider(),
      fileAnIssueItem,
      aboutItem
    ];

    return new Drawer(child: new Block(children: allDrawerItems));
  }
}
