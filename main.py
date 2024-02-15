from flask import Flask
import os

app = Flask(__name__)

@app.route("/<message>")
def echo(message):
    filename = '/var/lib/echo_api/'+message
    with open(filename, 'w') as file:
        file.write(message)

    return message


if __name__ == '__main__':
    if not os.path.exists('/var/lib/echo_api'):
        os.makedirs('/var/lib/echo_api')
app.run()
