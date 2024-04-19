(define-data-var vesting-token principal 'ST12345)

(define-map vesting-schedules
  { vesting-location: principal }
  {
    is-revocable: bool,
    duration: uint,
    cliff-duration: uint,
    interval: uint
  }
)

(define-map token-grants
  { grant-holder: principal }
  {
    vesting-location: principal,
    is-active: bool,
    was-revoked: bool
  }
)

(define-public (withdraw-tokens (beneficiary principal) (amount uint))
  (begin
    (ft-transfer? fracton-ft amount (as-contract tx-sender) beneficiary)
  )
)

(define-public (claim-vesting-tokens (beneficiary principal))
  ;; Vesting token talebi işlevi
  (ok true)
)

(define-public (revoke-grant (grant-holder principal))
  ;; Grant iptal işlevi
  (ok true)
)

;; Sadece sahibi veya belirli bir hesap tarafından çalıştırılabilir işlevleri kontrol eden bir modifier ekleyebiliriz.
(define-read-only (only-owner-or-self (account principal))
  (or (is-eq tx-sender (contract-caller)) (is-eq tx-sender account))
)
