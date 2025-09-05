plugins {
    // id("com.google.gms.google-services") version "4.4.3" apply false // Removed to re-run flutterfire configure
    id("com.android.application") version "8.9.1" apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
    id("com.google.firebase.firebase-perf") version "2.0.1" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // classpath("com.google.gms:google-services:4.4.3") // Removed to avoid plugin version conflict
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
