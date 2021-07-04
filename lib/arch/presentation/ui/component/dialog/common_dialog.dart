import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/app_font.dart';
import 'package:hukum_pro/common/ui/dialog_closing_state.dart';

class CommonDialog extends StatelessWidget {
  final bool? closable;
  final String? title;

  CommonDialog({this.closable, this.title}) : super();

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
            padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Container(
              color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  this.title != null
                      ? Center(
                          child: Text(
                            this.title ?? "",
                            style: AppFontTitle.bold.font(
                              16,
                              AppColor.textOnLightPrimary,
                            ),
                          ),
                        )
                      : SizedBox.shrink()
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
