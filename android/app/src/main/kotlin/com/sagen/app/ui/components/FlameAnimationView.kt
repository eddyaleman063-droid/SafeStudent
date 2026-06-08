package com.sagen.app.ui.components

import android.content.Context
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.ComposeView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

object MainActivityFlameBridge {
    var view: FlameAnimationView? = null
}

class FlameAnimationView(context: Context, id: Int) : PlatformView {
    private val composeView = ComposeView(context)
    private var phaseState by mutableStateOf(FlamePhase.IDLE)

    init {
        composeView.setContent {
            FlameAnimationComplete(phase = phaseState)
        }
        MainActivityFlameBridge.view = this
    }

    fun setPhase(newPhase: FlamePhase) {
        phaseState = newPhase
    }

    override fun getView() = composeView

    override fun dispose() {
        MainActivityFlameBridge.view = null
    }
}

class FlameAnimationViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return FlameAnimationView(context, viewId)
    }
}
