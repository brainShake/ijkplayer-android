# `:ijkmedia` Gradle 模块

本模块是工程内 **JNI/C++ 的唯一源码树**（`ijkplayer/`、`ijksdl/`、`ijkj4a/` 等）。在 Android Studio 中直接在此修改 native 代码并编译。

## 文档

| 文档 | 内容 |
|------|------|
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | 目录结构、分层、线程、生命周期（**建议先读**） |
| [../docs/JNI_ARCHITECTURE.md](../docs/JNI_ARCHITECTURE.md) | Java ↔ JNI ↔ so 协作 |
| [../docs/JNI_INDEX.md](../docs/JNI_INDEX.md) | `g_methods[]` 与 C 函数对照 |

## 编译

```bat
gradlew :ijkmedia:assembleDebug
```

`ijk.devAbi` 见根目录 `gradle.properties`（默认 `arm64-v8a`）。
