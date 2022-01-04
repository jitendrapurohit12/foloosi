package com.foloosi;

import android.content.Context;
import android.util.Log;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.foloosi.core.FPayListener;
import com.foloosi.core.FoloosiLog;
import com.foloosi.core.FoloosiPay;
import com.foloosi.models.OrderData;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FoloosiPlugin implements FlutterPlugin, MethodCallHandler
        , ActivityAware, FPayListener {

    private MethodChannel channel;

    private Context context;

    private Result result;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "foloosi");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, final @NonNull Result result) {
        try {
            if (call.method.equals("init")) {
                FoloosiPay.init(context, call.argument("public_key").toString());
            } else if (call.method.equals("makePayment")) {
                this.result = result;
                String orderObj = call.argument("order_data").toString();
                FoloosiPay.setPaymentListener(this);
                FoloosiPay.makePayment(getGSONObj().fromJson(orderObj, OrderData.class));
            } else if (call.method.equals("setLogVisible")) {
                FoloosiLog.setLogVisible(Boolean.parseBoolean(call.argument("visible").toString()));
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.context = binding.getActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    Gson getGSONObj() {
        return new GsonBuilder().create();
    }

    @Override
    public void onTransactionSuccess(String transactionId) {
        sendCallBack(true, transactionId, "Payment Success");
    }

    @Override
    public void onTransactionFailure(String error) {
        sendCallBack(false, null, error);
    }

    @Override
    public void onTransactionCancelled() {
        sendCallBack(false, null, "Payment Cancelled");
    }

    private void sendCallBack(boolean success, String transactionId, String message) {
        try {
            if (result != null) {
                JSONObject jsonObj = new JSONObject();
                jsonObj.put("success", success);
                jsonObj.put("message", message);
                jsonObj.put("transaction_id", transactionId);
                result.success(jsonObj.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
