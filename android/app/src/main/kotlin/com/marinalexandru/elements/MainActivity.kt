package com.marinalexandru.elements

import android.os.Bundle

import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FitActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

    }

}
