from http.server import HTTPServer, BaseHTTPRequestHandler
import json

data = {'result': 'this is a test'}
#host = ('localhost', 8888)
host = ('172.30.103.117', 8888)										#对应网页地址：http://172.30.103.117:8888/  端口8888


class Resquest(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        #self.send_header('Content-type', 'application/json')
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

if __name__ == '__main__':
    server = HTTPServer(host, Resquest)
    print("Starting server, listen at: %s:%s" % host)
    print("web login：http://%s:%s/" % host)
    server.serve_forever()