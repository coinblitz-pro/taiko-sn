#!/bin/sh

set -e pipefail

ARGS="--l1.ws ${L1_ENDPOINT_WS}
    --l1.http ${L1_ENDPOINT_HTTP}
    --l1.beacon ${L1_BEACON_HTTP}
    --l2.http ${L2_ENDPOINT_HTTP}
    --l2.ws ${L2_ENDPOINT_WS}
    --raiko.l2 ${L2_ENDPOINT_HTTP}
    --taikoL1 ${TAIKO_L1_ADDRESS:-0x79C9109b764609df928d16fC4a91e9081F7e87DB}
    --taikoL2 ${TAIKO_L2_ADDRESS:-0x1670090000000000000000000000000000010001}
    --taikoToken ${TAIKO_TOKEN_L1_ADDRESS:-0x6490E12d480549D333499236fF2Ba6676C296011}
    --assignmentHookAddress ${ASSIGNMENT_HOOK_L1_ADDRESS:-0x9e640a6aadf4f664CF467B795c31332f44AcBe6c}
    --l1.proverPrivKey ${PRIVATE_KEY}
    --prover.capacity ${PROVER_CAPACITY:-1}
    --raiko.host ${RAIKO_HOST}
    --minTierFee.optimistic ${MIN_ACCEPTABLE_PROOF_FEE:-1}
    --minTierFee.sgx ${MIN_ACCEPTABLE_PROOF_FEE:-1}
    --minTierFee.sgxAndZkvm ${MIN_ACCEPTABLE_PROOF_FEE:-1}"

if [ -n "$PROVER_TOKEN_ALLOWANCE" ]; then
    ARGS="${ARGS} --prover.allowance ${PROVER_TOKEN_ALLOWANCE}"
fi

if [ -n "$PROVER_MIN_ETH_BALANCE" ]; then
    ARGS="${ARGS} --prover.minEthBalance ${PROVER_MIN_ETH_BALANCE}"
fi

if [ -n "$PROVER_MIN_TKO_BALANCE" ]; then
    ARGS="${ARGS} --prover.minTaikoTokenBalance ${PROVER_MIN_TKO_BALANCE}"
fi

# TXMGR Settings
if [ -n "$TX_FEE_LIMIT_MULTIPLIER" ]; then
    ARGS="${ARGS} --tx.feeLimitMultiplier ${TX_FEE_LIMIT_MULTIPLIER}"
fi

if [ -n "$TX_FEE_LIMIT_THRESHOLD" ]; then
    ARGS="${ARGS} --tx.feeLimitThreshold ${TX_FEE_LIMIT_THRESHOLD}"
fi

if [ -n "$TX_GAS_LIMIT" ]; then
    ARGS="${ARGS} --tx.gasLimit ${TX_GAS_LIMIT}"
else
    ARGS="${ARGS} --tx.gasLimit 3000000"
fi

if [ -n "$TX_MIN_BASEFEE" ]; then
    ARGS="${ARGS} --tx.minBaseFee ${TX_MIN_BASEFEE}"
fi

if [ -n "$TX_MIN_TIP_CAP" ]; then
    ARGS="${ARGS} --tx.minTipCap ${TX_MIN_TIP_CAP}"
fi

if [ -n "$TX_NOT_IN_MEMPOOL" ]; then
    ARGS="${ARGS} --tx.notInMempoolTimeout ${TX_NOT_IN_MEMPOOL}"
fi

if [ -n "$TX_NUM_CONFIRMATIONS" ]; then
    ARGS="${ARGS} --tx.numConfirmations ${TX_NUM_CONFIRMATIONS}"
fi

if [ -n "$TX_RECEIPT_QUERY" ]; then
    ARGS="${ARGS} --tx.receiptQueryInterval ${TX_RECEIPT_QUERY}"
fi

if [ -n "$TX_RESUBMISSION" ]; then
    ARGS="${ARGS} --tx.resubmissionTimeout ${TX_RESUBMISSION}"
fi

if [ -n "$TX_SAFE_ABORT_NONCE_TOO_LOW" ]; then
    ARGS="${ARGS} --tx.safeAbortNonceTooLowCount ${TX_SAFE_ABORT_NONCE_TOO_LOW}"
fi

if [ -n "$TX_SEND_TIMEOUT" ]; then
    ARGS="${ARGS} --tx.sendTimeout ${TX_SEND_TIMEOUT}"
fi

taiko-client prover ${ARGS}
