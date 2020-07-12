package com.example.blessing_test_grid_app
package com.qqapps.blessing_test_grid_app.HebrewDate;

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    private var jodesh: String? = null
    private var yom = 0
    private var shana = 0
    private var yomview: String? = null
    private var leapyear: Boolean? = null
    private var isLeapYear = 0
    var listdates: MutableList<String> = mutableListOf<String>()
    var name: MutableList<String> = mutableListOf<String>()



    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val date = HebrewDate()
        yomview = date.getHebrewDateAsString()
        yom = HebrewDate.CURRENT_HDAY
        jodesh = HebrewDate.CURRENT_HMONTH
        shana = HebrewDate.CURRENT_HYEAR
        leapyear = HebrewDate.IS_LEAP_YEAR

        if (leapyear == true) {
            isLeapYear = 1
        } else {
            isLeapYear = 0
        }


        println("esto deberia ser la fecha")
        println(date)
        println(yom)
        println(jodesh)
        println(shana)
        println(isLeapYear)
        println(yomview)
        println("*************************")

        listdates.add(yom.toString())
        listdates.add(jodesh.toString())
        listdates.add(shana.toString())
        listdates.add(isLeapYear.toString())
        listdates.add(yomview.toString())

        for (element in listdates) {
            println(element)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter/MethodChannelDemo").setMethodCallHandler { call, result ->
            if (call.method == "Documents") {
                result.success(listdates)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sayHello(name: MutableList<String>): MutableList<String> {
        name.add(listdates[0])
        name.add(listdates[1])
        name.add(listdates[2])
        name.add(listdates[3])
        name.add(listdates[4])
        for (element in name) {
            println(element)
        }
        return this.name

    }
}
