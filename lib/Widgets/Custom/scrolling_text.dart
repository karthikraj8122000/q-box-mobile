import 'package:flutter/material.dart';

class ScrollingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double speed;

  const ScrollingText({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 24, color: Colors.white),
    this.speed = 50,
  });

  @override
  _ScrollingTextState createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  late ScrollController _scrollController;
  late double _scrollPosition = 0;
  late double _maxScrollExtent = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maxScrollExtent = _scrollController.position.maxScrollExtent;
      _startScrolling();
    });
  }

  void _startScrolling() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return false;

      _scrollPosition += widget.speed / 10;
      if (_scrollPosition > _maxScrollExtent) {
        _scrollPosition = 0;
      }
      _scrollController.jumpTo(_scrollPosition);
      return true;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text(widget.text, style: widget.style),
              const SizedBox(width: 100), // Gap between repetitions
            ],
          );
        },
      ),
    );
  }
}

