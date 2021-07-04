import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';
import 'package:hukum_pro/common/ui/dialog_closing_state.dart';

class CommonDialog extends StatelessWidget {
  final bool? closable;
  final Function(DialogClosingState state)? onDismissed;
  final bool? autoCloseOnAction;

  CommonDialog({this.closable, this.onDismissed, this.autoCloseOnAction})
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.shrink(),
            ],
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
    if (autoCloseOnAction ?? true) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    var onDismissed = this.onDismissed;
    if (onDismissed != null) {
      onDismissed(state);
    }
  }
}
