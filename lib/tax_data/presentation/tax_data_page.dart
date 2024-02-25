import 'package:dropdown_search/dropdown_search.dart';
import 'package:expatrio_login_app/shared/countries_constants.dart';
import 'package:expatrio_login_app/shared/item_dropdown.dart';
import 'package:expatrio_login_app/tax_data/model/tax_data.dart';
import 'package:expatrio_login_app/tax_data/presentation/tax_data_modal_sheet.dart';
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
