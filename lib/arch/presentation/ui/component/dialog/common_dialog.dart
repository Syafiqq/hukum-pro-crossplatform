import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/dialog_closing_state.dart';

class CommonDialog extends StatelessWidget {
  final bool? closable;
  final String? title;
  final String? description;

  CommonDialog({this.closable, this.title, this.description}) : super();

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
              child: Column(
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
                  this.title != null && this.description != null
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
                ],
              ),
            ),
          ),
          this.closable ?? false
              ? Row(
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
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void routeClose(BuildContext context, DialogClosingState state) {
    Navigator.of(context, rootNavigator: true).pop(state);
  }
}
