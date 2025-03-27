import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_Inkwell/dynamic_Inkwell_model.dart';
import 'package:hana_sdk/core/elements/dynamic_audio_player/dynamic_audio_player_model.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button_model.dart';
import 'package:hana_sdk/core/elements/dynamic_card/dynamic_card_model.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_model.dart';
import 'package:hana_sdk/core/elements/dynamic_checkbox/dynamic_checkbox_model.dart';
import 'package:hana_sdk/core/elements/dynamic_column/dynamic_column_model.dart';
import 'package:hana_sdk/core/elements/dynamic_container/dynamic_container_model.dart';
import 'package:hana_sdk/core/elements/dynamic_datepicker/dynamic_datepicker_model.dart';
import 'package:hana_sdk/core/elements/dynamic_dropdown/dynamic_dropdown_model.dart';
import 'package:hana_sdk/core/elements/dynamic_expanded/dynamic_expanded_model.dart';
import 'package:hana_sdk/core/elements/dynamic_gridview/dynamic_gridview_model.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_model.dart';
import 'package:hana_sdk/core/elements/dynamic_image_selector/dynamic_image_selector_model.dart';
import 'package:hana_sdk/core/elements/dynamic_list/dynamic_list_model.dart';
import 'package:hana_sdk/core/elements/dynamic_map/dynamic_map_model.dart';
import 'package:hana_sdk/core/elements/dynamic_onboarding/dynamic_onboarding_model.dart';
import 'package:hana_sdk/core/elements/dynamic_otp/dynamic_otp_model.dart';
import 'package:hana_sdk/core/elements/dynamic_popup_button/dynamic_popup_button_model.dart';
import 'package:hana_sdk/core/elements/dynamic_positioned/dynamic_positioned_model.dart';
import 'package:hana_sdk/core/elements/dynamic_qr/dynamic_qr_model.dart';
import 'package:hana_sdk/core/elements/dynamic_qr_generator/dynamic_qr_generator_model.dart';
import 'package:hana_sdk/core/elements/dynamic_radio/dynamic_radio_model.dart';
import 'package:hana_sdk/core/elements/dynamic_rating_system/dynamic_rating_system_model.dart';
import 'package:hana_sdk/core/elements/dynamic_repaint_boundary/dynamic_repaint_boundary_model.dart';
import 'package:hana_sdk/core/elements/dynamic_row/dynamic_row_model.dart';
import 'package:hana_sdk/core/elements/dynamic_safearea/dynamic_safearea_model.dart';
import 'package:hana_sdk/core/elements/dynamic_scrollview/dynamic_scrollview_model.dart';
import 'package:hana_sdk/core/elements/dynamic_sizedbox/dynamic_sizedbox_model.dart';
import 'package:hana_sdk/core/elements/dynamic_slider/dynamic_slider_model.dart';
import 'package:hana_sdk/core/elements/dynamic_spacer/dynamic_spacer_model.dart';
import 'package:hana_sdk/core/elements/dynamic_stack/dynamic_stack_model.dart';
import 'package:hana_sdk/core/elements/dynamic_table/dynamic_table_model.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_model.dart';
import 'package:hana_sdk/core/elements/dynamic_textarea/dynamic_textarea_model.dart';
import 'package:hana_sdk/core/elements/dynamic_textfield/dynamic_textfield_model.dart';
import 'package:hana_sdk/core/elements/dynamic_timepicker/dynamic_timepicker_model.dart';
import 'package:hana_sdk/core/elements/dynamic_video_player/dynamic_video_player_model.dart';
import 'package:hana_sdk/core/elements/dynamic_webview/dynamic_webview_model.dart';

import '../elements/dynamic_flex/dynamic_flex_model.dart';

class ApiFormElements {
  final ApiFormElementsType type;
  final dynamic model;
  FormController formController = FormController();
  String name = '';

  ApiFormElements({required this.type, required this.model});

