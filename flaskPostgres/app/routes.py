from app import app
from sqlalchemy import text, create_engine
from flask import render_template, redirect, url_for, flash
from app.models import Employee
from app.forms import RegistrationForm, LoginForm, CreationTaskForm, TimeReportForm
from flask_login import current_user, login_user, logout_user, login_required
from werkzeug.security import generate_password_hash
from app import Config


@app.route('/index')
@app.route('/')
def index():
    name = 'stranger'
    current_tasks = ''
    if current_user.is_authenticated:
        name = current_user.e_first_name + current_user.e_last_name

    return render_template('index.html', title='test', name=name)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = LoginForm()
    if form.validate_on_submit():
        employee = Employee.query.filter_by(e_nickname=form.username.data).first()
        if employee is None or not employee.check_password(form.password.data):
            flash('Invalid username or password')
            return redirect(url_for('login'))
        login_user(employee)
        return redirect(url_for('index'))
    return render_template('login.html', title='Login', form=form)


@app.route('/logout', methods=['GET', 'POST'])
def logout():
    logout_user()
    with create_engine(Config.SQLALCHEMY_DATABASE_URI).connect() as connection:
        connection.execution_options(isolation_level="AUTOCOMMIT")
        connection.execute(text(f"RESET ROLE"))
    return redirect(url_for('index'))


@app.route('/registration', methods=['GET', 'POST'])
def registration():
    form = RegistrationForm()
    if form.validate_on_submit():
        with create_engine(Config.SQLALCHEMY_DATABASE_URI).connect() as connection:
            connection.execution_options(isolation_level="AUTOCOMMIT")
            connection.execute(text(f"CALL add_employee("
                                             f" '{form.post.data}',"
                                             f" '{form.first_name.data}',"
                                             f" '{form.middle_name.data}',"
                                             f" '{form.last_name.data}',"
                                             f" '{form.email.data}',"
                                             f" {form.phone.data},"
                                             f" '{form.username.data}',"
                                             f" '{generate_password_hash(form.password.data)}');"))

        return redirect(url_for('index'))

    return render_template('registration.html', title='Registration', form=form)


@app.route('/create', methods=['GET', 'POST'])
def create_task():
    form = CreationTaskForm()
    with create_engine(Config.SQLALCHEMY_DATABASE_URI).connect() as connection:
        connection.execution_options(isolation_level="AUTOCOMMIT")
        contact_persons = connection.execute(text("SELECT c_p_id, c_p_first_name, c_p_last_name"
                                                  " FROM contact_person"))
        employees = connection.execute((text("SELECT employee_id, e_first_name, e_last_name "
                                             "FROM employee")))
        goods = connection.execute(text("SELECT goods_num, goods_name "
                                        "FROM goods"))

    contact_persons = [(item[0], f'{item[1] + " " + item[2]}') for item in contact_persons]
    form.contact_person.choices = contact_persons
    employees = [(item[0], f'{item[1] + " " + item[2]}') for item in employees]
    form.employee.choices = employees
    goods = [(item[0], f'{item[1]}') for item in goods]
    form.good.choices = goods

    if form.validate_on_submit():
        with create_engine(Config.SQLALCHEMY_DATABASE_URI).connect() as connection:
            connection.execution_options(isolation_level="AUTOCOMMIT")
            connection.execute(text(f"SET ROLE {current_user.e_nickname};"))
            connection.execute(text(f"CALL create_task("
                                    f"{int(form.id.data)},"
                                    f"{int(form.contact_person.data)},"
                                    f"{int(form.employee.data)},"
                                    f"'{str(form.description.data)}'::TEXT,"
                                    f"'{form.deadline.data}'::TIMESTAMP WITHOUT TIME ZONE,"
                                    f"{form.priority.data}::SMALLINT,"
                                    f"{int(form.good.data)}"
                                    f");"))
        return redirect(url_for('index'))

    return render_template('creation_task.html', title='Creation Task', form=form)


@app.route('/reporting')
def reports():
    form = TimeReportForm()
    result = []

    with create_engine(Config.SQLALCHEMY_DATABASE_URI).connect() as connection:
        connection.execution_options(isolation_level="AUTOCOMMIT")
        employees = connection.execute((text("SELECT employee_id, e_first_name, e_last_name "
                                         "FROM employee")))

    employees = [(item[0], f'{item[1] + " " + item[2]}') for item in employees]
    form.id.choices = employees

    if form.validate_on_submit():
        with create_engine(Config.SQLALCHEMY_DATABASE_URI).connect() as connection:
            connection.execution_options(isolation_level="AUTOCOMMIT")
            connection.execute(text(f"SELECT * FROM export("
                                    f"{form.id.data},"
                                    f"{form.time_start.data},"
                                    f"{form.time_end.data}"
                                    f");"))
        return redirect(url_for('index'))
    return render_template('main_reports.html', title='Time reporting', form=form, data=result)

