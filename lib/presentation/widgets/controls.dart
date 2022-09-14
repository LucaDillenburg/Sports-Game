import 'dart:math';

import 'package:flutter/material.dart';

const _white = Color(0xccffffff);

class Joypad extends StatefulWidget {
  final Function(Offset offset) onChanged;
  const Joypad({required this.onChanged});

  @override
  JoypadState createState() => JoypadState();
}

class JoypadState extends State<Joypad> {
  Offset delta = Offset.zero;

  static const _maxDelta = 30.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
        ),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x88ffffff),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Transform.translate(
                offset: delta,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onPanDown: onDragDown,
          onPanUpdate: onDragUpdate,
          onPanEnd: onDragEnd,
        ),
      ),
    );
  }

  void updateDelta(Offset newDelta) {
    final normalizedDelta = newDelta / _maxDelta;
    assert(normalizedDelta.distance.abs() <= 1.01);
    widget.onChanged(normalizedDelta);

    setState(() {
      delta = newDelta;
    });
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }

  void calculateDelta(Offset offset) {
    final newDelta = offset - const Offset(60, 60);
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(30, newDelta.distance),
      ),
    );
  }
}

class GameButton extends StatefulWidget {
  final Function(Duration pressedDuration) onTap;
  final String name;
  final double size;
  const GameButton({
    required this.onTap,
    required this.name,
    required this.size,
  });

  @override
  GameButtonState createState() => GameButtonState();
}

class GameButtonState extends State<GameButton> {
  var _tapped = false;
  DateTime? _pressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _tapped = true;
        });
        _pressed = DateTime.now();
      },
      onTapUp: (_) {
        setState(() {
          _tapped = false;
        });
        final pressed = _pressed;
        widget.onTap(DateTime.now().difference(pressed!));
      },
      onTapCancel: () {
        setState(() {
          _tapped = false;
        });
        _pressed = null;
      },
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _tapped ? Colors.white : _white,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Text(
                'P',
                style: TextStyle(
                  fontSize: 40,
                  color: _tapped ? Colors.grey[400] : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
