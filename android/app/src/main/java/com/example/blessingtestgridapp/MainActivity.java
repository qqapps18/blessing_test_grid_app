package com.example.blessingtestgridapp;

import androidx.annotation.NonNull;

import com.example.blessingtestgridapp.HebrewDate.HebrewDate;

import java.util.ArrayList;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    ArrayList<String> listdates = new ArrayList<String>();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        System.out.println("[ANDRES] In Android");
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "flutter/MethodChannelDemo")
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("Documents")) {
                                listdates.add("Some Value");
                                result.success(listdates);
/*                                result.success(date.getHebrewDateAsString());   */
                            } else {
                                System.out.println("[ANDRES] In the else");
                                result.notImplemented();
                            }
                        }
                );
    }

}
