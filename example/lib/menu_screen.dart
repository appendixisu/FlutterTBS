import 'package:example/examples/simple_turn_base_example.dart';
import 'package:flutter/material.dart';

class ExampleMenuScreen extends StatelessWidget {
  const ExampleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            buildCard(
              'SimpleTurnBaseExample',
              'simple_turn_base_example.dart',
              const SimpleTurnBaseExample(),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildCard(
      String title,
      String fileName,
      Widget example,
      ) {
    return Builder(
        builder: (context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(title),
              subtitle: Text(fileName),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(title),
                      ),
                      body: example,
                    ),
                  ),
                );
              },
            ),
          );
        }
    );
  }
}
