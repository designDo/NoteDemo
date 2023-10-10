// ignore_for_file: avoid_print

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Magic Note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  int? currentIndex;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInformation) {
      print(sizeInformation.deviceScreenType);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: sizeInformation.isDesktop || sizeInformation.isTablet
              ? [
                  const Icon(Icons.search_rounded),
                  const SizedBox(width: 32),
                  const Icon(Icons.more_vert_rounded),
                  const SizedBox(width: 32),
                ]
              : [],
        ),
        drawer: sizeInformation.isMobile
            ? Container(
                width: MediaQuery.of(context).size.width * 0.68,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.search_rounded),
                      title: Text('Search'),
                    ),
                    ListTile(
                      leading: Icon(Icons.more_vert_rounded),
                      title: Text('More'),
                    )
                  ],
                ),
              )
            : null,
        body: sizeInformation.isMobile
            ? HomeListPage(onTap: (index) => onTap(index))
            : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: HomeListPage(
                      onTap: (index) => onTap(index),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DetailPage(
                      index: currentIndex,
                    ),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });

    DeviceScreenType deviceScreenType =
        getDeviceType(MediaQuery.sizeOf(context));
    if (deviceScreenType == DeviceScreenType.mobile) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DetailPage(
          index: index,
        );
      }));
    }
  }
}

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key, required this.onTap});

  final ValueChanged onTap;

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onTap(index);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 3),
                      blurRadius: 10)
                ]),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(),
                const SizedBox(
                  width: 32,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Tirle  $index'), const Text('SubReally')],
                )),
                const Icon(Icons.favorite_border_rounded),
              ],
            ),
          ),
        );
      },
      itemCount: 20,
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, this.index});

  final int? index;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInformation) {
      return Scaffold(
        appBar: sizeInformation.isMobile
            ? AppBar(
                title: const Text('Note Detail'),
              )
            : null,
        body: Container(
          padding: const EdgeInsets.all(32),
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  index == null ? 'Empty note' : 'This is note $index',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  builder: (context, info) {
                    return Text(info.data?.toMap().toString() ?? '');
                  },
                  future: DeviceInfoPlugin().deviceInfo,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
