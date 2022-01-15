import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter_project/model/user_response_model.dart';
import 'package:test_flutter_project/util/constant.dart';

class StoredData extends StatefulWidget {
  const StoredData({Key? key}) : super(key: key);

  @override
  State<StoredData> createState() => _StoredDataState();
}

class _StoredDataState extends State<StoredData> {
  final Box<UserResponse> userResponseBox =
      Hive.box<UserResponse>(HiveConstant.userResponseBox);

  List<UserResponse> userResponseList = [];
  @override
  void initState() {
    print('init called');
    for (int index = 0; index < userResponseBox.length; index++) {
      UserResponse? res = userResponseBox.getAt(index);
      userResponseList.add(res ?? UserResponse());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchbar(),
        Expanded(
          child: ListView.builder(
            itemCount: userResponseList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(userResponseList[index].name!,
                    style: Theme.of(context).textTheme.headline5),
                subtitle: Text(userResponseList[index].company!.name!),
                leading: Text('${index + 1}',
                    style: Theme.of(context).textTheme.headline5),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _searchbar() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (val) {
          print(
              'userResponseList =>${userResponseList.length} userResponseBox -=> ${userResponseBox.length}');
          if (val.length >= 2) {
            setState(() {
              userResponseList = userResponseList
                  .where((UserResponse data) =>
                      data.name!.toLowerCase().contains(val.toLowerCase()))
                  .toList();
            });
          } else {
            setState(() {
              userResponseList = [];
              for (int index = 0; index < userResponseBox.length; index++) {
                UserResponse? res = userResponseBox.getAt(index);
                userResponseList.add(res ?? UserResponse());
              }
            });
          }
        },
      ),
    );
  }
}
