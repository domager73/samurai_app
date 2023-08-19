import 'package:flutter/material.dart';

class HerosPageTab extends StatefulWidget {
  const HerosPageTab({super.key, required this.wigetChild});

  final Widget wigetChild;

  @override
  State<HerosPageTab> createState() => _HerosPageTabState();
}

class _HerosPageTabState extends State<HerosPageTab>
    with SingleTickerProviderStateMixin {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
        radius: const Radius.circular(36),
        thumbColor: const Color(0xFF00FFFF),
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
            controller: scrollController, child: widget.wigetChild));
  }
}
