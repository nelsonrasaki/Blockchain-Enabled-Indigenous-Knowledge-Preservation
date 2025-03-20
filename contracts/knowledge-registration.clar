;; Knowledge Registration Contract
;; Securely records traditional practices

(define-data-var last-knowledge-id uint u0)

(define-map knowledge-records
  { knowledge-id: uint }
  {
    title: (string-utf8 100),
    description: (string-utf8 500),
    owner: principal,
    timestamp: uint,
    metadata-url: (optional (string-utf8 255))
  }
)

(define-public (register-knowledge (title (string-utf8 100)) (description (string-utf8 500)) (metadata-url (optional (string-utf8 255))))
  (let
    (
      (new-id (+ (var-get last-knowledge-id) u1))
    )
    (map-set knowledge-records
      { knowledge-id: new-id }
      {
        title: title,
        description: description,
        owner: tx-sender,
        timestamp: block-height,
        metadata-url: metadata-url
      }
    )
    (var-set last-knowledge-id new-id)
    (ok new-id)
  )
)

(define-read-only (get-knowledge (knowledge-id uint))
  (ok (map-get? knowledge-records { knowledge-id: knowledge-id }))
)

(define-read-only (get-knowledge-count)
  (ok (var-get last-knowledge-id))
)
