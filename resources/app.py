from flask import Flask, render_template, flash, redirect, Response
from flaskext.mysql import MySQL
from flask_wtf import FlaskForm

from wtforms import StringField, BooleanField, SubmitField, SelectField
from wtforms.validators import DataRequired

from flask_bootstrap import Bootstrap

from datasploit.domain import domain_subdomains

app = Flask(__name__)
mysql = MySQL()

bootstrap = Bootstrap(app)

app.config['SECRET_KEY'] = 'mjn@3m#2!!k3mklkm3k4lk3m4m2$!!'
app.config['MYSQL_DATABASE_USER'] = 'server'
app.config['MYSQL_DATABASE_PASSWORD'] = 'server_password'
app.config['MYSQL_DATABASE_DB'] = 'p2db'
app.config['MYSQL_DATABASE_HOST'] = 'database'

mysql.init_app(app)

class TargetForm(FlaskForm):
	target = StringField('Domain Target', validators=[DataRequired()])
	action = SelectField('Action', choices=[('Subdomain','Subdomain Enumeration'), ('whois','whois'), ('Shodan','Shodan'), ('Wappalyzer','Wappalyzer'), ('DNS','DNS Records'), ('lol','Your own tool!')])
	store_results = BooleanField('Store Results')
	submit = SubmitField('Run')

@app.route('/', methods=['GET', 'POST'])
@app.route('/index', methods=['GET', 'POST'])
def index():
	form = TargetForm()

	if form.validate_on_submit():
		flash('Target run requested for {}, Store Results={}'.format(form.target.data, form.store_results.data))
		target = form.target.data

		if form.action.data == 'Subdomain':

			subdomain_results = domain_subdomains.main(target)
			subdomain_results = [x.encode('utf-8') for x in subdomain_results]
			results = {'subdomain': subdomain_results}

			if form.store_results.data == True:
				conn = mysql.connect()
				cursor = conn.cursor()
				cursor.callproc('createRecord',(str(form.action.data),', '.join(subdomain_results),target))
				data = cursor.fetchall()

				if len(data) is 0:
					conn.commit()
					info = "Data Saved"
				else:
					info = str(data[0])

			return render_template('results.html', title='Results', results = subdomain_results)

		else:
			return render_template('index.html', title='Home', form=form)

	return render_template('index.html', title='Home', form=form)


@app.route('/history')
def history():
	conn = mysql.connect()
	cursor = conn.cursor()
	cursor.execute('''SELECT * FROM p2db.record''')
	results = cursor.fetchall()
	return render_template('history.html', title='Stored Runs', results = results)

@app.route('/ping')
def ping():
	return "pong", 204

@app.route('/instanceID')
def instanceID():
    # Get instance ID
    instance_id = "XXXXXXX"
    return Response(instance_id, mimetype='text/plain')


if __name__ =="__main__":
	app.run()