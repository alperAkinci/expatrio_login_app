import 'package:dropdown_search/dropdown_search.dart';
import 'package:expatrio_login_app/shared/countries_constants.dart';
import 'package:expatrio_login_app/shared/item_dropdown.dart';
import 'package:expatrio_login_app/tax_data/model/tax_data.dart';
import 'package:expatrio_login_app/tax_data/provider/tax_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  ItemDropDown selectedPrimaryItem = ItemDropDown('', '');
  TextEditingController primaryController = TextEditingController();

  List<(ItemDropDown, TextEditingController)> secondaryTaxResidence = [];

  void getData() {
    final taxData =
        Provider.of<TaxDataNotifier>(context, listen: false).taxData;
    selectedPrimaryItem = countryItems
        .firstWhere((item) => item.code == taxData.primaryTaxResidence.country);
    primaryController.text = taxData.primaryTaxResidence.id;

    for (var taxResidence in taxData.secondaryTaxResidence) {
      var item = countryItems
          .firstWhere((element) => element.code == taxResidence.country);
      secondaryTaxResidence
          .add((item, TextEditingController(text: taxResidence.id)));
    }
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    primaryController.dispose();
    for (var item in secondaryTaxResidence) {
      item.$2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        shouldCloseOnMinExtent: true,
        initialChildSize: 0.75,
        snap: true,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  const Text(
                    "Declaration of financial information",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  _buildTaxResidence(
                      selectedItem: selectedPrimaryItem,
                      controller: primaryController),
                  for (var item in secondaryTaxResidence)
                    _buildTaxResidence(
                        selectedItem: item.$1, controller: item.$2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () {
                          setState(() {
                            if (secondaryTaxResidence.isNotEmpty) {
                              secondaryTaxResidence.removeLast();
                            }
                          });
                        },
                        child: Text("- REMOVE")),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          secondaryTaxResidence.add(
                              (ItemDropDown('', ''), TextEditingController()));
                        });
                      },
                      child: Text(
                        "+ ADD ANOTHER",
                      ),
                    ),
                  ),
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
                                    country: selectedPrimaryItem.code,
                                    id: primaryController.text),
                                secondaryTaxResidence
                                    .map((e) => TaxResidence(
                                        country: e.$1.code, id: e.$2.text))
                                    .toList(growable: false))
                            .then((_) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Your tax data has been updated! ✅')),
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
            ),
          );
        });
  }

  Column _buildTaxResidence(
      {required ItemDropDown selectedItem,
      required TextEditingController controller}) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "WHICH COUNTRY SERVES AS YOUR PRIMARY TAX RESIDENCE?", // TODO: put *
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            DropdownSearch<ItemDropDown>(
              selectedItem: selectedItem,
              onChanged: (item) => selectedItem.code = item!.code,
              items: countryItems,
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: "Select country",
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
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: 'Tax ID or N/A',
              ),
            ),
          ],
        )
      ],
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
