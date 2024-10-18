import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:tencent_calls_uikit/src/boot.dart';
import 'package:tencent_calls_uikit/src/call_state.dart';
import 'package:tencent_calls_uikit/src/data/constants.dart';
import 'package:tencent_calls_uikit/src/data/user.dart';
import 'package:tencent_calls_uikit/src/extensions/calling_bell_feature.dart';
import 'package:tencent_calls_uikit/src/extensions/trtc_logger.dart';
import 'package:tencent_calls_uikit/src/platform/tuicall_kit_platform_interface.dart';
import 'package:tencent_calls_uikit/src/ui/tuicall_kit_widget.dart';
import 'package:tencent_calls_uikit/src/ui/widget/inviteuser/invite_user_widget.dart';
import 'package:tencent_calls_uikit/src/utils/string_stream.dart';
import 'package:uuid/uuid.dart';

class TUICallKitNavigatorObserver extends NavigatorObserver {
  static final TUICallKitNavigatorObserver _instance =
      TUICallKitNavigatorObserver();
  static bool isClose = true;
  static CallPage currentPage = CallPage.none;
  late String _currentUuid;
  final Uuid _uuid = const Uuid();

  static TUICallKitNavigatorObserver getInstance() {
    return _instance;
  }

  TUICallKitNavigatorObserver() {
    TRTCLogger.info('TUICallKitNavigatorObserver Init');
    Boot.instance;
  }

  void enterCallingPage() async {
    if (!isClose) {
      return;
    }
    print('开始通话,使用我们的ui');
    // currentPage = CallPage.callingPage;
    // TUICallKitNavigatorObserver.getInstance()
    //     .navigator
    //     ?.push(MaterialPageRoute(builder: (widget) {
    //   return TUICallKitWidget(close: () {
    //     if (!isClose) {
    //       isClose = true;
    //       TUICallKitPlatform.instance.stopForegroundService();
    //       CallingBellFeature.stopRing();
    //       TUICallKitNavigatorObserver.getInstance().exitCallingPage();
    //     }
    //   });
    // }));
    // 使用我们的ui
    _currentUuid = _uuid.v4();
    var showName = '';
    var avatar = '';
    if (CallState.instance.remoteUserList.isNotEmpty) {
      showName = User.getUserDisplayName(CallState.instance.remoteUserList[0]);
      avatar = StringStream.makeNull(
          CallState.instance.remoteUserList[0].avatar, Constants.defaultAvatar);
    }
    CallKitParams params = CallKitParams(
        id: _currentUuid,
        nameCaller: showName,
        type: 0,
        avatar: avatar,
        extra: <String, dynamic>{'userId': ''},
        ios: const IOSParams(handleType: 'generic'));
    // await FlutterCallkitIncoming.startCall(params);
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    isClose = false;
  }

  void exitCallingPage() async {
    if (currentPage == CallPage.inviteUserPage) {
      TUICallKitNavigatorObserver.getInstance().navigator?.pop();
      TUICallKitNavigatorObserver.getInstance().navigator?.pop();
    } else if (currentPage == CallPage.callingPage) {
      TUICallKitNavigatorObserver.getInstance().navigator?.pop();
    }
    currentPage = CallPage.none;
  }

  void enterInviteUserPage() {
    if (currentPage == CallPage.callingPage) {
      currentPage = CallPage.inviteUserPage;
      TUICallKitNavigatorObserver.getInstance()
          .navigator
          ?.push(MaterialPageRoute(builder: (widget) {
        return const InviteUserWidget();
      }));
    }
  }

  void exitInviteUserPage() {
    currentPage = CallPage.callingPage;
    TUICallKitNavigatorObserver.getInstance().navigator?.pop();
  }
}

enum CallPage { none, callingPage, inviteUserPage }
