;; Benefit Sharing Contract
;; Manages compensation for commercial applications

(define-map benefit-agreements
  { knowledge-id: uint, user: principal }
  {
    payment-amount: uint,
    payment-frequency: uint,
    last-payment: uint,
    active: bool
  }
)

(define-map benefit-recipients
  { knowledge-id: uint }
  { recipients: (list 10 { recipient: principal, share: uint }) }
)

(define-public (create-benefit-agreement (knowledge-id uint)
                                        (payment-amount uint)
                                        (payment-frequency uint))
  (ok (map-set benefit-agreements
    { knowledge-id: knowledge-id, user: tx-sender }
    {
      payment-amount: payment-amount,
      payment-frequency: payment-frequency,
      last-payment: u0,
      active: true
    }
  ))
)

(define-public (set-benefit-recipients (knowledge-id uint)
                                      (recipients (list 10 { recipient: principal, share: uint })))
  (ok (map-set benefit-recipients
    { knowledge-id: knowledge-id }
    { recipients: recipients }
  ))
)

(define-public (make-payment (knowledge-id uint))
  (let
    (
      (agreement (map-get? benefit-agreements { knowledge-id: knowledge-id, user: tx-sender }))
      (recipients-data (map-get? benefit-recipients { knowledge-id: knowledge-id }))
    )
    (asserts! (and (is-some agreement) (get active (unwrap-panic agreement))) (err u403))
    (asserts! (is-some recipients-data) (err u404))

    ;; In a real implementation, would distribute payment to all recipients
    ;; based on their shares

    (map-set benefit-agreements
      { knowledge-id: knowledge-id, user: tx-sender }
      (merge (unwrap-panic agreement) { last-payment: block-height })
    )
    (ok true)
  )
)
