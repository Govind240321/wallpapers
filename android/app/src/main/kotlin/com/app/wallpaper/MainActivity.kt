package com.app.wallpaper

import com.example.google_native_mobile_ads.NativeAdFactoryImplementation
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val factory: NativeAdFactory =
            NativeAdFactoryImplementation(layoutInflater) // reference to this package created factory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "google_native_mobile_ads_AdFactory",
            factory
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(
            flutterEngine,
            "google_native_mobile_ads_AdFactory"
        )
    }
}
