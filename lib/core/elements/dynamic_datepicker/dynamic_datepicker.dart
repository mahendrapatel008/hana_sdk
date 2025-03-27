import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_datepicker/dynamic_datepicker_model.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:intl/intl.dart';

class DynamicDatePicker extends StatefulWidget {
  final DynamicDatePickerModel controller;
  final FormController formController;
  final VoidCallback? onPressed;

  const DynamicDatePicker({
    super.key,
    required this.controller,
    required this.formController,
    required this.onPressed,
  });

  @override
  State<DynamicDatePicker> createState() => _DynamicDatePickerState();
}

class _DynamicDatePickerState extends State<DynamicDatePicker> {
  DateTime? selectedDate;
  DateTime? selectedMonth;
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    String dateFormat = widget.controller.dateFormat ?? 'dd-MM-yyyy';
    try {
      selectedDate = (widget.controller.initialDate ??
          (SharedPrefs().hanaDateDependent.isNotEmpty
              ? DateFormat(dateFormat).parse(SharedPrefs().hanaDateDependent)
              : DateTime.now())) as DateTime?;
    } catch (e) {
      print("Error parsing date: $e");
      selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat(widget.controller.dateFormat);

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.controller.isYear == true
                ? selectedYear != null
                    ? '$selectedYear'
                    : "${DateTime.now().year}"
                : widget.controller.isMonth == true
                    ? selectedMonth != null
                        ? DateFormat('MM-yyyy').format(selectedMonth!)
                        : DateFormat('MM-yyyy').format(DateTime.now())
                    : selectedDate != null
                        ? formatter.format(selectedDate!)
                        : 'Select',
            style: TextStyle(color: widget.controller.textColor),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.calendar_today, color: widget.controller.textColor),
        ],
      ),
      onTap: () => _showPicker(context),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    if (widget.controller.isYear == true) {
      // Year Selector
      if (widget.controller.readOnly == true) {
        null;
      } else {
        await _showYearPicker(context);
      }
    } else if (widget.controller.isMonth == true) {
      // Month Selector
      if (widget.controller.readOnly == true) {
        null;
      } else {
        await _showMonthPicker(context);
      }
    } else {
      // Normal Date Picker
      if (widget.controller.readOnly == true) {
        null;
      } else {
        await _showDatePicker(context);
      }
    }
  }

  Future<void> _showYearPicker(BuildContext context) async {
    // int selectedYear = selectedDate!.year;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Text(
                "Select Year",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: (widget.controller.lastDate?.year ??
                          DateTime.now().year) -
                      (widget.controller.firstDate?.year ?? 2000) +
                      1,
                  itemBuilder: (context, index) {
                    int year =
                        (widget.controller.firstDate?.year ?? 2000) + index;
                    return ListTile(
                      title: Text(year.toString()),
                      onTap: () {
                        setState(() {
                          selectedYear = year.toString();
                          widget.formController.saveFieldValue(
                            widget.controller.name ?? '',
                            year.toString(),
                          );
                          if (widget.controller.onClickData != null) {
                            widget.onPressed?.call();
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    int selectedYears = selectedMonth?.year ?? DateTime.now().year;
    int selectedMonths = selectedMonth?.month ?? DateTime.now().month;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Month & Year",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Year Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setModalState(() {
                            selectedYears--;
                          });
                        },
                      ),
                      Text(
                        "$selectedYears",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setModalState(() {
                            selectedYears++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Month Selector
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        int month = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMonth = DateTime(selectedYears, month);
                              widget.formController.saveFieldValue(
                                widget.controller.name ?? '',
                                DateFormat('MM-yyyy')
                                    .format(selectedMonth!)
                                    .toString(),
                              );
                              if (widget.controller.onClickData != null) {
                                widget.onPressed?.call();
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: (month == selectedMonths &&
                                        selectedYears == selectedMonth?.year)
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              color: (month == selectedMonths &&
                                      selectedYears == selectedMonth?.year)
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              DateFormat.MMMM().format(DateTime(0, month)),
                              style: TextStyle(
                                color: (month == selectedMonths &&
                                        selectedYears == selectedMonth?.year)
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: widget.controller.firstDate ?? DateTime(2000),
      lastDate: widget.controller.lastDate ?? DateTime(9999, 12, 31),
    );

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat(widget.controller.dateFormat);
        widget.formController.saveFieldValue(
          widget.controller.name ?? '',
          formatter.format(selectedDate!),
        );
        if (widget.controller.onClickData != null) {
          widget.onPressed?.call();
        }
      });
    }
  }
}