  factory ApiFormElements.fromJson(Map<String, dynamic> json) {
    return ApiFormElements(
      type: ApiFormElementsType.getTypeFromString(json["type"]),
      model: ApiFormElementsType.getModel(json["items"]),
    );
  }
}

enum ApiFormElementsType {
  hidden,
  text,
  table,
  column,
  row,
  container,
  card,
  expanded,
  textField,
  safeArea,
  button,
  textButton,
  dropDown,
  sizedBox,
  spacer,
  radio,
  checkBox,
  textArea,
  date,
  image,
  file,
  icon,
  iconButton,
  video,
  audio,
  flex,
  scrollView,
  otpView,
  onBoarding,
  chart,
  stack,
  time,
  list,
  slider,
  positioned,
  popupbutton,
  webview,
  ratingSystem,
  hanaEventListener,
  map,
  qr,
  qrGenerator,
  share,
  grid;

  static ApiFormElementsType getTypeFromString(String string) {
    switch (string) {
      case "text":
        return ApiFormElementsType.text;
      case "table":
        return ApiFormElementsType.table;
      case "radio":
        return ApiFormElementsType.radio;
      case "dropDown":
        return ApiFormElementsType.dropDown;
      case "sizedBox":
        return ApiFormElementsType.sizedBox;
      case "spacer":
        return ApiFormElementsType.spacer;
      case "checkBox":
        return ApiFormElementsType.checkBox;
      case "otpView":
        return ApiFormElementsType.otpView;
      case "onBoarding":
        return ApiFormElementsType.onBoarding;
      case "chart":
        return ApiFormElementsType.chart;
      case "stack":
        return ApiFormElementsType.stack;
      case "date":
        return ApiFormElementsType.date;
      case "time":
        return ApiFormElementsType.time;
      case "image":
        return ApiFormElementsType.image;
      case "file":
        return ApiFormElementsType.file;
      case "icon":
        return ApiFormElementsType.icon;
      case "iconButton":
        return ApiFormElementsType.iconButton;
      case "column":
        return ApiFormElementsType.column;
      case "row":
        return ApiFormElementsType.row;
      case "container":
        return ApiFormElementsType.container;
      case "card":
        return ApiFormElementsType.card;
      case "expanded":
        return ApiFormElementsType.expanded;
      case "textField":
        return ApiFormElementsType.textField;
      case "safeArea":
        return ApiFormElementsType.safeArea;
      case "textArea":
        return ApiFormElementsType.textArea;
      case "button":
        return ApiFormElementsType.button;
      case "textButton":
        return ApiFormElementsType.textButton;
      case "scrollView":
        return ApiFormElementsType.scrollView;
      case "video":
        return ApiFormElementsType.video;
      case "audio":
        return ApiFormElementsType.audio;
      case "ratingSystem":
        return ApiFormElementsType.ratingSystem;
      case "hanaEventListener":
        return ApiFormElementsType.hanaEventListener;
      case "list":
        return ApiFormElementsType.list;
      case "slider":
        return ApiFormElementsType.slider;
      case "positioned":
        return ApiFormElementsType.positioned;
      case "grid":
        return ApiFormElementsType.grid;
      case "popupbutton":
        return ApiFormElementsType.popupbutton;
      case "webview":
        return ApiFormElementsType.webview;
      case "map":
        return ApiFormElementsType.map;
        case "flex":
        return ApiFormElementsType.flex;
      case "qr":
        return ApiFormElementsType.qr;
      case "qrGenerator":
        return ApiFormElementsType.qrGenerator;
      case "share":
        return ApiFormElementsType.share;
      default:
        return ApiFormElementsType.hidden;
    }
  }

