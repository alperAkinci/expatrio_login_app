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
  int taxResidencelimit = 3;

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
      var item = countryItems.firstWhere(
          (element) => element.code == taxResidence.country,
          orElse: () => ItemDropDown('', ''));
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
    var theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                Text(
                  "Declaration of financial information",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTaxResidence(
                    dropDownHeaderText:
                        "WHICH COUNTRY SERVES AS YOUR PRIMARY TAX RESIDENCE?*",
                    selectedItem: selectedPrimaryItem,
                    controller: primaryController),
                for (var item in secondaryTaxResidence)
                  _buildTaxResidence(
                      dropDownHeaderText: "DO YOU HAVE OTHER TAX RESIDENCES?*",
                      selectedItem: item.$1,
                      controller: item.$2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAddAnotherButton(context),
                    secondaryTaxResidence.isNotEmpty
                        ? TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.error,
                                textStyle: theme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              setState(() {
                                if (secondaryTaxResidence.isNotEmpty) {
                                  secondaryTaxResidence.removeLast();
                                }
                              });
                            },
                            child: const Text("- REMOVE"))
                        : const SizedBox.shrink()
                  ],
                ),
                const SizedBox(height: 20),
                _buildCheckBox(context),
                const SizedBox(height: 20),
                _buildSaveButton(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        //}),
      ),
    );
  }

  TextButton _buildAddAnotherButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () {
        if (secondaryTaxResidence.length < taxResidencelimit) {
          setState(() {
            secondaryTaxResidence
                .add((ItemDropDown('', ''), TextEditingController()));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "You can only add up to $taxResidencelimit secondary tax residences"),
            ),
          );
        }
      },
      child: const Text(
        "+ ADD ANOTHER",
      ),
    );
  }

  SizedBox _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: FilledButton(
        onPressed: () {
          if (isChecked) {
            Provider.of<TaxDataNotifier>(context, listen: false)
                .updateTaxData(
                    TaxResidence(
                        country: selectedPrimaryItem.code,
                        id: primaryController.text),
                    secondaryTaxResidence
                        .map((e) =>
                            TaxResidence(country: e.$1.code, id: e.$2.text))
                        .toList(growable: false))
                .then((_) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Your tax data has been updated! ✅')),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            });
          } else {
            setState(() {
              isCheckBoxError = true;
            });
          }
        },
        child: const Text("SAVE"),
      ),
    );
  }

  Row _buildCheckBox(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
            isError: isCheckBoxError,
            side: isCheckBoxError
                ? null
                : const BorderSide(color: Colors.green, width: 2),
            activeColor: Theme.of(context).colorScheme.secondary,
            checkColor: Colors.white,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            }),
        const Flexible(
          child: Text(
              "I confirm above tax residency and US seld-decleration is true and accurate.",
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3),
        )
      ],
    );
  }

  Column _buildTaxResidence(
      {required String dropDownHeaderText,
      required ItemDropDown selectedItem,
      required TextEditingController controller}) {
    Future<List<ItemDropDown>> getFilteredItems() async {
      List<ItemDropDown> filteredCountryItems = [];
      filteredCountryItems = List.from(countryItems);
      // Remove all the items that are already selected
      filteredCountryItems
          .removeWhere((element) => element.code == selectedPrimaryItem!.code);
      for (var item in secondaryTaxResidence) {
        filteredCountryItems
            .removeWhere((element) => element.code == item.$1.code);
      }
      // Add the selected item to the list
      if (selectedItem.code.isNotEmpty) {
        filteredCountryItems.add(selectedItem);
        filteredCountryItems.sort((a, b) => a.label.compareTo(b.label));
      }

      return filteredCountryItems;
    }

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(dropDownHeaderText,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            DropdownSearch<ItemDropDown>(
              onBeforePopupOpening: (selectedItem) async {
                FocusManager.instance.primaryFocus?.unfocus();
                return true;
              },
              selectedItem: selectedItem,
              onChanged: (item) {
                selectedItem.label = item!.label;
                selectedItem.code = item!.code;
              },
              asyncItems: (_) => getFilteredItems(),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                baseStyle: const TextStyle(height: 0.7),
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: "Select country",
                ),
              ),
              popupProps: PopupPropsMultiSelection.modalBottomSheet(
                searchFieldProps: TextFieldProps(
                  style: const TextStyle(height: 0.7),
                  decoration: InputDecoration(
                    hintText: 'Search for country',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                title: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Text('Country',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                ),
                showSelectedItems: true,
                showSearchBox: true,
                itemBuilder: _popupItemBuilder,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("TAX IDENTIFICATION NUMBER*",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            TextFormField(
              style: const TextStyle(height: 0.7),
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: 'Tax ID or N/A',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
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
