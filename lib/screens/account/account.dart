import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import '../../components/text_widget.dart';


class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppThemeClass.whiteText,
          body: Center(child: CustomText(text: "Model Screen"),),
    ));
  }
}
