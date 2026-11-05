;;; rainbow-tag-delims -- generated from rainbow-delimiters.nvim's own queries
;;; with the tag-NAME captures removed, so only the angle brackets take a
;;; nesting color. The name keeps the semantic @tag / @tag.builtin color the
;;; theme palettes set (see config/theme/switcher.lua), which is what tells a
;;; <div> apart from a <Component>.
;;; Regenerate after a plugin update if upstream adds node types.

;;; A pair of delimiter tags with any content in-between.

;;; If instead you want rainbow-delimiters to only highlight
;;; the tag names without any of "<", "</", ">" or "/>", then
;;; you can make your own query file, e.g.,
;;;   'rainbow-tag-names'
;;; and use the following with
;;;   x @delimiter
;;; deleted for x equal to any of "<", "</", ">" or "/>".

(element
  (start_tag
    "<" @delimiter
    ">" @delimiter)
  (end_tag
    "</" @delimiter
    ">" @delimiter)) @container

(element
  (self_closing_tag
    "<" @delimiter
    "/>" @delimiter)) @container

(element
  (start_tag
    "<" @delimiter
    (tag_name) @_tag_name
    ">" @delimiter)
  (#any-of? @_tag_name
   "area"
   "base"
   "br"
   "col"
   "embed"
   "hr"
   "img"
   "input"
   "link"
   "meta"
   "param"
   "source"
   "track"
   "wbr")
) @container

(style_element
  (start_tag
    "<" @delimiter
    ">" @delimiter)
  (element (self_closing_tag) @delimiter)*
  (end_tag
    "</" @delimiter
    ">" @delimiter)) @container

(script_element
  (start_tag
    "<" @delimiter
    ">" @delimiter)
  (end_tag
    "</" @delimiter
    ">" @delimiter)) @container
