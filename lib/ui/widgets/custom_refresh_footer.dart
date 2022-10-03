import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qnpick/constants/constants.dart';

class CustomRefreshFooter extends StatelessWidget {
  const CustomRefreshFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        late Widget body;

        switch (mode) {
          case LoadStatus.idle:
            body = const SizedBox.shrink();
            break;
          case LoadStatus.loading:
            body = const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Center(
                  child: CircularProgressIndicator(color: brightPrimaryColor)),
            );
            break;
          default:
            body = const SizedBox.shrink();
            break;
        }
        return body;
      },
      loadStyle: LoadStyle.ShowWhenLoading,
    );
  }
}
