;; Artist Verification Contract
;; This contract validates legitimate ceramic artists

(define-data-var admin principal tx-sender)

;; Map to store verified artists
(define-map verified-artists principal
  {
    name: (string-utf8 100),
    verified-since: uint,
    credentials: (string-utf8 500)
  }
)

;; Function to verify a new artist (admin only)
(define-public (verify-artist (artist-address principal) (artist-name (string-utf8 100)) (artist-credentials (string-utf8 500)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (ok (map-set verified-artists artist-address
      {
        name: artist-name,
        verified-since: block-height,
        credentials: artist-credentials
      }
    ))
  )
)

;; Function to check if an artist is verified
(define-read-only (is-verified (artist-address principal))
  (is-some (map-get? verified-artists artist-address))
)

;; Function to get artist details
(define-read-only (get-artist-details (artist-address principal))
  (map-get? verified-artists artist-address)
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u101))
    (ok (var-set admin new-admin))
  )
)