  static dynamic getModel(Map<String, dynamic> json) {
    var type = getTypeFromString(json["type"]);
    switch (type) {
      case ApiFormElementsType.hidden:
        return null;
      case ApiFormElementsType.scrollView:
        return DynamicScrollViewModel.fromJson(json);
      case ApiFormElementsType.text:
        return DynamicTextModel.fromJson(json);
      case ApiFormElementsType.table:
        return DynamicTableModel.fromJson(json);
      case ApiFormElementsType.list:
        return DynamicListModel.fromJson(json);
      case ApiFormElementsType.slider:
        return DynamicSliderModel.fromJson(json);
      case ApiFormElementsType.column:
        return DynamicColumnModel.fromJson(json);
      case ApiFormElementsType.row:
        return DynamicRowModel.fromJson(json);
      case ApiFormElementsType.image:
        return DynamicImageModel.fromJson(json);
      case ApiFormElementsType.file:
        return DynamicImageSelectorModel.fromJson(json);
      case ApiFormElementsType.icon:
        return DynamicImageModel.fromJson(json);
      case ApiFormElementsType.iconButton:
        return DynamicImageModel.fromJson(json);
      case ApiFormElementsType.container:
        return DynamicContainerModel.fromJson(json);
      case ApiFormElementsType.card:
        return DynamicCardModel.fromJson(json);
      case ApiFormElementsType.safeArea:
        return DynamicSafeareaModel.fromJson(json);
      case ApiFormElementsType.expanded:
        return DynamicExpandedModel.fromJson(json);
      case ApiFormElementsType.textField:
        return DynamicTextFieldModel.fromJson(json);
      case ApiFormElementsType.textArea:
        return DynamicTextAreaModel.fromJson(json);
      case ApiFormElementsType.button:
        return DynamicButtonModel.fromJson(json);
      case ApiFormElementsType.textButton:
        return DynamicButtonModel.fromJson(json);
      case ApiFormElementsType.radio:
        return DynamicRadioModel.fromJson(json);
      case ApiFormElementsType.dropDown:
        return DynamicDropdownModel.fromJson(json);
      case ApiFormElementsType.sizedBox:
        return DynamicSizedBoxModel.fromJson(json);
      case ApiFormElementsType.spacer:
        return DynamicSpacerModel.fromJson(json);
      case ApiFormElementsType.grid:
        return DynamicGridViewModel.fromJson(json);
      case ApiFormElementsType.checkBox:
        return DynamicCheckBoxModel.fromJson(json);
      case ApiFormElementsType.otpView:
        return DynamicOtpViewModel.fromJson(json);
      case ApiFormElementsType.onBoarding:
        return DynamicOnboardingSlideModel.fromJson(json);
      case ApiFormElementsType.chart:
        return DynamicChartModel.fromJson(json);
      case ApiFormElementsType.stack:
        return DynamicStackModel.fromJson(json);
      case ApiFormElementsType.date:
        return DynamicDatePickerModel.fromJson(json);
      case ApiFormElementsType.time:
        return DynamicTimePickerModel.fromJson(json);
      case ApiFormElementsType.video:
        return DynamicVideoPlayerModel.fromJson(json);
      case ApiFormElementsType.audio:
        return DynamicAudioPlayerModel.fromJson(json);
      case ApiFormElementsType.flex:
        return DynamicFlexModel.fromJson(json);
      case ApiFormElementsType.positioned:
        return DynamicPositionedModel.fromJson(json);
      case ApiFormElementsType.popupbutton:
        return DynamicPopupMenuModel.fromJson(json);
      case ApiFormElementsType.webview:
        return DynamicWebViewModel.fromJson(json);
      case ApiFormElementsType.map:
        return DynamicMapModel.fromJson(json);
      case ApiFormElementsType.qr:
        return DynamicQRModel.fromJson(json);
      case ApiFormElementsType.qrGenerator:
        return DynamicQrGeneratorModel.fromJson(json);
      case ApiFormElementsType.share:
        return DynamicRepaintBoundaryModel.fromJson(json);
      case ApiFormElementsType.ratingSystem:
        return DynamicRatingSystemModel.fromJson(json);
      case ApiFormElementsType.hanaEventListener:
        return DynamicInkWellModel.fromJson(json);
    }
  }
}
