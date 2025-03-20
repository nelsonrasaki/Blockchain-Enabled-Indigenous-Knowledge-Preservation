;; Attribution Contract
;; Ensures proper credit for indigenous knowledge

(define-map attributions
  { knowledge-id: uint }
  {
    community: (string-utf8 100),
    region: (string-utf8 100),
    contributors: (list 10 principal),
    citation-format: (string-utf8 255)
  }
)

(define-public (set-attribution (knowledge-id uint)
                               (community (string-utf8 100))
                               (region (string-utf8 100))
                               (contributors (list 10 principal))
                               (citation-format (string-utf8 255)))
  (begin
    ;; Simple check - in a real system, would verify ownership from knowledge-registration
    (ok (map-set attributions
      { knowledge-id: knowledge-id }
      {
        community: community,
        region: region,
        contributors: contributors,
        citation-format: citation-format
      }
    ))
  )
)

(define-read-only (get-attribution (knowledge-id uint))
  (ok (map-get? attributions { knowledge-id: knowledge-id }))
)

(define-read-only (verify-attribution (knowledge-id uint) (community (string-utf8 100)))
  (let
    (
      (attribution (map-get? attributions { knowledge-id: knowledge-id }))
    )
    (if (is-some attribution)
      (ok (is-eq (get community (unwrap-panic attribution)) community))
      (ok false)
    )
  )
)
