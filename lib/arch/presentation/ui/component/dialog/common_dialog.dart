import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';

class CommonDialog extends StatelessWidget {
  final String? title;
  final bool? closable;

  CommonDialog({this.title, this.closable}) : super();

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
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    )
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
