package com.marinalexandru.elements

import android.os.Bundle
import com.google.android.gms.auth.api.signin.GoogleSignIn
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import java.util.*
import com.google.android.gms.fitness.request.DataReadRequest
import java.util.concurrent.TimeUnit
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.data.DataSource
import com.google.android.gms.fitness.data.Field


abstract class FitActivity : FlutterActivity() {

    // Channel description
    companion object {
        private const val fitChannel = "${BuildConfig.APPLICATION_ID}/fitSteps"
        private const val methodConnect = "connect"
        private const val methodGetTotalStepsFrom = "getTotalStepsFrom"
        private const val methodGetTodaySteps = "getTodaySteps"
        private const val methodGetDailyWeekSteps = "getDailyWeekSteps"
        private const val methodSubscribe = "subscribe"
        private const val methodIsSubscribed = "isSubscribed"
        private const val callbackConnected = "connected"
        private const val argFrom = "from" //time in milliseconds from last read
        private const val error = "fitError"
    }

    private val googleFitPermissionRequestCode = 100

    private val fitnessOptions by lazy {
        FitnessOptions.builder()
                .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                .addDataType(DataType.AGGREGATE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
                .build()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterView, fitChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                methodConnect -> connect()
                methodGetTodaySteps -> getTodaySteps(result)
                methodGetDailyWeekSteps -> getDailyWeekSteps(result)
                methodGetTotalStepsFrom -> getTotalStepsFrom(result, call)
                methodSubscribe -> subscribe(result)
                methodIsSubscribed -> isSubscribed(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun connect() {
        if (!GoogleSignIn.hasPermissions(GoogleSignIn.getLastSignedInAccount(this), fitnessOptions)) {
            GoogleSignIn.requestPermissions(this, googleFitPermissionRequestCode,
                    GoogleSignIn.getLastSignedInAccount(this),
                    fitnessOptions)
        } else {
            MethodChannel(flutterView, fitChannel).invokeMethod(callbackConnected, true)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if (requestCode == googleFitPermissionRequestCode) {
            MethodChannel(flutterView, fitChannel).invokeMethod(callbackConnected,
                    resultCode == Activity.RESULT_OK)
        }
    }

    private fun subscribe(result: MethodChannel.Result) {
        Fitness.getRecordingClient(this, GoogleSignIn.getLastSignedInAccount(this)!!)
                .subscribe(DataType.TYPE_STEP_COUNT_DELTA)
                .addOnSuccessListener { result.success(true) }
                .addOnFailureListener { result.success(false) }
    }

    private fun isSubscribed(result: MethodChannel.Result) {
        Fitness.getRecordingClient(this, GoogleSignIn.getLastSignedInAccount(this)!!)
                .listSubscriptions(DataType.TYPE_STEP_COUNT_DELTA)
                .addOnSuccessListener { subscriptions -> result.success(subscriptions.size > 0) }
                .addOnCanceledListener { result.error(error, "isSubscribed canceled", null) }
                .addOnFailureListener { result.error(error, "isSubscribed request failed", null) }
    }

    private fun getTodaySteps(result: MethodChannel.Result) {
        val lastSignInAccount = GoogleSignIn.getLastSignedInAccount(this)
        if (lastSignInAccount == null) {
            result.error(error, "lastSignInAccount from GoogleSignIn was null", null)
            return
        }
        Fitness.getHistoryClient(this, lastSignInAccount)
                .readDailyTotal(DataType.TYPE_STEP_COUNT_DELTA)
                .addOnFailureListener {
                    result.error(error, "Get history client failed. Details: ${it.message}", null)
                }
                .addOnSuccessListener {
                    if (it.dataPoints.size == 0) {
                        result.success("0")
                        return@addOnSuccessListener
                    }
                    result.success(it.dataPoints[0].getValue(Field.FIELD_STEPS).toString())
                }
    }

    private fun getTotalStepsFrom(result: MethodChannel.Result, call: MethodCall) {
        val to = Calendar.getInstance().timeInMillis
        val from = call.argument<String>(argFrom)
        if (from == null) {
            result.error(error, "from parameter missing or wrong type", null)
            return
        }
        val lastSignInAccount = GoogleSignIn.getLastSignedInAccount(this)
        if (lastSignInAccount == null) {
            result.error(error, "lastSignInAccount from GoogleSignIn was null", null)
            return
        }
        Fitness.getHistoryClient(this, lastSignInAccount)
                .readData(buildTotalStepsRequest(from.toLong(), to))
                .addOnFailureListener {
                    result.error(error, "Get history client failed. Details: ${it.message}", null)
                }
                .addOnSuccessListener {
                    if (it.buckets.size != 1) {
                        result.error(error, "Single bucket aggregation exception", null)
                        return@addOnSuccessListener
                    }
                    val dataSet = it.buckets[0].getDataSet(DataType.TYPE_STEP_COUNT_DELTA)
                    if (dataSet == null) {
                        result.error(error, "Single data set aggregation exception", null)
                        return@addOnSuccessListener
                    }
                    if (dataSet.dataPoints.size == 0) {
                        result.success("0")
                        return@addOnSuccessListener
                    }
                    result.success(dataSet.dataPoints[0].getValue(Field.FIELD_STEPS).toString())
                }
    }

    private fun getDailyWeekSteps(result: MethodChannel.Result) {
        val cal = Calendar.getInstance()
        val to = cal.timeInMillis
        cal.add(Calendar.WEEK_OF_YEAR, -1)
        val from = cal.timeInMillis

        val lastSignInAccount = GoogleSignIn.getLastSignedInAccount(this)
        if (lastSignInAccount == null) {
            result.error(error, "lastSignInAccount from GoogleSignIn was null", null)
            return
        }
        Fitness.getHistoryClient(this, lastSignInAccount)
                .readData(buildDailyWeekStepsRequest(from, to))
                .addOnFailureListener {
                    result.error(error, "Get history client failed. Details: ${it.message}", null)
                }
                .addOnSuccessListener {
                    val historySteps = arrayListOf("", "", "", "", "", "","")
                    if (it.buckets.size == 0) {
                        result.error(error, "Weekly bucket aggregation exception", null)
                        return@addOnSuccessListener
                    }
                    it.buckets.forEach { bucket ->
                        val dataSet = bucket.getDataSet(DataType.TYPE_STEP_COUNT_DELTA)
                        if (dataSet != null && dataSet.dataPoints.size == 1) {
                            historySteps[it.buckets.indexOf(bucket)] =
                                    dataSet.dataPoints[0].getValue(Field.FIELD_STEPS).toString()
                        }
                    }
                    result.success(historySteps)
                }
    }

    private fun buildDailyWeekStepsRequest(from: Long, to: Long) = DataReadRequest.Builder()
            .aggregate(buildDataSource(), DataType.AGGREGATE_STEP_COUNT_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(from, to, TimeUnit.MILLISECONDS)
            .build()


    private fun buildTotalStepsRequest(from: Long, to: Long) = DataReadRequest.Builder()
            .aggregate(buildDataSource(), DataType.AGGREGATE_STEP_COUNT_DELTA)
            .bucketByTime(((to - from).toInt()), TimeUnit.MILLISECONDS)
            .setTimeRange(from, to, TimeUnit.MILLISECONDS)
            .build()

    private fun buildDataSource() = DataSource.Builder()
            .setAppPackageName("com.google.android.gms")
            .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
            .setType(DataSource.TYPE_DERIVED)
            .setStreamName("estimated_steps")
            .build()
}