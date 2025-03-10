package com.tencent.qcloud.tuikit.tuicallkit.viewmodel.component.floatview

import com.tencent.cloud.tuikit.engine.call.TUICallDefine
import com.tencent.qcloud.tuikit.tuicallkit.data.User
import com.tencent.qcloud.tuikit.tuicallkit.state.TUICallState
import com.tencent.qcloud.tuikit.tuicallkit.view.component.floatview.FloatWindowService
import com.trtc.tuikit.common.livedata.LiveData

class FloatingWindowViewModel {
    public var selfUser: User
    public var remoteUser: User
    public var remoteUserList: LinkedHashSet<User>
    public var timeCount = LiveData<Int>()
    public var scene = LiveData<TUICallDefine.Scene>()
    public var mediaType = LiveData<TUICallDefine.MediaType>()

    init {
        this.scene = TUICallState.instance.scene
        this.selfUser = TUICallState.instance.selfUser.get()
        this.mediaType = TUICallState.instance.mediaType
        remoteUserList = TUICallState.instance.remoteUserList.get()
        if (remoteUserList != null && remoteUserList.size > 0) {
            remoteUser = remoteUserList.first()
        } else {
            remoteUser = User()
        }
        this.timeCount = TUICallState.instance.timeCount
    }

    fun stopFloatService() {
        FloatWindowService.stopService()
    }
}