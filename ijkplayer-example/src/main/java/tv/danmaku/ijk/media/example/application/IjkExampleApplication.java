package tv.danmaku.ijk.media.example.application;

import android.app.Application;
import android.util.Log;

import tv.danmaku.ijk.media.player.IjkMediaPlayer;
import tv.danmaku.ijk.media.player.IjkNativeLoader;

public class IjkExampleApplication extends Application {
    private static final String TAG = "IjkExampleApplication";

    @Override
    public void onCreate() {
        super.onCreate();
        try {
            IjkMediaPlayer.loadLibrariesOnce(libName -> IjkNativeLoader.load(this, libName));
        } catch (UnsatisfiedLinkError e) {
            Log.e(TAG, e.getMessage());
            throw e;
        }
    }
}
