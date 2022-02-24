import 'package:flutter/material.dart';
import 'package:flutter_slide_competition/dev/ui/utils/my_utils.dart';

class UnitTestMenu extends StatelessWidget {
  const UnitTestMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MyUtils.setScreenPadding(context: context),
        child: Center(
          child: Column(
            children: [
              // ElevatedButton(
              //   onPressed: () => Navigator.of(context).pushNamed('/bag_test'),
              //   child: Text('Sound Bag Test'),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // ElevatedButton(
              //   onPressed: () => Navigator.of(context).pushNamed('/board_test'),
              //   child: Text('Board Test'),
              // ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/complete_test'),
                child: Text('Sound Game Test'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/spatial_test'),
                child: Text('Spatial Game Test'),
              ),
              const SizedBox(
                height: 20,
              ),
              // ElevatedButton(
              //   onPressed: () => Navigator.of(context).pushNamed('/ui_test'),
              //   child: Text('UI Test'),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/welcome'),
                child: Text('Complete puzzle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
