#!/usr/bin/env python
# vim: sw=4 ts=4 ai expandtab
from __future__ import print_function
"""
Certserv in python
"""

HELP="""

Usage::
    ./certserv.py /path/to/cafile.crt [<port>]

Send a GET request::
    curl http://localhost

"""

from sys import stderr, stdout
try:
    # for python2
    from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
except ModuleNotFoundError:
    # for python3
    from http.server import BaseHTTPRequestHandler, HTTPServer

from signal import signal, SIGTERM, SIGINT

def handler(signum, frame):
    print("Caught signal %d, Exiting now..." % signum, file=stderr)
    exit(signum)

class CertServ(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/x-x509-ca-cert')
        self.send_header('Content-length', len(CERT_DATA))
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write(CERT_DATA.encode('latin1'))

    def do_HEAD(self):
        self._set_headers()
        
def run(server_class=HTTPServer, handler_class=CertServ, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print('Starting certserv on port %d...' % port, file=stderr)
    httpd.serve_forever()

CERT_DATA=''

if __name__ == "__main__":
    from sys import argv

    if len(argv) < 2:
        print(HELP, file=stderr)
        exit(1)

    with open(argv[1], 'r') as f:
        CERT_DATA = f.read()

    signal(SIGTERM, handler)
    signal(SIGINT, handler)

    if len(argv) > 2:
        run(port=int(argv[2]))
    else:
        run()
