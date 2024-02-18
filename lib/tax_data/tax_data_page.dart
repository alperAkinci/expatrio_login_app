import 'package:flutter/material.dart';

class TaxDataPage extends StatefulWidget {
  const TaxDataPage({super.key});

  @override
  State<TaxDataPage> createState() => _TaxDataPageState();
}

class _TaxDataPageState extends State<TaxDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tax Data Page"),
      ),
      body: const Placeholder(),
    );
  }
}
