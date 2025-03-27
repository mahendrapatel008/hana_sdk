import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_sidebar/dynamic_sidebar_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicSidebar extends StatelessWidget {
  final DynamicSidebarModel model;
  final ValueChanged<int> onItemTap;
  final FormController formController;
  final int selectedIndex;
  final Function(int) onNavigate; // Add this to handle navigation

  const DynamicSidebar({
    super.key,
    required this.model,
    required this.formController,
    required this.onItemTap,
    required this.onNavigate, // Initialize the new parameter
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: model.items?.length ?? 0,
        itemBuilder: (context, index) {
          final item = model.items![index];
          final isSelected = index == selectedIndex;
          return ListTile(
            leading: Container(
              height: model.iconSize ?? 14,
              width: model.iconSize ?? 14,
              margin: EdgeInsets.only(
                  left: model.margin?.left?.toDouble() ?? 0,
                  right: model.margin?.right?.toDouble() ?? 0,
                  top: model.margin?.top?.toDouble() ?? 0,
                  bottom: model.margin?.bottom?.toDouble() ?? 0),
              padding: EdgeInsets.only(
                  left: model.padding?.left?.toDouble() ?? 0,
                  right: model.padding?.right?.toDouble() ?? 0,
                  top: model.padding?.top?.toDouble() ?? 0,
                  bottom: model.padding?.bottom?.toDouble() ?? 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(model.radius?.topLeft.toDouble() ?? 0),
                    topRight:
                        Radius.circular(model.radius?.topRight.toDouble() ?? 0),
                    bottomLeft: Radius.circular(
                        model.radius?.bottomLeft.toDouble() ?? 0),
                    bottomRight: Radius.circular(
                        model.radius?.bottomRight.toDouble() ?? 0),
                  ),
                  color: model.backGroundColor,
                  border: model.showBorder ?? false
                      ? Border.all(
                          color: model.borderColor ??
                              hexToColor("#FFFFFF") ??
                              Colors.black,
                          width: model.borderWidth?.toDouble() ?? 0)
                      : null,
                  image: DecorationImage(
                    fit: model.fit,
                    image: (item.icon ?? '').isEmpty
                        ? const AssetImage('assets/images/Logo.png')
                            as ImageProvider
                        : NetworkImage(item.icon ?? ''),
                  )),
            ),
            title: Text(
              item.label ?? '',
              style: TextStyle(
                color: isSelected
                    ? model.selectedItemColor
                    : model.unselectedItemColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer on selection
              // onItemTap(index); // Update selected index
              onNavigate(index); // Call the navigation function
            },
          );
        },
      ),
    );
  }
}
