import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/api_elements_type_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_Inkwell/dynamic_Inkwell_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_Inkwell/dynamic_Inkwell_model.dart';
import 'package:hana_sdk/core/elements/dynamic_audio_player/dynamic_audio_player.dart';
import 'package:hana_sdk/core/elements/dynamic_audio_player/dynamic_audio_player_model.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_button/dynamic_button_model.dart';
import 'package:hana_sdk/core/elements/dynamic_card/dynamic_card_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_card/dynamic_card_model.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_chart/dynamic_chart_model.dart';
import 'package:hana_sdk/core/elements/dynamic_checkbox/dynamic_checkbox_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_checkbox/dynamic_checkbox_model.dart';
import 'package:hana_sdk/core/elements/dynamic_column/dynamic_column_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_column/dynamic_column_model.dart';
import 'package:hana_sdk/core/elements/dynamic_container/dynamic_container_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_container/dynamic_container_model.dart';
import 'package:hana_sdk/core/elements/dynamic_datepicker/dynamic_datepicker_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_datepicker/dynamic_datepicker_model.dart';
import 'package:hana_sdk/core/elements/dynamic_dropdown/dynamic_dropdown_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_dropdown/dynamic_dropdown_model.dart';
import 'package:hana_sdk/core/elements/dynamic_expanded/dynamic_expanded_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_expanded/dynamic_expanded_model.dart';
import 'package:hana_sdk/core/elements/dynamic_gridview/dynamic_gridview_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_gridview/dynamic_gridview_model.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_image/dynamic_image_model.dart';
import 'package:hana_sdk/core/elements/dynamic_image_selector/dynamic_image_selector_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_image_selector/dynamic_image_selector_model.dart';
import 'package:hana_sdk/core/elements/dynamic_list/dynamic_list_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_list/dynamic_list_model.dart';
import 'package:hana_sdk/core/elements/dynamic_map/dynamic_map_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_map/dynamic_map_model.dart';
import 'package:hana_sdk/core/elements/dynamic_onboarding/dynamic_onboarding_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_onboarding/dynamic_onboarding_model.dart';
import 'package:hana_sdk/core/elements/dynamic_otp/dynamic_otp_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_otp/dynamic_otp_model.dart';
import 'package:hana_sdk/core/elements/dynamic_popup_button/dynamic_popup_button_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_popup_button/dynamic_popup_button_model.dart';
import 'package:hana_sdk/core/elements/dynamic_positioned/dynamic_positioned_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_positioned/dynamic_positioned_model.dart';
import 'package:hana_sdk/core/elements/dynamic_qr/dynamic_qr_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_qr/dynamic_qr_model.dart';
import 'package:hana_sdk/core/elements/dynamic_qr_generator/dynamic_qr_generator_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_qr_generator/dynamic_qr_generator_model.dart';
import 'package:hana_sdk/core/elements/dynamic_radio/dynamic_radio_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_radio/dynamic_radio_model.dart';
import 'package:hana_sdk/core/elements/dynamic_rating_system/dynamic_rating_system.dart';
import 'package:hana_sdk/core/elements/dynamic_rating_system/dynamic_rating_system_model.dart';
import 'package:hana_sdk/core/elements/dynamic_repaint_boundary/dynamic_repaint_boundary_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_repaint_boundary/dynamic_repaint_boundary_model.dart';
import 'package:hana_sdk/core/elements/dynamic_row/dynamic_row_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_row/dynamic_row_model.dart';
import 'package:hana_sdk/core/elements/dynamic_safearea/dynamic_safearea_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_safearea/dynamic_safearea_model.dart';
import 'package:hana_sdk/core/elements/dynamic_scrollview/dynamic_scrollview_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_scrollview/dynamic_scrollview_model.dart';
import 'package:hana_sdk/core/elements/dynamic_sizedbox/dynamic_sizedbox_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_sizedbox/dynamic_sizedbox_model.dart';
import 'package:hana_sdk/core/elements/dynamic_slider/dynamic_slider_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_slider/dynamic_slider_model.dart';
import 'package:hana_sdk/core/elements/dynamic_spacer/dynamic_spacer_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_spacer/dynamic_spacer_model.dart';
import 'package:hana_sdk/core/elements/dynamic_stack/dynamic_stack_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_stack/dynamic_stack_model.dart';
import 'package:hana_sdk/core/elements/dynamic_table/dynamic_table_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_table/dynamic_table_model.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_text/dynamic_text_model.dart';
import 'package:hana_sdk/core/elements/dynamic_textarea/dynamic_textarea_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_textarea/dynamic_textarea_model.dart';
import 'package:hana_sdk/core/elements/dynamic_textfield/dynamic_textfield_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_textfield/dynamic_textfield_model.dart';
import 'package:hana_sdk/core/elements/dynamic_timepicker/dynamic_timepicker_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_timepicker/dynamic_timepicker_model.dart';
import 'package:hana_sdk/core/elements/dynamic_video_player/dynamic_video_player_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_video_player/dynamic_video_player_model.dart';
import 'package:hana_sdk/core/elements/dynamic_webview/dynamic_webview.dart';
import 'package:hana_sdk/core/elements/dynamic_webview/dynamic_webview_model.dart';

