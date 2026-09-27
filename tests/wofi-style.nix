{ pkgs, style }:
let
  stylesheet = pkgs.writeText "wofi.css" style;
in
pkgs.runCommand "wofi-style-test" { } ''
  ${pkgs.python3}/bin/python3 - ${pkgs.gtk3}/lib/libgtk-3.so.0 ${stylesheet} <<'PY'
  import ctypes
  import pathlib
  import sys

  class GError(ctypes.Structure):
      _fields_ = [
          ("domain", ctypes.c_uint),
          ("code", ctypes.c_int),
          ("message", ctypes.c_char_p),
      ]

  # Parse with the same GTK version as Wofi; no display or user session needed.
  gtk = ctypes.CDLL(sys.argv[1])
  gtk.gtk_css_provider_new.restype = ctypes.c_void_p
  gtk.gtk_css_provider_load_from_data.argtypes = [
      ctypes.c_void_p, ctypes.c_char_p, ctypes.c_ssize_t,
      ctypes.POINTER(ctypes.POINTER(GError)),
  ]
  css = pathlib.Path(sys.argv[2]).read_bytes()
  error = ctypes.POINTER(GError)()
  valid = gtk.gtk_css_provider_load_from_data(
      gtk.gtk_css_provider_new(), css, len(css), ctypes.byref(error)
  )
  if not valid:
      raise SystemExit(error.contents.message.decode())
  PY
  touch "$out"
''
