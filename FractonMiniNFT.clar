(define-non-fungible-token fracton-mini-nft uint)

(define-data-var current-round uint u0)
(define-data-var sale-is-active bool false)
(define-data-var blind-box-price uint u1000000000000000000) ;; 0.1 ETH
(define-data-var round-cap uint u1000)

(define-map round-success
  { round-id: uint }
  { is-success: bool }
)

(define-map total-amount
  { token-id: uint }
  { amount: uint }
)

(define-public (start-new-round (selling-price uint))
  (begin
    (asserts! (not (var-get sale-is-active)) "Active sale exists")
    (var-set blind-box-price selling-price)
    (var-set current-round (+ (var-get current-round) u1))
    (var-set sale-is-active true)
    (ok true)
  )
)

(define-public (close-round)
  (begin
    (var-set sale-is-active false)
    (ok true)
  )
)

(define-public (mint-blind-box (amount uint))
  (begin
    (asserts! (var-get sale-is-active) "Sale is not active")
    (asserts! (is-eq tx-sender (get-dao-address)) "Unauthorized")
    ;; Update total amount for the current round
    (map-set total-amount
      { token-id: (var-get current-round) }
      { amount: (+ (default-to u0 (get amount (map-get? total-amount { token-id: (var-get current-round) }))) amount) }
    )
    (nft-mint? fracton-mini-nft (var-get current-round) tx-sender)
  )
)
