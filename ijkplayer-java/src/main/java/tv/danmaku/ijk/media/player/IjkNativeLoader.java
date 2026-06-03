package tv.danmaku.ijk.media.player;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Build;
import android.util.Log;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 按顺序加载 IJK 三个 native 库（ffmpeg → sdl → player）。
 * <p>
 * 加载成功后 libijkplayer.so 的 {@code JNI_OnLoad} 会执行 RegisterNatives。
 * 若 APK 无 .so（约 2MB 安装包），会在此抛出 UnsatisfiedLinkError。
 */
public final class IjkNativeLoader {
    private static final String TAG = "IjkNativeLoader";

    private IjkNativeLoader() {
    }

    public static void load(Context context, String libName) {
        try {
            System.loadLibrary(libName);
            return;
        } catch (UnsatisfiedLinkError first) {
            if (context == null) {
                throw first;
            }
            File so = findNativeLibrary(context, libName);
            if (so != null) {
                System.load(so.getAbsolutePath());
                return;
            }
            ApplicationInfo ai = context.getApplicationInfo();
            long apkBytes = 0;
            if (ai.sourceDir != null) {
                apkBytes = new File(ai.sourceDir).length();
            }
            throw new UnsatisfiedLinkError(
                    "lib" + libName + ".so not loadable. apkBytes=" + apkBytes
                            + " (expect ~3e7). nativeLibraryDir=" + ai.nativeLibraryDir
                            + " ABIs=" + join(Build.SUPPORTED_ABIS)
                            + " onDisk=[" + listInstalledSoNames(context) + "]. "
                            + "Install: gradlew :ijkplayer-example:installAll64Debug "
                            + "(disable Android Studio Apply Changes).");
        }
    }

    private static String join(String[] items) {
        if (items == null || items.length == 0) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (String s : items) {
            if (sb.length() > 0) {
                sb.append(',');
            }
            sb.append(s);
        }
        return sb.toString();
    }

    private static File findNativeLibrary(Context context, String libName) {
        String fileName = "lib" + libName + ".so";
        List<File> roots = new ArrayList<>();
        ApplicationInfo ai = context.getApplicationInfo();
        if (ai.nativeLibraryDir != null) {
            roots.add(new File(ai.nativeLibraryDir));
        }
        File dataDir = new File(ai.dataDir);
        roots.add(new File(dataDir.getParent(), "lib"));
        roots.add(new File(dataDir, "lib"));
        for (String abi : Build.SUPPORTED_ABIS) {
            roots.add(new File(ai.nativeLibraryDir != null ? ai.nativeLibraryDir : dataDir.getPath(), abi));
        }
        for (File root : roots) {
            if (root == null) {
                continue;
            }
            File direct = new File(root, fileName);
            if (direct.isFile()) {
                return direct;
            }
            if (root.isDirectory()) {
                File[] children = root.listFiles();
                if (children != null) {
                    for (File child : children) {
                        if (child.isDirectory()) {
                            File nested = new File(child, fileName);
                            if (nested.isFile()) {
                                return nested;
                            }
                        }
                    }
                }
            }
        }
        return null;
    }

    private static String listInstalledSoNames(Context context) {
        StringBuilder installed = new StringBuilder();
        ApplicationInfo ai = context.getApplicationInfo();
        collectSoNames(new File(ai.nativeLibraryDir), installed);
        File libRoot = new File(new File(ai.dataDir).getParent(), "lib");
        collectSoNames(libRoot, installed);
        if (libRoot.isDirectory()) {
            File[] abiDirs = libRoot.listFiles();
            if (abiDirs != null) {
                for (File abiDir : abiDirs) {
                    if (abiDir.isDirectory()) {
                        collectSoNames(abiDir, installed);
                    }
                }
            }
        }
        return installed.toString();
    }

    private static void collectSoNames(File dir, StringBuilder installed) {
        if (dir == null || !dir.isDirectory()) {
            return;
        }
        File[] files = dir.listFiles();
        if (files == null) {
            return;
        }
        for (File f : files) {
            if (f.getName().endsWith(".so")) {
                if (installed.length() > 0) {
                    installed.append(' ');
                }
                installed.append(f.getName());
            }
        }
    }
}
