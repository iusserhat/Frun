(define-fungible-token fracton-fft)

(define-map excluded-from-fee
  { account: principal }
  { is-excluded: bool }
)

(define-public (swap-mint (amount uint) (to principal))
  (begin
    (asserts! (is-eq tx-sender (get-swap-address)) "Unauthorized")
    (ft-mint? fracton-fft amount to)
  )
)

(define-public (update-fees (vault-percent uint) (pf-vault-percent uint))
  (begin
    (asserts! (is-eq tx-sender (get-dao-address)) "Unauthorized")
    (ok (tuple (vault-percent vault-percent) (pf-vault-percent pf-vault-percent)))
  )
)

(define-read-only (is-excluded-from-fee (account principal))
  (map-get? excluded-from-fee { account: account })
)

(define-public (transfer-with-fees (from principal) (to principal) (amount uint))
  (begin
    (let (
      (excluded (default-to false (get is-excluded (map-get? excluded-from-fee { account: from }))))
      (vault-fee (if excluded u0 (/ (* amount vault-percent) u100)))
      (pf-vault-fee (if excluded u0 (/ (* amount pf-vault-percent) u100)))
      (net-amount (- (- amount vault-fee) pf-vault-fee))
    )
    (ft-transfer? fracton-fft net-amount from to)
    (ft-transfer? fracton-fft vault-fee from (get-vault-address))
    (ft-transfer? fracton-fft pf-vault-fee from (get-pf-vault-address))
    (ok true)
  )
)
