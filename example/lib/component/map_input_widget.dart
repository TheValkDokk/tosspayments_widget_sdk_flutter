import 'package:flutter/material.dart';

class MapField {
  TextEditingController keyController;
  TextEditingController valueController;

  MapField({String? key, String? value})
      : keyController = TextEditingController(text: key ?? ""),
        valueController = TextEditingController(text: value ?? "");
}

class MapDataInputWidget extends StatefulWidget {
  final String label;
  const MapDataInputWidget({Key? key, required this.label}) : super(key: key);

  @override
  MapDataInputWidgetState createState() => MapDataInputWidgetState();
}

class MapDataInputWidgetState extends State<MapDataInputWidget> {
  List<MapField> mapFields = [];

  Map<String, String> getMapData() {
    final map = <String, String>{};
    for (var field in mapFields) {
      final key = field.keyController.text;
      final value = field.valueController.text;
      if (key.isNotEmpty) {
        map[key] = value;
      }
    }
    return map;
  }

  @override
  void dispose() {
    for (var field in mapFields) {
      field.keyController.dispose();
      field.valueController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...mapFields.asMap().entries.map((entry) {
          int index = entry.key;
          MapField field = entry.value;
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: field.keyController,
                  decoration: const InputDecoration(
                    labelText: 'Key',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: field.valueController,
                  decoration: const InputDecoration(
                    labelText: 'Value',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    mapFields.removeAt(index);
                  });
                },
              )
            ],
          );
        }).toList(),
        TextButton.icon(
          onPressed: () {
            setState(() {
              mapFields.add(MapField());
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('새 필드 추가'),
        ),
      ],
    );
  }
}