#!/usr/bin/env python3
import http.server, os

class Handler(http.server.SimpleHTTPRequestHandler):
    def translate_path(self, path):
        p = super().translate_path(path)
        if not os.path.exists(p) and os.path.exists(p + ".html"):
            return p + ".html"
        return p

http.server.test(HandlerClass=Handler, port=8000, bind="127.0.0.1")
