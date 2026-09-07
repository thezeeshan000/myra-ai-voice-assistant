# Preserve OkHttp
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Preserve JSON
-keep class org.json.** { *; }
-dontwarn org.json.**

# Preserve Kotlin coroutines
-keep class kotlin.coroutines.** { *; }
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# Keep Android Architecture Components
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**

# App classes
-keep class com.myra.assistant.** { *; }
-dontwarn com.myra.assistant.**

# Generic obfuscation
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