import '../elements/dynamic_flex/dynamic_flex_controller.dart';
import '../elements/dynamic_flex/dynamic_flex_model.dart';

class ApiElementController {
  final ApiFormElements formSectionsElements;

  ApiElementController({required this.formSectionsElements});

  Widget buildFormElement() {
    switch (formSectionsElements.type) {
      case ApiFormElementsType.text:
        var model = formSectionsElements.model as DynamicTextModel;
        DynamicTextModel controller = DynamicTextModel(
          type: model.type,
          label: model.label,
          id: model.id,
          name: model.name,
          textColor: model.textColor,
          fontSize: model.fontSize,
          fontWeight: model.fontWeight,
          maxLines: model.maxLines,
          softWrap: model.softWrap,
          textAlign: model.textAlign,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          overflow: model.overflow,
          addressFormate: model.addressFormate,
          showTime: model.showTime,
          showLocation: model.showLocation,
          dataKey: model.dataKey,
          locationFormate: model.locationFormate,
        );
        return DynamicTextController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.table:
        var model = formSectionsElements.model as DynamicTableModel;
        DynamicTableModel controller = DynamicTableModel(
          type: model.type,
          label: model.label,
          id: model.id,
          name: model.name,
          titleTextColor: model.titleTextColor,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          listOfTitles: model.listOfTitles,
          listOfValues: model.listOfValues,
          titleBackGroundgColor: model.titleBackGroundgColor,
          titleFontSize: model.titleFontSize,
          titleFontWeight: model.titleFontWeight,
          titlePadding: model.titlePadding,
          valueBackGroundgColor: model.valueBackGroundgColor,
          valueFontSize: model.valueFontSize,
          valueFontWeight: model.valueFontWeight,
          valuePadding: model.valuePadding,
          valueTextColor: model.valueTextColor,
          radius: model.radius,
          tableBorderModel: model.tableBorderModel,
          dataKey: model.dataKey,
        );
        return DynamicTableController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.image:
        var model = formSectionsElements.model as DynamicImageModel;
        DynamicImageModel controller = DynamicImageModel(
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          fit: model.fit,
          id: model.id,
          name: model.name,
          height: model.height,
          imgUrl: model.imgUrl,
          margin: model.margin,
          padding: model.padding,
          placeholder: model.placeholder,
          radius: model.radius,
          showBorder: model.showBorder,
          width: model.width,
          onClickData: model.onClickData,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          imgFromGallery: model.imgFromGallery,
        );
        return DynamicImageController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.file:
        var model = formSectionsElements.model as DynamicImageSelectorModel;
        DynamicImageSelectorModel controller = DynamicImageSelectorModel(
          fit: model.fit,
          id: model.id,
          name: model.name,
          height: model.height,
          imgUrl: model.imgUrl,
          placeholder: model.placeholder,
          width: model.width,
          label: model.label,
          fontSize: model.fontSize,
          fontWeight: model.fontWeight,
          maxLines: model.maxLines,
          overflow: model.overflow,
          softWrap: model.softWrap,
          textAlign: model.textAlign,
          textColor: model.textColor,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
        );
        return DynamicImageSelectorController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.icon:
        var model = formSectionsElements.model as DynamicImageModel;
        DynamicImageModel controller = DynamicImageModel(
          fit: model.fit,
          id: model.id,
          name: model.name,
          height: model.height,
          imgUrl: model.imgUrl,
          placeholder: model.placeholder,
          width: model.width,
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          margin: model.margin,
          onClickData: model.onClickData,
          padding: model.padding,
          radius: model.radius,
          showBorder: model.showBorder,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          imgFromGallery: model.imgFromGallery,
        );
        return DynamicImageController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.iconButton:
        var model = formSectionsElements.model as DynamicImageModel;
        DynamicImageModel controller = DynamicImageModel(
          fit: model.fit,
          id: model.id,
          name: model.name,
          height: model.height,
          imgUrl: model.imgUrl,
          placeholder: model.placeholder,
          width: model.width,
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          margin: model.margin,
          onClickData: model.onClickData,
          padding: model.padding,
          radius: model.radius,
          showBorder: model.showBorder,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          imgFromGallery: model.imgFromGallery,
        );
        return DynamicImageController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.webview:
        var model = formSectionsElements.model as DynamicWebViewModel;
        DynamicWebViewModel controller = DynamicWebViewModel(
          initialUrl: model.initialUrl,
          title: model.title,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          name: model.name,
        );
        return DynamicWebView(
          formController: formSectionsElements.formController,
          model: controller,
        );
      case ApiFormElementsType.ratingSystem:
        var model = formSectionsElements.model as DynamicRatingSystemModel;
        DynamicRatingSystemModel controller = DynamicRatingSystemModel(
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          label: model.label,
          id: model.id,
          minRating: model.minRating,
          name: model.name,
          type: model.type,
          initialRating: model.initialRating,
          itemCount: model.itemCount,
          itemSize: model.itemSize,
          required: model.required,
        );
        return RatingHandler(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.map:
        var model = formSectionsElements.model as DynamicMapModel;
        DynamicMapModel controller = DynamicMapModel(
          latitude: model.latitude,
          longitude: model.longitude,
          bearing: model.bearing,
          markers: model.markers,
          tilt: model.tilt,
          zoom: model.zoom,
          title: model.title,
          buildingsEnabled: model.buildingsEnabled,
          cameraTargetBounds: model.cameraTargetBounds,
          circles: model.circles,
          compassEnabled: model.compassEnabled,
          heatmaps: model.heatmaps,
          indoorViewEnabled: model.indoorViewEnabled,
          layoutDirection: model.layoutDirection,
          liteModeEnabled: model.liteModeEnabled,
          mapToolbarEnabled: model.mapToolbarEnabled,
          mapType: model.mapType,
          myLocationButtonEnabled: model.myLocationButtonEnabled,
          myLocationEnabled: model.myLocationEnabled,
          rotateGesturesEnabled: model.rotateGesturesEnabled,
          scrollGesturesEnabled: model.scrollGesturesEnabled,
          tiltGesturesEnabled: model.tiltGesturesEnabled,
          trafficEnabled: model.trafficEnabled,
          zoomControlsEnabled: model.zoomControlsEnabled,
          zoomGesturesEnabled: model.zoomGesturesEnabled,
          clusterManagers: model.clusterManagers,
          polygons: model.polygons,
          polylines: model.polylines,
          fortyFiveDegreeImageryEnabled: model.fortyFiveDegreeImageryEnabled,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicMapController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.button:
        var model = formSectionsElements.model as DynamicButtonModel;
        DynamicButtonModel controller = DynamicButtonModel(
          label: model.label,
          type: model.type,
          fontSize: model.fontSize,
          color: model.color,
          height: model.height,
          width: model.width,
          titleColor: model.titleColor,
          onClickData: model.onClickData,
          name: model.name,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicButtonController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.textButton:
        var model = formSectionsElements.model as DynamicButtonModel;
        DynamicButtonModel controller = DynamicButtonModel(
          label: model.label,
          type: model.type,
          fontSize: model.fontSize,
          color: model.color,
          height: model.height,
          width: model.width,
          titleColor: model.titleColor,
          onClickData: model.onClickData,
          name: model.name,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicButtonController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.textField:
        var model = formSectionsElements.model as DynamicTextFieldModel;
        DynamicTextFieldModel controller = DynamicTextFieldModel(
          label: model.label,
          name: model.name,
          required: model.required,
          enable: model.enable,
          hintText: model.hintText,
          keyboard: model.keyboard,
          prefixIcon: model.prefixIcon,
          readOnly: model.readOnly,
          suffixIcon: model.suffixIcon,
          textAlign: model.textAlign,
          textInputAction: model.textInputAction,
          validator: model.validator,
          maxLength: model.maxLength,
          id: model.id,
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          isBorder: model.isBorder,
          borderRadius: model.borderRadius,
          obscureText: model.obscureText,
          isReadOnlySave: model.isReadOnlySave,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          floatingText: model.floatingText,
          saveAs: model.saveAs,
          regex: model.regex,
          regexError: model.regexError,
        );
        return DynamicTextFieldController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.textArea:
        var model = formSectionsElements.model as DynamicTextAreaModel;
        DynamicTextAreaModel controller = DynamicTextAreaModel(
          name: model.name,
          maxLength: model.maxLength,
          id: model.id,
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          initialText: model.initialText,
          maxLines: model.maxLength,
          placeholder: model.placeholder,
          radius: model.radius,
          textColor: model.textColor,
          focusBorderColor: model.focusBorderColor,
          fontSize: model.fontSize,
          fontWeight: model.fontWeight,
          paddingHorizontal: model.paddingHorizontal,
          paddingVertical: model.paddingVertical,
          placeholderColor: model.placeholderColor,
          shadowBlurRadius: model.shadowBlurRadius,
          shadowColor: model.shadowColor,
          shadowOffsetX: model.shadowOffsetX,
          shadowOffsetY: model.shadowOffsetY,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicTextAreaController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.dropDown:
        var model = formSectionsElements.model as DynamicDropdownModel;
        DynamicDropdownModel controller = DynamicDropdownModel(
          items: model.items,
          backGroundColor: model.backGroundColor,
          placeholder: model.placeholder,
          radius: model.radius,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          textColor: model.textColor,
          textSize: model.textSize,
          textWeight: model.textWeight,
          id: model.id,
          name: model.name,
          onClickData: model.onClickData,
          required: model.required,
          label: model.label,
          validator: model.validator,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          isId: model.isId,
          readOnly: model.readOnly,
          dataKey: model.dataKey,
        );
        return DynamicDropdownController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.checkBox:
        var model = formSectionsElements.model as DynamicCheckBoxModel;
        DynamicCheckBoxModel controller = DynamicCheckBoxModel(
          items: model.items,
          backGroundColor: model.backGroundColor,
          name: model.name,
          radius: model.radius,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          checkTickColor: model.checkTickColor,
          checkboxColor: model.checkboxColor,
          textColor: model.textColor,
          textSize: model.textSize,
          textWeight: model.textWeight,
          id: model.id,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicCheckBoxController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.radio:
        var model = formSectionsElements.model as DynamicRadioModel;
        DynamicRadioModel controller = DynamicRadioModel(
          items: model.items,
          backGroundColor: model.backGroundColor,
          name: model.name,
          radius: model.radius,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          textColor: model.textColor,
          textSize: model.textSize,
          textWeight: model.textWeight,
          radioActiveColor: model.radioActiveColor,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicRadioController(
          formController: formSectionsElements.formController,
          controller: controller,
        );

      case ApiFormElementsType.list:
        var model = formSectionsElements.model as DynamicListModel;
        DynamicListModel controller = DynamicListModel(
          type: model.type,
          items: model.items,
          scrollDirection: model.scrollDirection,
          height: model.height,
          item: model.item,
          id: model.id,
          label: model.label,
          name: model.name,
          onClickData: model.onClickData,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
        );
        return DynamicListController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.slider:
        var model = formSectionsElements.model as DynamicSliderModel;
        DynamicSliderModel controller = DynamicSliderModel(
          items: model.items,
          scrollDirection: model.scrollDirection,
          height: model.height,
          aspectRatio: model.aspectRatio,
          autoPlay: model.autoPlay,
          autoPlayInterval: model.autoPlayInterval,
          enableInfiniteScroll: model.enableInfiniteScroll,
          enlargeCenterPage: model.enlargeCenterPage,
          clipBehavior: model.clipBehavior,
          initialPage: model.initialPage,
          interactable: model.interactable,
          onClickData: model.onClickData,
          pageSnapping: model.pageSnapping,
          pauseAutoPlayInFiniteScroll: model.pauseAutoPlayInFiniteScroll,
          pauseAutoPlayOnTouch: model.pauseAutoPlayOnTouch,
          reverse: model.reverse,
          viewportFraction: model.viewportFraction,
          name: model.name,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicSliderController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.grid:
        var model = formSectionsElements.model as DynamicGridViewModel;
        DynamicGridViewModel controller = DynamicGridViewModel(
          type: model.type,
          items: model.items,
          item: model.item,
          crossAxisCount: model.crossAxisCount,
          crossAxisSpacing: model.crossAxisSpacing,
          mainAxisSpacing: model.mainAxisSpacing,
          childHeight: model.childHeight,
          label: model.label,
          name: model.name,
          id: model.id,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
        );
        return DynamicGridViewController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.qr:
        var model = formSectionsElements.model as DynamicQRModel;
        DynamicQRModel controller = DynamicQRModel(
          name: model.name,
          onClickData: model.onClickData,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicQRController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.qrGenerator:
        var model = formSectionsElements.model as DynamicQrGeneratorModel;
        DynamicQrGeneratorModel controller = DynamicQrGeneratorModel(
          name: model.name,
          backgroundColor: model.backgroundColor,
          dataKey: model.dataKey,
          embeddedImage: model.embeddedImage,
          embeddedImageStyle: model.embeddedImageStyle,
          errorMessage: model.errorMessage,
          eyeStyle: model.eyeStyle,
          gapless: model.gapless,
          id: model.id,
          padding: model.padding,
          semanticsLabel: model.semanticsLabel,
          size: model.size,
          version: model.version,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicQrGeneratorController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.share:
        var model = formSectionsElements.model as DynamicRepaintBoundaryModel;
        DynamicRepaintBoundaryModel controller = DynamicRepaintBoundaryModel(
          name: model.name,
          items: model.items,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicRepaintBoundaryController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.stack:
        var model = formSectionsElements.model as DynamicStackModel;
        DynamicStackModel controller = DynamicStackModel(
          alignment: model.alignment,
          items: model.items,
          clipBehavior: model.clipBehavior,
          stackFit: model.stackFit,
          textDirection: model.textDirection,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicStackController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.positioned:
        var model = formSectionsElements.model as DynamicPositionedModel;
        DynamicPositionedModel controller = DynamicPositionedModel(
          bottom: model.bottom,
          left: model.left,
          right: model.right,
          top: model.top,
          width: model.width,
          height: model.height,
          items: model.items,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicPositionedController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.column:
        var model = formSectionsElements.model as DynamicColumnModel;
        DynamicColumnModel controller = DynamicColumnModel(
          type: model.type,
          items: model.items,
          crossAxis: model.crossAxis,
          mainAxis: model.mainAxis,
          scrollable: model.scrollable,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicColumnController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.scrollView:
        var model = formSectionsElements.model as DynamicScrollViewModel;
        DynamicScrollViewModel controller = DynamicScrollViewModel(
          scrollDirection: model.scrollDirection,
          items: model.items,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicScrollViewController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.hanaEventListener:
        var model = formSectionsElements.model as DynamicInkWellModel;
        DynamicInkWellModel controller = DynamicInkWellModel(
          focusColor: model.focusColor,
          highlightColor: model.highlightColor,
          hoverColor: model.hoverColor,
          hoverDuration: model.hoverDuration,
          name: model.name,
          onDoubleTap: model.onDoubleTap,
          onHover: model.onHover,
          onLongPress: model.onLongPress,
          onTap: model.onTap,
          splashColor: model.splashColor,
          items: model.items,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicInkWellController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.container:
        var model = formSectionsElements.model as DynamicContainerModel;
        DynamicContainerModel controller = DynamicContainerModel(
          width: model.width,
          height: model.height,
          radius: model.radius,
          margin: model.margin,
          items: model.items,
          padding: model.padding,
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          showBorder: model.showBorder,
          isCenter: model.isCenter,
          onClickData: model.onClickData,
          borderWidth: model.borderWidth,
          gradient: model.gradient,
          fit: model.fit,
          imageOpacity: model.imageOpacity,
          imgUrl: model.imgUrl,
          isUrlLauncher: model.isUrlLauncher,
          url: model.url,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          name: model.name,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          elevation: model.elevation,
          shadowColor: model.shadowColor,
          shadowOffset: model.shadowOffset,
          spreadRadius: model.spreadRadius,
        );
        return DynamicContainerController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.card:
        var model = formSectionsElements.model as DynamicCardModel;
        DynamicCardModel controller = DynamicCardModel(
          borderOnForeground: model.borderOnForeground,
          margin: model.margin,
          items: model.items,
          padding: model.padding,
          borderRadius: model.borderRadius,
          cardColor: model.cardColor,
          clipBehavior: model.clipBehavior,
          elevation: model.elevation,
          semanticContainer: model.semanticContainer,
          shadowColor: model.shadowColor,
          surfaceTintColor: model.surfaceTintColor,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicCardController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.safeArea:
        var model = formSectionsElements.model as DynamicSafeareaModel;
        DynamicSafeareaModel controller = DynamicSafeareaModel(
          items: model.items,
          elevation: model.elevation,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
          bottom: model.bottom,
          left: model.left,
          maintainBottomViewPadding: model.maintainBottomViewPadding,
          minimum: model.minimum,
          right: model.right,
          top: model.top,
        );
        return DynamicSafeareaController(
          formController: formSectionsElements.formController,
          controller: controller,
        );

      case ApiFormElementsType.popupbutton:
        var model = formSectionsElements.model as DynamicPopupMenuModel;
        DynamicPopupMenuModel controller = DynamicPopupMenuModel(
          height: model.height,
          width: model.width,
          id: model.id,
          item: model.item,
          label: model.label,
          name: model.name,
          popupMenuItems: model.popupMenuItems,
          backGroundColor: model.backGroundColor,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          fit: model.fit,
          radius: model.radius,
          showBorder: model.showBorder,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          fontSizeLabel: model.fontSizeLabel,
          fontSizeSublabel: model.fontSizeSublabel,
          fontWeightLabel: model.fontWeightLabel,
          fontWeightSublabel: model.fontWeightSublabel,
          textColorLabel: model.textColorLabel,
          textColorSublabel: model.textColorSublabel,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicPopupMenuController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.expanded:
        var model = formSectionsElements.model as DynamicExpandedModel;
        DynamicExpandedModel controller = DynamicExpandedModel(
          items: model.items,
          flex: model.flex,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicExpandedController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.chart:
        var model = formSectionsElements.model as DynamicChartModel;
        DynamicChartModel controller = DynamicChartModel(
          items: model.items,
          chartType: model.chartType,
          id: model.id,
          label: model.label,
          name: model.name,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          plotAreaBorderWidth: model.plotAreaBorderWidth,
          xInterval: model.xInterval,
          yAxisLabelFormat: model.yAxisLabelFormat,
          hourParsing: model.hourParsing,
          enableTooltip: model.enableTooltip,
          trackballBehavior: model.trackballBehavior,
          tooltipColor: model.tooltipColor,
          sharedTooltip: model.sharedTooltip,
          zoomSelection: model.zoomSelection,
          enablePanning: model.enablePanning,
          enablePinching: model.enablePinching,
          enableDoubleTapZoom: model.enableDoubleTapZoom,
          zoomMode: model.zoomMode,
          manualXaxis: model.manualXaxis,
          dataKey: model.dataKey,
          xLabel: model.xLabel,
          yLabel: model.yLabel,
        );
        return DynamicChartController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.otpView:
        var model = formSectionsElements.model as DynamicOtpViewModel;
        DynamicOtpViewModel controller = DynamicOtpViewModel(
          numberOfFields: model.numberOfFields,
          borderWidth: model.borderWidth,
          borderColor: model.borderColor,
          showFieldAsBox: model.showFieldAsBox,
          focusedBorderColor: model.focusedBorderColor,
          name: model.name,
          id: model.id,
          cursorColor: model.cursorColor,
          fieldHeight: model.fieldHeight,
          fieldWidth: model.fieldWidth,
          fillColor: model.fillColor,
          fontName: model.fontName,
          fontSize: model.fontSize,
          fontWeight: model.fontWeight,
          textColor: model.textColor,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicOtpController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.row:
        var model = formSectionsElements.model as DynamicRowModel;
        DynamicRowModel controller = DynamicRowModel(
          type: model.type,
          items: model.items,
          crossAxis: model.crossAxis,
          mainAxis: model.mainAxis,
          scrollable: model.scrollable,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicRowController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.sizedBox:
        var model = formSectionsElements.model as DynamicSizedBoxModel;
        DynamicSizedBoxModel controller = DynamicSizedBoxModel(
          height: model.height,
          width: model.width,
          items: model.items,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicSizedBoxController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.date:
        var model = formSectionsElements.model as DynamicDatePickerModel;
        DynamicDatePickerModel controller = DynamicDatePickerModel(
          backGroundColor: model.backGroundColor,
          dateFormat: model.dateFormat,
          firstDate: model.firstDate,
          initialDate: model.initialDate,
          lastDate: model.lastDate,
          name: model.name,
          textColor: model.textColor,
          id: model.id,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          radius: model.radius,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          onClickData: model.onClickData,
          isMonth: model.isMonth,
          isYear: model.isYear,
          readOnly: model.readOnly,
        );
        return DynamicDatePickerController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.time:
        var model = formSectionsElements.model as DynamicTimePickerModel;
        DynamicTimePickerModel controller = DynamicTimePickerModel(
          backGroundColor: model.backGroundColor,
          initialTime: model.initialTime,
          name: model.name,
          textColor: model.textColor,
          id: model.id,
          borderColor: model.borderColor,
          borderWidth: model.borderWidth,
          radius: model.radius,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicTimePickerController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.onBoarding:
        var model = formSectionsElements.model as DynamicOnboardingSlideModel;
        DynamicOnboardingSlideModel controller = DynamicOnboardingSlideModel(
          controllerColor: model.controllerColor,
          finishButtonText: model.finishButtonText,
          headerBackgroundColor: model.headerBackgroundColor,
          pageBackgroundColor: model.pageBackgroundColor,
          loginFontWeight: model.loginFontWeight,
          loginTextColor: model.loginTextColor,
          loginTextSize: model.loginTextSize,
          skipFontWeight: model.skipFontWeight,
          skipTextColor: model.skipTextColor,
          skipTextSize: model.loginTextSize,
          skipButtonText: model.skipButtonText,
          onClickData: model.onClickData,
          speed: model.speed,
          items: model.items,
          isHideAndShow: model.isHideAndShow,
          name: model.name,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicOnBoardingController(
          formController: formSectionsElements.formController,
          controller: controller,
        );
      case ApiFormElementsType.spacer:
        var model = formSectionsElements.model as DynamicSpacerModel;
        DynamicSpacerModel controller = DynamicSpacerModel(
          flex: model.flex,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          name: model.name,
        );
        return DynamicSpacerController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.video:
        var model = formSectionsElements.model as DynamicVideoPlayerModel;
        DynamicVideoPlayerModel controller = DynamicVideoPlayerModel(
          videoUrl: model.videoUrl,
          autoPlay: model.autoPlay,
          looping: model.looping,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          dataKey: model.dataKey,
          name: model.name,
        );
        return DynamicVideoPlayerController(
          controller: controller,
          formController: formSectionsElements.formController,
        );
      case ApiFormElementsType.audio:
        var model = formSectionsElements.model as DynamicAudioPlayerModel;
        DynamicAudioPlayerModel controller = DynamicAudioPlayerModel(
          audioUrl: model.audioUrl,
          name: model.name,
          canScrub: model.canScrub,
          required: model.required,
          activeTrackColor: model.activeTrackColor,
          enabledThumbRadius: model.enabledThumbRadius,
          inactiveTrackColor: model.inactiveTrackColor,
          thumbColor: model.thumbColor,
          trackHeight: model.trackHeight,
          isHideAndShow: model.isHideAndShow,
          prerequisite: model.prerequisite,
          dataKey: model.dataKey,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
        );
        return DynamicAudioPlayer(
          controller: controller,
          formController: formSectionsElements.formController,
        );

      case ApiFormElementsType.flex:
        var model = formSectionsElements.model as DynamicFlexModel;
        DynamicFlexModel controller = DynamicFlexModel(
          direction: model.direction,
          mainAxisAlignment: model.mainAxisAlignment,
          crossAxisAlignment: model.crossAxisAlignment,
          mainAxisSize: model.mainAxisSize,
          verticalDirection: model.verticalDirection,
          textDirection: model.textDirection,
          clipBehavior: model.clipBehavior,
          isHideAndShow: model.isHideAndShow,
          items: model.items,
          hanaPrerequisiteDesign: model.hanaPrerequisiteDesign,
          prerequisite: model.prerequisite,
        );
        return DynamicFlexController(
          formController: formSectionsElements.formController,
          controller: controller,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
