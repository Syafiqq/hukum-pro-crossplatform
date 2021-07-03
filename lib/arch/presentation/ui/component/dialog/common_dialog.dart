import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';

const double _kPadding = 20;
const double _kAvatarRadius = 45;

class CommonDialog extends StatelessWidget {
  final String tmpTitle, tmpDescription, tmpText;
  final Image tmpImg;

  final String? title;
  final bool? closable;

  CommonDialog(this.tmpTitle, this.tmpDescription, this.tmpText, this.tmpImg,
      {this.title, this.closable})
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
