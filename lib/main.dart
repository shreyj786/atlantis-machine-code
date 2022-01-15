import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_flutter_project/bloc/user_bloc.dart';
import 'package:test_flutter_project/bloc/user_state.dart';
import 'package:test_flutter_project/model/user_response_model.dart';
import 'package:test_flutter_project/screens/list_screen.dart';
import 'package:test_flutter_project/screens/notification_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:test_flutter_project/screens/stored_data.dart';
import 'package:test_flutter_project/util/constant.dart';

// 1. call API using BLOC --done
// 2. get data from API --done
// 3. show data to user  --done
// 4. handle loading --done
// 5. save data to local storage  --done
// 6. get data from local storage  --done
// 7. search list --done
// 8. generate notification in the notification tray --done

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory directory;

  if (Platform.isAndroid) {
    directory = await path_provider.getApplicationDocumentsDirectory();
  } else {
    directory = await path_provider.getTemporaryDirectory();
  }
  Hive.init(directory.path);

//register adapters

  Hive.registerAdapter(UserResponseAdapter());
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(GeoAdapter());
  Hive.registerAdapter(CompanyAdapter());

  //open box
  await Hive.openBox<UserResponse>(HiveConstant.userResponseBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(UserInitialState()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Test Flutter Project'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    IOSInitializationSettings iOSSettings = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    InitializationSettings initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    FlutterLocalNotificationsPlugin().initialize(
      initSetttings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text('Search'),
                ),
                Tab(
                  child: Text('Notification'),
                ),
                Tab(
                  child: Text('Stored Data'),
                ),
              ],
            ),
            title: Text(widget.title),
          ),
          body: const TabBarView(
            children: [ListScreen(), NotificationScreen(), StoredData()],
          ),
        ),
      ),
    );
  }
}
