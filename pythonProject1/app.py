import logging
from logging.handlers import TimedRotatingFileHandler
from datetime import datetime


from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text
from flask import request, jsonify
import os
from werkzeug.utils import secure_filename


# Generate log file name with timestamp
def get_log_file_name():
    timestamp = datetime.now().strftime('%Y-%m-%d_%H')
    return f'logs/audit_{timestamp}.log'

# Configure logging with automatic hourly rotation
log_handler = TimedRotatingFileHandler('logs/audit.log', when='H', interval=1, backupCount=24)  # Rotate every hour
log_formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
log_handler.setFormatter(log_formatter)

logger = logging.getLogger('AuditLogger')
logger.setLevel(logging.INFO)
logger.addHandler(log_handler)



app = Flask(__name__)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:0000@localhost/LabDatabase'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# PDF Upload config
UPLOAD_FOLDER = 'static/uploads'  # Folder to store uploaded PDFs
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Initialize SQLAlchemy
db = SQLAlchemy(app)




# Logging
@app.before_request
def log_request_info():
    logger.info(f"Request: {request.method} {request.path}")

    # Log JSON data only if Content-Type is application/json
    if request.content_type == 'application/json':
        logger.info(f"Data: {request.json}")
    else:
        logger.info(f"Form Data: {request.form}")
        logger.info(f"Files: {request.files}")


@app.after_request
def log_response_info(response):
    logger.info(f"Response: {response.status_code} for {request.path}")
    return response

@app.errorhandler(Exception)
def log_error(e):
    logger.error(f"Error occurred: {str(e)}", exc_info=True)
    return jsonify({"error": "An internal error occurred"}), 500






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
            transaction = connection.begin()  # Start a transaction
            connection.execute(
                text("INSERT INTO Operators (Name, ContactInfo, Status) VALUES (:name, :contact, :status)"),
                {"name": data['name'], "contact": data['contact'], "status": data.get('status', 'Active')}  # Default to 'Active'
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
    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            connection.execute(
                text("INSERT INTO Analysts (Name, ContactInfo, Status) VALUES (:name, :contact, :status)"),
                {"name": data['name'], "contact": data['contact'], "status": data.get('status', 'Active')}  # Default to 'Active'
            )
            transaction.commit()  # Commit transaction
        return jsonify({"message": "Analyst added successfully!"})
    except Exception as e:
        print(f"Error adding analyst: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/upload_quantitative_result', methods=['POST'])
def upload_quantitative_result():
    if 'pdfFile' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['pdfFile']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and file.filename.endswith('.pdf'):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)  # Save the file

        data = request.form
        try:
            # Convert PassFail from dropdown string to boolean
            pass_fail = data['passFail'].upper() == 'TRUE'

            with db.engine.connect() as connection:
                transaction = connection.begin()
                connection.execute(text(
                    """
                    INSERT INTO QuantitativeResults (SampleID, MethodID, AnalystID, ResultValue, Specification, PassFail, Status, PdfFilePath)
                    VALUES (:sampleId, :methodId, :analystId, :resultValue, :specification, :passFail, :status, :pdfFilePath)
                    """
                ), {
                    "sampleId": int(data['sampleId']),
                    "methodId": int(data['methodId']),
                    "analystId": int(data['analystId']),
                    "resultValue": float(data['resultValue']),
                    "specification": float(data['specification']),
                    "passFail": pass_fail,  # Convert string to boolean
                    "status": data['status'],
                    "pdfFilePath": filepath
                })
                transaction.commit()
            return jsonify({"message": "Quantitative result added successfully!"})
        except Exception as e:
            print(f"Error adding quantitative result: {e}")
            return jsonify({"error": str(e)}), 500
@app.route('/upload_qualitative_result', methods=['POST'])
def upload_qualitative_result():
    if 'pdfFile' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['pdfFile']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and file.filename.endswith('.pdf'):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)  # Save the file

        # Convert backslashes to forward slashes for compatibility
        filepath = filepath.replace("\\", "/")

        data = request.form
        try:
            pass_fail = data['passFail'].upper() == 'TRUE'  # Convert to boolean
            with db.engine.connect() as connection:
                transaction = connection.begin()
                connection.execute(text(
                    """
                    INSERT INTO QualitativeResults (SampleID, MethodID, AnalystID, PassFail, Status, PdfFilePath)
                    VALUES (:sampleId, :methodId, :analystId, :passFail, :status, :pdfFilePath)
                    """
                ), {
                    "sampleId": int(data['sampleId']),
                    "methodId": int(data['methodId']),
                    "analystId": int(data['analystId']),
                    "passFail": pass_fail,
                    "status": data['status'],
                    "pdfFilePath": filepath
                })
                transaction.commit()
            return jsonify({"message": "Qualitative result added successfully!"})
        except Exception as e:
            print(f"Error adding qualitative result: {e}")
            return jsonify({"error": str(e)}), 500


