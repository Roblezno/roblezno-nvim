; extends

(inline) @spell

; Override spelling captures from injected code comments and strings.
([
  (fenced_code_block)
  (indented_code_block)
  (minus_metadata)
  (plus_metadata)
] @nospell
  (#set! priority 200))
