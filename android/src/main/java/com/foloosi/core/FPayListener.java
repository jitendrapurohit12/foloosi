package com.foloosi.core;

public interface FPayListener {

    void onTransactionSuccess(String transactionId);

    void onTransactionFailure(String error);

    void onTransactionCancelled();

}
