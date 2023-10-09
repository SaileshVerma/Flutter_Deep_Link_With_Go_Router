import 'dart:async';

import 'package:deep_link_app/home_screen.dart';
import 'package:deep_link_app/second_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:io';
import 'package:domain_verification_manager/domain_verification_manager.dart';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp> {
  String _isSupported = 'Unknown';
  String _domainStateVerified = 'Unknown';
  String _domainStateSelected = 'Unknown';
  String _domainStateNone = 'Unknown';

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (await getIsSupported()) {
      getDomainStageVerified();
      getDomainStateSelected();
      getDomainStateNone();
    }
  }

  Future<bool> getIsSupported() async {
    String result;
    bool _supported = false;
    try {
      _supported = await DomainVerificationManager.isSupported;
      result = _supported.toString();
    } on PlatformException {
      result = 'Failed to get getIsSupported';
    }
    if (!mounted) {
      _isSupported = result;
      return _supported;
    }

    setState(() {
      _isSupported = result;
    });

    return _supported;
  }

  Future<void> getDomainStageVerified() async {
    String result;
    try {
      result = (await DomainVerificationManager.domainStageVerified).toString();
    } on PlatformException {
      result = 'Failed to get domainStageVerified';
    }
    if (!mounted) {
      _domainStateVerified = result;
      return;
    }

    setState(() {
      _domainStateVerified = result;
    });
  }

  Future<void> getDomainStateSelected() async {
    String result;
    try {
      result = (await DomainVerificationManager.domainStageSelected).toString();
    } on PlatformException {
      result = 'Failed to get domainStageSelected';
    }
    if (!mounted) {
      _domainStateSelected = result;
      return;
    }

    setState(() {
      _domainStateSelected = result;
    });
  }

  Future<void> getDomainStateNone() async {
    String result;
    try {
      result = (await DomainVerificationManager.domainStageNone).toString();
    } on PlatformException {
      result = 'Failed to get domainStageNone';
    }
    if (!mounted) {
      _domainStateNone = result;
      return;
    }

    setState(() {
      _domainStateNone = result;
    });
  }

  Future<void> domainRequest() async {
    await DomainVerificationManager.domainRequest();
  }

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  StreamSubscription? _sub;

  final _scaffoldKey = GlobalKey();
  // final _cmds = getCmds();
  final _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);

  @override
  void initState() {
    super.initState();
    domainRequest();
    // _handleIncomingLinks();
    // _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<Uri?> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      // _showSnackBar('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          return uri;
        }
        if (!mounted) return uri;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return Uri();
        print('malformed initial uri');
        setState(() => _err = err);
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(_isSupported +
        _domainStateVerified +
        _domainStateSelected +
        _domainStateNone);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adoration Divine',
      theme:
          ThemeData(primaryColor: Colors.red[100], primarySwatch: Colors.red),
      home: FutureBuilder(
        future: _handleInitialUri(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            // our app started by configured links
            var uri = snapshot.data!;
            var list = uri.queryParametersAll.entries
                .toList(); // we retrieve all query parameters , tzd://genius-team.com?product_id=1
            print('@@@@@@@@@@@@@@@@@@@@@@@@@  URI    $uri');
            print('@@@@@@@@@@  DAATTA   URI L ${snapshot.data}');
            for (var i in list) {
              print('## i $i');
            }
            return SecondScreen(); // we just print all //parameters but you can now do whatever you want, for example open //product details page.
          } else {
            // our app started normally
            return MyHomeScreen();
          }
        },
      ),
    );

    // MaterialApp.router(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   routerConfig: router,
    // );
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (ctx, state) => const MyHomeScreen(),
      routes: [
        GoRoute(
          path: 'second',
          builder: (ctx, state) => const SecondScreen(),
        ),
      ],
    ),
  ],
);
