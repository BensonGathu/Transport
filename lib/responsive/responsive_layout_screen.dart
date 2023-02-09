import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:transportapp/utils/global_variables.dart';


class ResponsiveLayoutPage extends StatefulWidget {
  final Widget webPageLayout;
  final Widget mobilePageLayout;

  const ResponsiveLayoutPage(
      {super.key, required this.webPageLayout, required this.mobilePageLayout});

  @override
  State<ResponsiveLayoutPage> createState() => _ResponsiveLayoutPageState();
}

class _ResponsiveLayoutPageState extends State<ResponsiveLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webPageLayout;
      }
      return widget.mobilePageLayout;
    });
  }
}
