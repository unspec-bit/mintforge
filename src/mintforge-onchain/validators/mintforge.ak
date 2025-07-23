use aiken/collection/dict
use aiken/collection/list
use cardano/address.{Script}
use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction}

pub type Action {
  Mint
  Burn
}

validator mintforge(token_name: ByteArray, utxo_ref: OutputReference) {
  mint(redeemer: Action, policy_id: PolicyId, transaction: Transaction) {
    let Transaction { inputs, mint, .. } = transaction
    expect [Pair(asset_name, amount)] =
      mint |> assets.tokens(policy_id) |> dict.to_pairs()
    when redeemer is {
      Mint -> {
        trace @"asset_name": asset_name

        expect
          list.any(inputs, fn(input) { input.output_reference == utxo_ref })
        amount == 1 && asset_name == token_name
      }
      Burn -> amount == -1 && asset_name == token_name
    }
  }

  spend(_d, _r, own_ref: OutputReference, tx: Transaction) {
    let Transaction { mint, inputs, .. } = tx
    expect Some(own_input) =
      list.find(inputs, fn(input) { input.output_reference == own_ref })
    expect Script(policy_id) = own_input.output.address.payment_credential
    expect [Pair(asset_name, amount)] =
      mint
        |> assets.tokens(policy_id)
        |> dict.to_pairs()

    amount == -1 && asset_name == token_name
  }

  else(_) {
    fail
  }
}
