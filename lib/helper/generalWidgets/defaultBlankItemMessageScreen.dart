import 'package:greenfield_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
class DefaultBlankItemMessageScreen extends StatefulWidget {
  final String image, title, description;
  final Function? callback;
  final String? btntext;

  DefaultBlankItemMessageScreen(
      {Key? key,
      this.callback,
      this.btntext,
      required this.image,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  State<DefaultBlankItemMessageScreen> createState() =>
      DefaultBlankItemMessageScreenState();
}

class DefaultBlankItemMessageScreenState
    extends State<DefaultBlankItemMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsetsDirectional.all(Constant.paddingOrMargin30),
      child: Column(children: [
        Container(
            width: 200,
            height: 200,
            margin: EdgeInsets.only(bottom: 50),
            child: Center(
              child: Widgets.defaultImg(image: widget.image),
            ),
            decoration: ShapeDecoration(
              color: ColorsRes.defaultPageInnerCircle,
              shape: CircleBorder(
                side: BorderSide(
                    width: 20, color: ColorsRes.defaultPageOuterCircle),
              ),
            )),
        Text(
          widget.title,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.merge(
                TextStyle(
                    color: ColorsRes.appColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5),
              ),
        ),
        SizedBox(height: 10),
        Text(
          widget.description,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.merge(
                TextStyle(letterSpacing: 0.5),
              ),
        ),
        if (widget.callback != null) SizedBox(height: 20),
        if (widget.callback != null)
          ElevatedButton(
            onPressed: () {
              widget.callback!();
            },
            child: Text(
              widget.btntext!,
              softWrap: true,
            ),
          )
      ]),
    );
  }
}
