import 'package:flutter/material.dart';
import 'package:queue_token/constants.dart';
import 'package:queue_token/models/MyStaff.dart';
import 'package:queue_token/responsive.dart';

class StaffInfoCards extends StatelessWidget {
  final StaffInfo info;

  const StaffInfoCards({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      alignment: Alignment.center,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              info.pngSrc!,
              height: !Responsive.isMobile(context) ? 54 : 44,
            ),
            flex: 2,
          ),
          // SizedBox(
          //   width: 80.0,
          // ),
          Expanded(
              child: Text(
                info.title!,
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              flex: 2),
        ],
      ),
    );
  }
}
