import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dock(
                iconDataStringMap: const {
                  "Contacts": Icons.person,
                  "Messages": Icons.message,
                  "Call": Icons.call,
                  "Camera": Icons.camera,
                  "Gallery": Icons.photo,
                },
                builder: (iconData, iconName) {
                  return Tooltip(
                    message: iconName,
                    textStyle: const TextStyle(color: Colors.black),
                    child: GestureDetector(
                      onTap: () {
                        debugPrint(iconName);
                      },
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 48),
                        height: 48,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.primaries[
                              iconData.hashCode % Colors.primaries.length],
                        ),
                        child: Center(
                          child: Icon(iconData, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dock extends StatefulWidget {
  const Dock({
    super.key,
    required this.builder,
    required this.iconDataStringMap,
  });

  final Widget Function(IconData, String) builder;
  final Map<String, IconData> iconDataStringMap;

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  bool _isDragging = false;
  String? _draggingIconName;
  bool dragIcons = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.iconDataStringMap.entries.toList();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),
          padding: const EdgeInsets.all(4),
          width: _isDragging ? 270 : 330,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: items.map((entry) {
                return Draggable<IconData>(
                  data: entry.value,
                  feedback: Material(
                    color: Colors.transparent,
                    child: widget.builder(entry.value, entry.key),
                  ),
                  childWhenDragging: const Opacity(opacity: 0.3),
                  child: widget.builder(entry.value, entry.key),
                  onDragStarted: () {
                    setState(() {
                      _isDragging = true;
                      _draggingIconName = entry.key;
                    });
                  },
                  onDragEnd: (details) {
                    setState(() {
                      _isDragging = false;
                      _draggingIconName = null;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        if (_isDragging && _draggingIconName != null)
          Positioned(
            top: -40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _draggingIconName!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
