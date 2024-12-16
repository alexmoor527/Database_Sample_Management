# Laboratory Information Management System (LIMS)

A Laboratory Information Management System (LIMS) to manage and track experiments, samples, operators, analysts, and analytical results.

## Features

- **Experiments**: Tracks the details and statuses of various experiments.
- **Samples**: Manages samples linked to experiments.
- **Operators & Analysts**: Keeps records of personnel involved in synthesis and analysis.
- **Analytical Methods**: Stores details about methods used for analysis.
- **Quantitative & Qualitative Results**: Records pass/fail and numerical results for sample testing.
- **Audit Logging**: Automatic logging for all POST requests and changes made to the system.
- **REST API**: Fetch data from all tables programmatically.
- **Visual Insights**: Uses Google Charts to display:
  - Experiment status distribution.
  - Pass/Fail ratios for results.


## Setup Instructions

1. **Database Setup**:
   - Import the `LabDatabase_dump.sql` file to create the required database structure and populate it with sample data.

2. **Run the Application**:
   - Navigate to the project directory and activate the virtual environment.
   - Start the Flask application by running:
     ```bash
     python app.py
     ```
   - Access the application in your browser at `http://127.0.0.1:5000`.


## REST API Endpoints

- `/api/experiments`
- `/api/samples`
- `/api/methods`
- `/api/quantitative-results`
- `/api/qualitative-results`
- `/api/operators`
- `/api/analysts`

These endpoints allow retrieval of data for respective tables in JSON format.
