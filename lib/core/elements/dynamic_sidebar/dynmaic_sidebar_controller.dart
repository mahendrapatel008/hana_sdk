import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_sidebar/dynamic_sidebar.dart';
import 'package:hana_sdk/core/elements/dynamic_sidebar/dynamic_sidebar_model.dart';
import 'package:hana_sdk/screens/dynamic_form_page/dynamic_page.dart';

class SidebarPage extends StatefulWidget {
  final DynamicSidebarModel model;
  final FormController formController;

  const SidebarPage({
    super.key,
    required this.model,
    required this.formController,
  });

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  late List<Widget> _spages;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _spages = _generatePages();
  }

  List<Widget> _generatePages() {
    return widget.model.items!.map((item) {
      String pageName = item.onClickData?.pageName ?? 'home';
      return DynamicFormScreen(
        formController: widget.formController,
        key: ValueKey(pageName), // Unique key for each page
        pageName: pageName,
        token: '1',
        context: context,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool containsAllPrerequisites = false;
    if (widget.model.isHideAndShow ?? false) {
      containsAllPrerequisites = widget.model.prerequisite != null &&
          widget.model.prerequisite!.every((prerequisite) => widget
              .formController.savePrerequisitesNameData
              .contains(prerequisite.name));
    }
    return !containsAllPrerequisites
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Dynamic Sidebar Example'),
            ),
            drawer: DynamicSidebar(
              formController: widget.formController,
              model: widget.model,
              selectedIndex: _selectedIndex,
              onItemTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  _spages = _generatePages(); // Refresh pages on tap
                });
              },
              onNavigate: (int) {},
            ),
            body: _spages[_selectedIndex],
          )
        : SizedBox.shrink();
  }
}