@app.route('/quantitative_results')
def get_quantitative_results():
    try:
        with db.engine.connect() as connection:
            result = connection.execute(text("SELECT * FROM QuantitativeResults"))
            results = [dict(zip(result.keys(), row)) for row in result]
        return {"results": results}
    except Exception as e:
        print(f"Error fetching quantitative results: {e}")
        return jsonify({"error": str(e)}), 500



@app.route('/add_quantitative_result', methods=['POST'])
def add_quantitative_result():
    data = request.json
    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()
            connection.execute(text(
                """
                INSERT INTO QuantitativeResults (SampleID, MethodID, AnalystID, ResultValue, Specification, PassFail, Status, PdfFilePath)
                VALUES (:sampleId, :methodId, :analystId, :resultValue, :specification, :passFail, :status, :pdf_file_path)
                """
            ), {
                "sampleId": data['sampleId'],
                "methodId": data['methodId'],
                "analystId": data['analystId'],
                "resultValue": data['resultValue'],
                "specification": data['specification'],
                "passFail": data['passFail'],
                "status": data.get('status', 'Valid'),
                "pdf_file_path": data.get('pdfFilePath') or None  # Allow NULL
            })
            transaction.commit()
        return jsonify({"message": "Quantitative result added successfully!"})
    except Exception as e:
        print(f"Error adding quantitative result: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/qualitative_results')
def get_qualitative_results():
    try:
        with db.engine.connect() as connection:
            result = connection.execute(text("SELECT * FROM QualitativeResults"))
            results = [dict(zip(result.keys(), row)) for row in result]
        return {"results": results}
    except Exception as e:
        print(f"Error fetching qualitative results: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/add_qualitative_result', methods=['POST'])
def add_qualitative_result():
    data = request.json
    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()
            connection.execute(text(
                """
                INSERT INTO QualitativeResults (SampleID, MethodID, AnalystID, PassFail, Status, PdfFilePath)
                VALUES (:sampleId, :methodId, :analystId, :passFail, :status, :pdf_file_path)
                """
            ), {
                "sampleId": data['sampleId'],
                "methodId": data['methodId'],
                "analystId": data['analystId'],
                "passFail": data['passFail'],
                "status": data.get('status', 'Valid'),
                "pdf_file_path": data.get('pdfFilePath') or None  # Allow NULL
            })
            transaction.commit()
        return jsonify({"message": "Qualitative result added successfully!"})
    except Exception as e:
        print(f"Error adding qualitative result: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/api/update_<table>_status', methods=['POST'])
def update_status(table):
    data = request.json
    print(f"Received data for update: {data}")

    table_mapping = {
        'experiments': 'Experiments',
        'samples': 'Samples',
        'methods': 'AnalyticalMethods',  # Keep this one
        'quantitative-results': 'QuantitativeResults',
        'qualitative-results': 'QualitativeResults',
        'operators': 'Operators',
        'analysts': 'Analysts'
    }

    id_field_mapping = {
        'experiments': 'ExperimentID',
        'samples': 'SampleID',
        'methods': 'MethodID',  # Fix here to align with 'methods'
        'quantitative-results': 'TaskID',
        'qualitative-results': 'TaskID',
        'operators': 'OperatorID',
        'analysts': 'AnalystID'
    }

    table_name = table_mapping.get(table)
    id_field = id_field_mapping.get(table)

    if not table_name or not id_field:
        print(f"Invalid table specified: {table}")
        return jsonify({"error": "Invalid table"}), 400

    id_value = data.get('id')
    status = data.get('status')

    if not id_value or not status:
        print(f"Missing required fields: id={id_value}, status={status}")
        return jsonify({"error": "Invalid data"}), 400

    try:
        with db.engine.connect() as connection:
            transaction = connection.begin()  # Start a transaction
            query = f"UPDATE {table_name} SET Status = :status WHERE {id_field} = :id_value"
            print(f"Executing query: {query} with params: status={status}, id_value={id_value}")
            connection.execute(text(query), {"status": status, "id_value": id_value})
            transaction.commit()  # Commit the transaction
        return jsonify({"message": "Status updated successfully!"})
    except Exception as e:
        print(f"Error updating status for table={table}: {e}")
        return jsonify({"error": str(e)}), 500



@app.route('/api/<table_name>', methods=['GET'])
def get_table_data(table_name):
    """
    Generic REST API endpoint for fetching data from any table.
    """
    table_mapping = {
        "experiments": "Experiments",
        "samples": "Samples",
        "methods": "AnalyticalMethods",
        "quantitative-results": "QuantitativeResults",
        "qualitative-results": "QualitativeResults",
        "operators": "Operators",
        "analysts": "Analysts"
    }

    # Validate the table name
    if table_name not in table_mapping:
        return jsonify({"error": f"Invalid table: {table_name}"}), 400

    try:
        # Fetch the data dynamically
        with db.engine.connect() as connection:
            result = connection.execute(text(f"SELECT * FROM {table_mapping[table_name]}"))
            table_data = [dict(row._mapping) for row in result]  # Ensure correct row-to-dict conversion
        return jsonify(table_data)
    except Exception as e:
        print(f"Error fetching data for {table_name}: {e}")
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
