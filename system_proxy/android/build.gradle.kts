import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.library")
}

group = "com.nove8.system_proxy_service"
version = "1.0-SNAPSHOT"

val compileSdkVer = 36
val minSdkVer = 24

android {
    namespace = "com.nove8.system_proxy_service"
    compileSdk = compileSdkVer

    compileOptions {
        val javaVersion = JavaVersion.VERSION_17
        sourceCompatibility = javaVersion
        targetCompatibility = javaVersion
    }

    defaultConfig {
        minSdk = minSdkVer
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

dependencies {
    implementation(project(":common_plugin"))
}
