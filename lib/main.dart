import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gloomhaven Turn Order',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gloomhaven Turn Order'),
    );
  }
}

class Marker {
  final String text;
  final Color color;

  Marker(this.text, this.color);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Marker> markers = [];
  Color selectedColor = Colors.orange.shade100;

  void _showInputDialog() {
    TextEditingController textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Marker hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textEditingController,
                decoration: const InputDecoration(hintText: "z.b. Banditenwache"),
              ),
              const SizedBox(height: 10),
              // Color picker button
              ElevatedButton(
                onPressed: _showColorPicker,
                child: const Text('Marker-Farbe wählen'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zurück'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                setState(() {
                  markers.add(Marker(textEditingController.text, selectedColor));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wähle eine Farbe'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zurück'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMarker(Marker marker) {
    return Container(
      key: ValueKey(marker.text),  // Add a key to each marker for ReorderableListView
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: marker.color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            marker.text,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white, // Set text color to white for contrast
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                markers.remove(marker);
              });
            },
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Marker item = markers.removeAt(oldIndex);
      markers.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: ReorderableListView(
        onReorder: _onReorder,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          for (final marker in markers) _buildMarker(marker),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInputDialog,
        tooltip: 'Marker hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}