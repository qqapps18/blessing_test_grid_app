package com.example.blessingtestgridapp;

import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        System.out.println("[ANDRES] In Android");
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "flutter/MethodChannelDemo")
                .setMethodCallHandler(
                        (call, result) -> {
                            System.out.println("[ANDRES] In the callback. Method: " + call.method);
                            if (call.method.equals("Documents")) {
                                System.out.println("[ANDRES] In the if");
                                List<String> list = Arrays.asList("foo", "bar");
                                result.success(list);
                            } else {
                                System.out.println("[ANDRES] In the else");
                                result.notImplemented();
                            }
                        }
                );
    }

}
