package com.example.blessingtestgridapp;

import androidx.annotation.NonNull;

import com.example.blessingtestgridapp.HebrewDate.HebrewDate;

import java.util.ArrayList;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


public class MainActivity extends FlutterActivity {
    String leapyear;
    ArrayList<String> listdates = new ArrayList<String>();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        System.out.println("[ANDRES] In Android");
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "flutter/MethodChannelDemo")
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("Documents")) {
                                HebrewDate date = new HebrewDate();
                                listdates.add(date.getHebrewDateAsString());
                                listdates.add(Integer.toString(HebrewDate.CURRENT_HDAY));
                                listdates.add(HebrewDate.CURRENT_HMONTH);
                                listdates.add(Integer.toString(HebrewDate.CURRENT_HYEAR));

                                if(HebrewDate.IS_LEAP_YEAR == true) {
                                    leapyear = "1";
                                    listdates.add(leapyear);
                                } else {
                                    leapyear = "0";
                                    listdates.add(leapyear);
                                }

                                calendar= Calendar.getInstance();
                                tday = calendar.get(Calendar.DAY_OF_MONTH);
                                tmonth = calendar.get(Calendar.MONTH);
                                tyear = calendar.get(Calendar.YEAR);

                                DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.MEDIUM);

/* ------------------- fecha dia anterior (ayer) ----------------------------- */
                                Date diayurzaityesterday = new Date((tday - 1900), (tmonth - 1), (tday - 1));
                                hebrewDateYurzaitString = dateFormat.format(diayurzaityesterday);

                                HebrewDate hebrewDateYurzaityesterday = new HebrewDate(diayurzaityesterday);
                                listdates.add(Integer.toString(HebrewDate.CURRENT_HDAY));
                                listdates.add(HebrewDate.CURRENT_HMONTH);
                                listdates.add(Integer.toString(HebrewDate.CURRENT_HYEAR));

/* ------------------- fecha dia 2 antes(antiayer) ----------------------------- */
                                Date diayurzaitdaybefore = new Date((tday - 1900), (tmonth - 1), (tday - 2));
                                hebrewDateYurzaitString = dateFormat.format(diayurzaitdaybefore);

                                HebrewDate hebrewDateYurzaitdaybafore = new HebrewDate(diayurzaitdaybefore);
                                listdates.add(Integer.toString(HebrewDate.CURRENT_HDAY));
                                listdates.add(HebrewDate.CURRENT_HMONTH);
                                listdates.add(Integer.toString(HebrewDate.CURRENT_HYEAR));

                                System.out.println("[ANDRES] In Android  " + listdates);

                                result.success(listdates);
                            } else {
                                System.out.println("[ANDRES] In the else");
                                result.notImplemented();
                            }
                        }
                );
    }

}
