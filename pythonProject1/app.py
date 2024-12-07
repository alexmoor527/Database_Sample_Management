from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text
from flask import request, jsonify

app = Flask(__name__)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:0000@localhost/LabDatabase'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# Home route for Sample Management System
@app.route('/')
def index():
    return render_template('index.html')

# API route to fetch operators
@app.route('/operators')
def get_operators():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM Operators"))
        operators = [dict(zip(result.keys(), row)) for row in result]
    return {"operators": operators}


@app.route('/add_operator', methods=['POST'])
def add_operator():
    data = request.json
    name = data.get('name')
    contact = data.get('contact')

    with db.engine.connect() as connection:
        connection.execute(
            text("INSERT INTO Operators (Name, ContactInfo) VALUES (:name, :contact)"),
            {"name": name, "contact": contact}
        )
        connection.commit()  # Ensure the transaction is committed
    return jsonify({"message": "Operator added successfully!"})



@app.route('/experiments')
def get_experiments():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM Experiments"))
        experiments = [dict(zip(result.keys(), row)) for row in result]
    return {"experiments": experiments}

@app.route('/add_experiment', methods=['POST'])
def add_experiment():
    data = request.json
    print("Received data for experiment:", data)  # Debugging

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO Experiments (Name, StartDate, EndDate, Description, OperatorID)
                VALUES (:name, :start_date, :end_date, :description, :operator_id)
                """
            ), {
                "name": data['name'],
                "start_date": data['startDate'],
                "end_date": data['endDate'],
                "description": data['description'],
                "operator_id": data['operatorId']
            })
            transaction.commit()  # Commit the transaction
            print("Experiment successfully inserted into database.")
        return jsonify({"message": "Experiment added successfully!"})
    except Exception as e:
        print("Error inserting experiment:", e)  # Log error
        return jsonify({"error": str(e)}), 500


@app.route('/samples')
def get_samples():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM Samples"))
        samples = [dict(zip(result.keys(), row)) for row in result]
    return {"samples": samples}

@app.route('/add_sample', methods=['POST'])
def add_sample():
    data = request.json
    print("Received data for sample:", data)  # Log received data

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO Samples (ExperimentID, Name, Description, OperatorID)
                VALUES (:experiment_id, :name, :description, :operator_id)
                """
            ), {
                "experiment_id": data['experimentId'],
                "name": data['name'],
                "description": data['description'],
                "operator_id": data['operatorId']
            })
            transaction.commit()  # Explicitly commit the transaction
            print("Sample successfully inserted into database.")
        return jsonify({"message": "Sample added successfully!"})
    except Exception as e:
        print("Error inserting sample into database:", e)
        return jsonify({"error": str(e)}), 500





@app.route('/methods')
def get_methods():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM AnalyticalMethods"))
        methods = [dict(zip(result.keys(), row)) for row in result]
    return {"methods": methods}

@app.route('/add_method', methods=['POST'])
def add_method():
    data = request.json
    print("Received data for method:", data)  # Debugging

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO AnalyticalMethods (Name, Description)
                VALUES (:name, :description)
                """
            ), {
                "name": data['name'],
                "description": data['description']
            })
            transaction.commit()  # Commit the transaction
            print("Method successfully inserted into database.")
        return jsonify({"message": "Method added successfully!"})
    except Exception as e:
        print("Error inserting method:", e)  # Log error
        return jsonify({"error": str(e)}), 500



@app.route('/analysts')
def get_analysts():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM Analysts"))
        analysts = [dict(zip(result.keys(), row)) for row in result]
    return {"analysts": analysts}

@app.route('/add_analyst', methods=['POST'])
def add_analyst():
    data = request.json
    print("Received data for analyst:", data)  # Debugging

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO Analysts (Name, ContactInfo)
                VALUES (:name, :contact)
                """
            ), {
                "name": data['name'],
                "contact": data['contact']
            })
            transaction.commit()  # Commit the transaction
            print("Analyst successfully inserted into database.")
        return jsonify({"message": "Analyst added successfully!"})
    except Exception as e:
        print("Error inserting analyst:", e)  # Log error
        return jsonify({"error": str(e)}), 500






if __name__ == '__main__':
    app.run(debug=True)
