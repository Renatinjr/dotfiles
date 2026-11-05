;;; rainbow-tag-delims -- generated from rainbow-delimiters.nvim's own queries
;;; with the tag-NAME captures removed, so only the angle brackets take a
;;; nesting color. The name keeps the semantic @tag / @tag.builtin color the
;;; theme palettes set (see config/theme/switcher.lua), which is what tells a
;;; <div> apart from a <Component>.
;;; Regenerate after a plugin update if upstream adds node types.

; inherits: javascript
(interface_body
  "{" @delimiter
  "}" @delimiter) @container

(enum_body
  "{" @delimiter
  "}" @delimiter) @container

(type_arguments
  "<" @delimiter
  ">" @delimiter) @container

(type_parameters
  "<" @delimiter
  ">" @delimiter) @container

(array_type
  "[" @delimiter
  "]" @delimiter) @container

(lookup_type
  "[" @delimiter
  "]" @delimiter) @container

(object_type
  "{" @delimiter
  "}" @delimiter) @container

(tuple_type
  "[" @delimiter
  "]" @delimiter) @container
