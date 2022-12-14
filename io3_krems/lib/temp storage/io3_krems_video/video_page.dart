import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'video_view/io3_krems_view.dart';
import 'video_bloc/video_bloc.dart';

class IO3KremsRecordVideo extends StatelessWidget {
  const IO3KremsRecordVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IO3KremsVideoBloc()..add(PermissionRequested()),
      child: const Material(child: IO3KremsView()),
    );
  }
}
