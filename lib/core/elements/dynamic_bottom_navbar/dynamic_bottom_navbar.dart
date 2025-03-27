
import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_bottom_navbar/dynamic_bottom_navbar_model.dart';
import 'package:hana_sdk/core/elements/dynamic_sidebar/dynamic_sidebar.dart';
import 'package:hana_sdk/core/elements/dynamic_sidebar/dynamic_sidebar_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:hana_sdk/screens/dynamic_form_page/dynamic_page.dart';

class BottomNavbarPageWrapper extends StatefulWidget {
  final DynamicBottomNavModel? bottomNavModel;
  final DynamicSidebarModel? sideNavModel;
  final FormController formController;
  final int? initialSelectedIndex;

  const BottomNavbarPageWrapper({
    super.key,
    this.bottomNavModel,
    this.sideNavModel,
    required this.formController,
    this.initialSelectedIndex = 0,
  });

  @override
  State<BottomNavbarPageWrapper> createState() =>
      _BottomNavbarPageWrapperState();
}

class _BottomNavbarPageWrapperState extends State<BottomNavbarPageWrapper> {
  int selectedSidebarIndex;
  int selectedBottomNavIndex = 0;
  late List<Widget>? sidebarPages;
  late List<Widget>? bottomNavPages;

  _BottomNavbarPageWrapperState() : selectedSidebarIndex = 0;

  @override
  void initState() {
    super.initState();
    sidebarPages = _generateSidebarPages();
    bottomNavPages = _generateBottomNavPages();
  }

  List<Widget>? _generateSidebarPages() {
    return widget.sideNavModel?.items?.map((item) {
      String pageName = item.onClickData?.pageName ?? 'home';
      return DynamicFormScreen(
        key: ValueKey(pageName),
        pageName: pageName,
        token: '1',
      );
    }).toList();
  }

  List<Widget>? _generateBottomNavPages() {
    return widget.bottomNavModel?.items?.map((navItem) {
      String pageName = navItem.onClickData?.pageName ?? 'home';
      return DynamicFormScreen(
        key: ValueKey(pageName),
        pageName: pageName,
        token: '1',
      );
    }).toList();
  }

  void _onSidebarItemTap(int index) {
    setState(() {
      selectedSidebarIndex = index;
      selectedBottomNavIndex = 0; // Reset bottom nav when sidebar changes
    });
  }

  void _onBottomNavItemTap(int index) {
    setState(() {
      selectedBottomNavIndex = index;
    });
  }

  void _navigateToPage(int index) {
    // Navigate to the appropriate page based on the selected index
    String pageName =
        widget.sideNavModel?.items?[index].onClickData?.pageName ?? 'home';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return DynamicFormScreen(
          pageName: pageName,
          token: '1',
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.sideNavModel?.showSideBarAt != null &&
              (widget.sideNavModel?.showSideBarAt ?? '').isNotEmpty
          ? widget.sideNavModel?.showSideBarAt == 'All'
              ? AppBar(
                  backgroundColor: Colors.transparent,
                )
              : (widget.sideNavModel!.showSideBarAt ?? '')
                      .split(',')
                      .map((e) => e.trim())
                      .contains(selectedBottomNavIndex.toString())
                  ? AppBar(backgroundColor: Colors.transparent)
                  : null
          : null,

      // appBar: widget.sideNavModel?.showSideBarAt != null &&
      //         (widget.sideNavModel?.showSideBarAt ?? '').isNotEmpty
      //     ? widget.sideNavModel?.showSideBarAt == 'All'
      //         ? AppBar()
      //         : selectedBottomNavIndex ==
      //                 int.parse(widget.sideNavModel?.showSideBarAt ?? '')
      //             ? AppBar()
      //             : null
      //     : null,
      drawer: widget.sideNavModel != null
          ? DynamicSidebar(
              model: widget.sideNavModel!,
              formController: widget.formController,
              selectedIndex: selectedSidebarIndex,
              onItemTap: _onSidebarItemTap,
              onNavigate: _navigateToPage, // Pass the navigation function
            )
          : null,
      body: bottomNavPages != null
          ? bottomNavPages![selectedBottomNavIndex]
          : sidebarPages![selectedSidebarIndex],
      bottomNavigationBar: selectedSidebarIndex == 0 && bottomNavPages != null
          ? BottomNavigationBar(
              elevation: 30,
              type: widget.bottomNavModel?.bottomNavigationBarType,
              unselectedLabelStyle:
                  TextStyle(color: widget.bottomNavModel?.unselectedLabelColor),
              items: widget.bottomNavModel!.items!.map((navItem) {
                return BottomNavigationBarItem(
                  icon: Container(
                    height: widget.bottomNavModel?.iconSize ?? 14,
                    width: widget.bottomNavModel?.iconSize ?? 14,
                    margin: EdgeInsets.only(
                        left: widget.bottomNavModel?.margin?.left?.toDouble() ??
                            0,
                        right:
                            widget.bottomNavModel?.margin?.right?.toDouble() ??
                                0,
                        top:
                            widget.bottomNavModel?.margin?.top?.toDouble() ?? 0,
                        bottom:
                            widget.bottomNavModel?.margin?.bottom?.toDouble() ??
                                0),
                    padding: EdgeInsets.only(
                        left:
                            widget.bottomNavModel?.padding?.left?.toDouble() ??
                                0,
                        right:
                            widget.bottomNavModel?.padding?.right?.toDouble() ??
                                0,
                        top: widget.bottomNavModel?.padding?.top?.toDouble() ??
                            0,
                        bottom: widget.bottomNavModel?.padding?.bottom
                                ?.toDouble() ??
                            0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widget
                                  .bottomNavModel?.radius?.topLeft
                                  .toDouble() ??
                              0),
                          topRight: Radius.circular(widget
                                  .bottomNavModel?.radius?.topRight
                                  .toDouble() ??
                              0),
                          bottomLeft: Radius.circular(widget
                                  .bottomNavModel?.radius?.bottomLeft
                                  .toDouble() ??
                              0),
                          bottomRight: Radius.circular(widget
                                  .bottomNavModel?.radius?.bottomRight
                                  .toDouble() ??
                              0),
                        ),
                        color: widget.bottomNavModel?.backGroundColor,
                        border: widget.bottomNavModel?.showBorder ?? false
                            ? Border.all(
                                color: widget.bottomNavModel?.borderColor ??
                                    hexToColor("#FFFFFF") ??
                                    Colors.black,
                                width: widget.bottomNavModel?.borderWidth
                                        ?.toDouble() ??
                                    0)
                            : null,
                        image: DecorationImage(
                          fit: widget.bottomNavModel?.fit,
                          image: (navItem.icon ?? '').isEmpty
                              ? const AssetImage('assets/images/Logo.png')
                                  as ImageProvider
                              : NetworkImage(navItem.icon ?? ''),
                        )),
                  ),
                  label: navItem.label,
                );
              }).toList(),
              currentIndex: selectedBottomNavIndex,
              backgroundColor: widget.bottomNavModel?.backgroundColor,
              landscapeLayout: widget.bottomNavModel?.landscapeLayout,
              selectedFontSize: widget.bottomNavModel?.selectedFontSize ?? 16,
              selectedItemColor: widget.bottomNavModel?.selectedItemColor,
              unselectedItemColor: widget.bottomNavModel?.unselectedItemColor,
              unselectedFontSize:
                  widget.bottomNavModel?.unselectedFontSize ?? 12,
              onTap: _onBottomNavItemTap,
            )
          : null,
    );
  }
}
