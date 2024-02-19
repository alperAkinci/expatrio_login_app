import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class TaxDataPage extends StatefulWidget {
  const TaxDataPage({super.key});

  @override
  State<TaxDataPage> createState() => _TaxDataPageState();
}

class _TaxDataPageState extends State<TaxDataPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: use font with bold style
    final titleLargeStyle = Theme.of(context).textTheme.bodyLarge;
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/CryingGirl.svg",
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  "Uh-Oh!",
                  style: titleLargeStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  "We need your tax data in order to access your account",
                  style: titleLargeStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // open a model bottom sheet
                      _showModalBottom(context);
                    },
                    child: const Text("UPDATE YOUR TAX DATA"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<dynamic> _showModalBottom(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              const Text(
                "Declaration of financial information",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "WHICH COUNTRY SERVES AS YOUR PRIMARY TAX RESIDENCE?", // TODO: put *
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  // TODO: Add country
                  DropdownSearch<int>(
                    items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Select country",
                        filled: true,
                      ),
                    ),
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("TAX IDENTIFICATION NUMBER"), // TODO: put *
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'id',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {},
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add),
                      Text("Add another"),
                    ],
                  )),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Checkbox(value: false, onChanged: print),
                  Flexible(
                    child: Text(
                        "I confirm above tax residency and US seld-decleration is true and accurate.",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3),
                  )
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("SAVE"),
              )
            ],
          ),
        );
      },
    );
  }
}
