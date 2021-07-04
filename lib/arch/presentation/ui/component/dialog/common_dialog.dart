import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';
import 'package:hukum_pro/common/ui/dialog_closing_state.dart';

class CommonDialog extends StatelessWidget {
  final bool? closable;
  final String? title;
  final String? description;
  final String? primaryAction;
  final ButtonCtaType? primaryStyle;

  CommonDialog(
      {this.closable,
      this.title,
      this.description,
      this.primaryAction,
      this.primaryStyle})
      : super();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 24,
      backgroundColor: AppColor.background,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 24),
            child: Container(
              color: Colors.transparent,
              child: createDialogContent(context),
            ),
          ),
          createCloseContent(context),
        ],
      ),
    );
  }

  void routeClose(BuildContext context, DialogClosingState state) {
    Navigator.of(context, rootNavigator: true).pop(state);
  }

  Widget createDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        this.title != null
            ? Text(
                this.title ?? "",
                style: AppFontTitle.bold.font(
                  18,
                  AppColor.textOnLightPrimary,
                ),
              )
            : SizedBox.shrink(),
        this.title != null &&
                (this.description != null || this.primaryAction != null)
            ? Container(height: 16)
            : SizedBox.shrink(),
        this.description != null
            ? Text(
                this.description ?? "",
                style: AppFontContent.regular.font(
                  14,
                  AppColor.textOnLightPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              )
            : SizedBox.shrink(),
        (this.title != null || this.description != null) &&
                (this.primaryAction != null)
            ? Container(height: 32)
            : SizedBox.shrink(),
        this.primaryAction != null
            ? TextButton(
                child: Text("Add to cart".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)))),
                onPressed: () => null)
            : SizedBox.shrink(),
      ],
    );
  }

  Widget createCloseContent(BuildContext context) {
    if (this.closable ?? false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            color: AppColor.secondary,
            onPressed: () {
              routeClose(context, DialogClosingState.close);
            },
          )
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
