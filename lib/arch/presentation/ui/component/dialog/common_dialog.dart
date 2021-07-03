import 'package:flutter/material.dart';
import 'package:hukum_pro/common/ui/app_color.dart';

const double _kPadding = 20;
const double _kAvatarRadius = 45;

class CommonDialog extends StatefulWidget {
  final String tmpTitle, tmpDescription, tmpText;
  final Image tmpImg;

  final String? title;
  final bool? closable;

  CommonDialog(this.tmpTitle, this.tmpDescription, this.tmpText, this.tmpImg,
      {this.title, this.closable})
      : super();

  @override
  _CommonDialogState createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CommonDialog> {
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
            children: [SizedBox.shrink()],
          ),
          this.widget.closable ?? false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: AppColor.secondary,
                      onPressed: () {},
                    )
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: _kPadding,
              top: _kAvatarRadius + _kPadding,
              right: _kPadding,
              bottom: _kPadding),
          margin: EdgeInsets.only(top: _kAvatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(_kPadding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.tmpTitle,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.tmpDescription,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.tmpText,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: _kPadding,
          right: _kPadding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: _kAvatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(_kAvatarRadius)),
                child: widget.tmpImg),
          ),
        ),
      ],
    );
  }
}
