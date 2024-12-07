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
    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start transaction
            connection.execute(
                text("INSERT INTO Operators (Name, ContactInfo, Status) VALUES (:name, :contact, :status)"),
                {"name": data['name'], "contact": data['contact'], "status": data['status']}
            )
            transaction.commit()  # Commit transaction
        return jsonify({"message": "Operator added successfully!"})
    except Exception as e:
        print(f"Error adding operator: {e}")
        return jsonify({"error": str(e)}), 500



@app.route('/experiments')
def get_experiments():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM Experiments"))
        experiments = [dict(zip(result.keys(), row)) for row in result]
    return {"experiments": experiments}

@app.route('/add_experiment', methods=['POST'])
def add_experiment():
    data = request.json
    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO Experiments (Name, StartDate, EndDate, Description, Status, OperatorID)
                VALUES (:name, :start_date, :end_date, :description, :status, :operator_id)
                """
            ), {
                "name": data['name'],
                "start_date": data.get('startDate'),  # StartDate must be provided
                "end_date": data.get('endDate') or None,  # Allow NULL for EndDate
                "description": data['description'],
                "status": data.get('status', 'Planned'),  # Default to 'Planned'
                "operator_id": data['operatorId']
            })
            transaction.commit()  # Commit the transaction
        return jsonify({"message": "Experiment added successfully!"})
    except Exception as e:
        print(f"Error adding experiment: {e}")  # Log any errors for debugging
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
    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO Samples (ExperimentID, Name, Description, OperatorID, Status)
                VALUES (:experiment_id, :name, :description, :operator_id, :status)
                """
            ), {
                "experiment_id": data['experimentId'],
                "name": data['name'],
                "description": data['description'],
                "operator_id": data['operatorId'],
                "status": data.get('status', 'Valid')  # Default to 'Valid' if not provided
            })
            transaction.commit()  # Commit the transaction
        return jsonify({"message": "Sample added successfully!"})
    except Exception as e:
        print(f"Error adding sample: {e}")  # Log error for debugging
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
    status = data.get('status', 'Active')  # Default to 'Active' if not provided

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(text(
                """
                INSERT INTO AnalyticalMethods (Name, Description, Status)
                VALUES (:name, :description, :status)
                """
            ), {
                "name": data['name'],
                "description": data['description'],
                "status": status  # Ensure 'status' is included in the data
            })
            transaction.commit()  # Commit the transaction
        return jsonify({"message": "Method added successfully!"})
    except Exception as e:
        print(f"Error adding method: {e}")  # Log error for debugging
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
    name = data.get('name')
    contact = data.get('contact')
    status = data.get('status', 'Active')  # Default to 'Active' if not provided

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(
                text("INSERT INTO Analysts (Name, ContactInfo, Status) VALUES (:name, :contact, :status)"),
                {"name": name, "contact": contact, "status": status}
            )
            transaction.commit()  # Commit the transaction
        return jsonify({"message": "Analyst added successfully!"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/quantitative_results')
def get_quantitative_results():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM QuantitativeResults"))
        results = [dict(zip(result.keys(), row)) for row in result]
    return {"results": results}

@app.route('/add_quantitative_result', methods=['POST'])
def add_quantitative_result():
    data = request.json
    with db.engine.connect() as connection:
        connection.execute(text("""
            INSERT INTO QuantitativeResults (SampleID, MethodID, AnalystID, ResultValue, Specification, PassFail, Status, PdfFilePath)
            VALUES (:sampleId, :methodId, :analystId, :resultValue, :specification, :passFail, :status, :pdfFilePath)
        """), data)
    return jsonify({"message": "Quantitative result added successfully!"})

@app.route('/qualitative_results')
def get_qualitative_results():
    with db.engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM QualitativeResults"))
        results = [dict(zip(result.keys(), row)) for row in result]
    return {"results": results}

@app.route('/add_qualitative_result', methods=['POST'])
def add_qualitative_result():
    data = request.json
    with db.engine.connect() as connection:
        connection.execute(text("""
            INSERT INTO QualitativeResults (SampleID, MethodID, AnalystID, PassFail, Status, PdfFilePath)
            VALUES (:sampleId, :methodId, :analystId, :passFail, :status, :pdfFilePath)
        """), data)
    return jsonify({"message": "Qualitative result added successfully!"})


if __name__ == '__main__':
    app.run(debug=True)
