import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/button_cta_type.dart';
import 'package:hukum_pro/common/ui/dialog_closing_state.dart';

const _kDefaultStyle = ButtonCtaType.outline(
    false, AppColor.background, AppColor.textOnLightPrimary);

class CommonDialog extends StatelessWidget {
  final bool? closable;
  final String? title;
  final String? description;
  final String? primaryAction;
  final ButtonCtaType primaryStyle;

  CommonDialog(
      {this.closable,
      this.title,
      this.description,
      this.primaryAction,
      this.primaryStyle = _kDefaultStyle})
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
            ? Container(height: 24)
            : SizedBox.shrink(),
        this.primaryAction != null
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 196,
                  maxWidth: 256,
                ),
                child: TextButton(
                  child: Text(
                    (primaryAction ?? "").toUpperCase(),
                    style: AppFontTitle.bold.font(
                      14,
                      null,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.fromLTRB(16, 12, 16, 12),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all(primaryStyle.foregroundColor),
                    backgroundColor:
                        MaterialStateProperty.all(primaryStyle.backgroundColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: primaryStyle is ButtonCtaTypeOutline
                            ? BorderSide(
                                color: primaryStyle.foregroundColor,
                              )
                            : BorderSide.none,
                      ),
                    ),
                  ),
                  onPressed: () => null,
                ),
              )
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
