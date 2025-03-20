;; Access Control Contract
;; Manages permissions based on cultural protocols

(define-map access-permissions
  { knowledge-id: uint, accessor: principal }
  { can-view: bool, can-share: bool }
)

(define-map knowledge-owners
  { knowledge-id: uint }
  { owner: principal }
)

(define-public (set-knowledge-owner (knowledge-id uint) (owner principal))
  (begin
    (asserts! (is-eq tx-sender owner) (err u403))
    (ok (map-set knowledge-owners { knowledge-id: knowledge-id } { owner: owner }))
  )
)

(define-public (grant-access (knowledge-id uint) (accessor principal) (can-view bool) (can-share bool))
  (let
    (
      (owner-data (map-get? knowledge-owners { knowledge-id: knowledge-id }))
    )
    (asserts! (and (is-some owner-data) (is-eq tx-sender (get owner (unwrap-panic owner-data)))) (err u403))
    (ok (map-set access-permissions
      { knowledge-id: knowledge-id, accessor: accessor }
      { can-view: can-view, can-share: can-share }))
  )
)

(define-read-only (check-access (knowledge-id uint) (accessor principal))
  (let
    (
      (permission (map-get? access-permissions { knowledge-id: knowledge-id, accessor: accessor }))
      (owner-data (map-get? knowledge-owners { knowledge-id: knowledge-id }))
    )
    (if (and (is-some owner-data) (is-eq accessor (get owner (unwrap-panic owner-data))))
      (ok { can-view: true, can-share: true })
      (if (is-some permission)
        (ok (unwrap-panic permission))
        (ok { can-view: false, can-share: false })
      )
    )
  )
)
