import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter_project/bloc/user_bloc.dart';
import 'package:test_flutter_project/bloc/user_event.dart';
import 'package:test_flutter_project/bloc/user_state.dart';
import 'package:test_flutter_project/model/user_response_model.dart';
import 'package:test_flutter_project/util/constant.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Box<UserResponse> userResponseBox =
      Hive.box<UserResponse>(HiveConstant.userResponseBox);

  @override
  void initState() {
    if (userResponseBox.isNotEmpty) {
      userResponseBox.clear();
    }
    BlocProvider.of<UserBloc>(context).add(GetUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is GetUserState) {
          return _handleUserResponseList(state);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _handleUserResponseList(state) {
    var _userState = state as GetUserState;

    switch (_userState.status) {
      case ApiStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ApiStatus.success:
        if (state.response != null) {
          return ListView.builder(
            itemCount: state.response!.length,
            itemBuilder: (BuildContext context, int index) {
              UserResponse res = state.response![index];

              userResponseBox.add(res);

              return ListTile(
                title: Text(res.name!,
                    style: Theme.of(context).textTheme.headline5),
                subtitle: Text(res.company!.name!),
                leading: Text('${index + 1}'),
              );
            },
          );
        } else {
          return const Center(child: Text('No data avaiable at this time'));
        }

      case ApiStatus.failed:
        const SnackBar(
            content: Text('Unable to connect please try again later'));
        return const Center(child: Text('No data avaiable at this time'));
    }
  }
}
