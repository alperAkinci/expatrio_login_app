import 'package:expatrio_login_app/tax_data/presentation/tax_data_modal_sheet.dart';
import 'package:expatrio_login_app/tax_data/provider/tax_data_notifier.dart';
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
    var textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/CryingGirl.svg",
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  "Uh-Oh!",
                  style: titleStyle,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    "We need your tax data in order to access your account",
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
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
