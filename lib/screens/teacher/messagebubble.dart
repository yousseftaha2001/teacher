import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  final String message;
  final String userName;
  final bool isMe;
  final Key key;
  final DateTime datet;

  Message({this.message, this.userName, this.isMe, this.key, this.datet});

  @override
  Widget build(BuildContext context) {
    String format = DateFormat.jm().format(datet);
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft:
                          !isMe ? Radius.circular(0) : Radius.circular(12),
                      bottomRight:
                          isMe ? Radius.circular(0) : Radius.circular(12),
                    ),
                  ),
                  width: 140,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            isMe ? "" : userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Colors.grey
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .title
                                      .color,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        message,
                        style: TextStyle(
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .bodyText1
                                  .color,
                        ),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                      //here is the time;
                      Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Text(
                            format,
                            style: TextStyle(
                                color: isMe ? Colors.grey : Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
