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
        return const TaxDataModalSheet();
      },
    );
  }
}

class TaxDataModalSheet extends StatefulWidget {
  const TaxDataModalSheet({super.key});

  @override
  State<TaxDataModalSheet> createState() => _TaxDataModalSheet();
}

class _TaxDataModalSheet extends State<TaxDataModalSheet> {
  bool isChecked = false;
  bool isCheckBoxError = false;
  final countryItems =
      ItemDropDown.fromJsonList(CountriesConstants.nationality);
  TextEditingController primaryController = TextEditingController();
  ItemDropDown selectedPrimaryDropDown = ItemDropDown('', '');

  void getData() {
    final taxData =
        Provider.of<TaxDataNotifier>(context, listen: false).taxData;
    selectedPrimaryDropDown = countryItems.firstWhere(
        (element) => element.code == taxData.primaryTaxResidence.country);
    primaryController.text = taxData.primaryTaxResidence.id;
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    primaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                selectedItem: selectedPrimaryDropDown,
                onChanged: (item) => selectedPrimaryDropDown.code = item!.code,
                items: countryItems,
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
                controller: primaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  //labelText: taxData.primaryTaxResidence.id,
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
              Checkbox(
                  isError: isCheckBoxError,
                  side: isCheckBoxError
                      ? null
                      : BorderSide(color: Colors.green, width: 2),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  }),
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
              if (isChecked) {
                Provider.of<TaxDataNotifier>(context, listen: false)
                    .updateTaxData(
                        TaxResidence(
                            country: selectedPrimaryDropDown.code,
                            id: primaryController.text),
                        []).then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Your tax data has been updated! ✅')),
                  );
                });
              } else {
                setState(() {
                  isCheckBoxError = true;
                });
              }
            },
            child: const Text("SAVE"),
          )
        ],
      ),
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
        title: Text(item.label),
      ),
    );
  }
}
