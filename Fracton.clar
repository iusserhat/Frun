(define-fungible-token fracton-ft)

;; Kurucu fonksiyon yerine başlangıçta token dağıtımı için bir fonksiyon.
(define-public (initialize-contract)
    (ft-mint? fracton-ft u100000000000000000000000000 tx-sender))

;; Token yakma işlevi
(define-public (burn-fracton (amount uint))
    (ft-burn? fracton-ft amount tx-sender))
