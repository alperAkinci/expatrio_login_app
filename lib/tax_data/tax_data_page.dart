import 'package:dropdown_search/dropdown_search.dart';
import 'package:expatrio_login_app/shared/countries_constants.dart';
import 'package:expatrio_login_app/shared/item_dropdown.dart';
import 'package:expatrio_login_app/tax_data/model/tax_data.dart';
import 'package:expatrio_login_app/tax_data/provider/tax_data_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TaxDataPage extends StatefulWidget {
  const TaxDataPage({super.key});

  @override
  State<TaxDataPage> createState() => _TaxDataPageState();
}

class _TaxDataPageState extends State<TaxDataPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                      Provider.of<TaxDataNotifier>(context, listen: false)
                          .getTaxData()
                          .then((_) {
                        _showModalBottom(context);
                      });
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
        final taxDataNotifier = Provider.of<TaxDataNotifier>(context);
        final items = ItemDropDown.fromJsonList(CountriesConstants.nationality);
        final selectedPrimaryTaxResidence = items.firstWhere((element) =>
            element.key == taxDataNotifier.taxData.primaryTaxResidence.country);
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
                  DropdownSearch<ItemDropDown>(
                    selectedItem: selectedPrimaryTaxResidence,
                    items: items,
                    compareFn: (i, s) => i == s,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "Select country",
                        filled: true,
                      ),
                    ),
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(
                      showSelectedItems: true,
                      showSearchBox: true,
                      itemBuilder: _popupItemBuilder,
                    ),
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
                      labelText: taxDataNotifier.taxData.primaryTaxResidence.id,
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

  Widget _popupItemBuilder(
      BuildContext context, ItemDropDown item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.text),
      ),
    );
  }
}
