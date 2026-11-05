;;; rainbow-tag-delims -- generated from rainbow-delimiters.nvim's own queries
;;; with the tag-NAME captures removed, so only the angle brackets take a
;;; nesting color. The name keeps the semantic @tag / @tag.builtin color the
;;; theme palettes set (see config/theme/switcher.lua), which is what tells a
;;; <div> apart from a <Component>.
;;; Regenerate after a plugin update if upstream adds node types.

; inherits: typescript
(jsx_element
  open_tag: (jsx_opening_element
              "<" @delimiter
              ">" @delimiter)
  close_tag: (jsx_closing_element
               "</" @delimiter
               ">" @delimiter)) @container

(jsx_element
  open_tag: (jsx_opening_element
              "<" @delimiter
              ">" @delimiter)
  close_tag: (jsx_closing_element
              "</" @delimiter
              ">" @delimiter)) @container

(jsx_self_closing_element
  "<" @delimiter
  "/>" @delimiter) @container

(jsx_expression
  "{" @delimiter
  "}" @delimiter) @container
