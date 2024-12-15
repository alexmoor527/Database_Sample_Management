document.addEventListener('DOMContentLoaded', () => {
    // Load all data when the page is ready
    loadExperiments();
    loadSamples();
    loadQuantitativeResults();
    loadQualitativeResults();
    loadMethods();
    loadOperators();
    loadAnalysts();

    // Log errors if fetch fails
    function handleFetchError(error, endpoint) {
        console.error(`Error fetching data from ${endpoint}:`, error);
        alert(`Failed to load data from ${endpoint}`);
    }

    // Setup search bars for all tables
    setupSearch('search-experiments', 'experiments-table');
    setupSearch('search-samples', 'samples-table');
    setupSearch('search-quantitative-results', 'quantitative-results-table');
    setupSearch('search-qualitative-results', 'qualitative-results-table');
    setupSearch('search-methods', 'methods-table');
    setupSearch('search-operators', 'operators-table');
    setupSearch('search-analysts', 'analysts-table');
});


// Fetch and display experiments
function loadExperiments() {
    fetch('/experiments')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => renderTable('experiments-table', data.experiments, ['ExperimentID', 'Name', 'StartDate', 'EndDate', 'Description', 'Status', 'OperatorID']))
        .catch(error => handleFetchError(error, '/experiments'));
}

function loadSamples() {
    fetch('/samples')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => {
            renderTable('samples-table', data.samples, [
                'SampleID',
                'ExperimentID',
                'Name',
                'Description',
                'OperatorID',
                'Status' // Include Status here
            ]);
        })
        .catch(error => handleFetchError(error, '/samples'));
}


// Fetch and display quantitative results
function loadQuantitativeResults() {
    fetch('/quantitative_results')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => renderTable('quantitative-results-table', data.results, [
            'TaskID', 'SampleID', 'MethodID', 'AnalystID', 'ResultValue', 'Specification', 'PassFail', 'Status', 'PdfFilePath'
        ]))
        .catch(error => handleFetchError(error, '/quantitative_results'));
}

// Fetch and display qualitative results
function loadQualitativeResults() {
    fetch('/qualitative_results')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => renderTable('qualitative-results-table', data.results, [
            'TaskID', 'SampleID', 'MethodID', 'AnalystID', 'PassFail', 'Status', 'PdfFilePath'
        ]))
        .catch(error => handleFetchError(error, '/qualitative_results'));
}

// Load methods
function loadMethods() {
    fetch('/methods')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => {
            renderTable('methods-table', data.methods, ['MethodID', 'Name', 'Description', 'Status']); // Include 'Status'
        })
        .catch(error => handleFetchError(error, '/methods'));
}


// Fetch and display operators
function loadOperators() {
    fetch('/operators')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => renderTable('operators-table', data.operators, ['OperatorID', 'Name', 'ContactInfo', 'Status']))
        .catch(error => handleFetchError(error, '/operators'));
}

// Fetch and display analysts
function loadAnalysts() {
    fetch('/analysts')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.json();
        })
        .then(data => renderTable('analysts-table', data.analysts, ['AnalystID', 'Name', 'ContactInfo', 'Status']))
        .catch(error => handleFetchError(error, '/analysts'));
}




document.addEventListener('DOMContentLoaded', () => {
    // Load data on page load
    loadExperiments();
    loadSamples();
    loadQuantitativeResults();
    loadQualitativeResults();
    loadMethods();
    loadOperators();
    loadAnalysts();

    // Add Experiment
    document.getElementById('add-experiment-form').addEventListener('submit', async (event) => {
        event.preventDefault();
        const experimentData = {
            name: document.getElementById('experiment-name').value,
            startDate: document.getElementById('start-date').value,
            endDate: document.getElementById('end-date').value,
            description: document.getElementById('description').value,
            status: document.getElementById('status').value,
            operatorId: document.getElementById('operator-id').value
        };
        await submitForm('/add_experiment', experimentData, loadExperiments, 'Experiment');
    });

    // Add Sample
    document.getElementById('add-sample-form').addEventListener('submit', async (event) => {
        event.preventDefault();
        const sampleData = {
            experimentId: document.getElementById('sample-experiment-id').value,
            name: document.getElementById('sample-name').value,
            description: document.getElementById('sample-description').value,
            operatorId: document.getElementById('sample-operator-id').value
        };
        await submitForm('/add_sample', sampleData, loadSamples, 'Sample');
    });


document.getElementById('add-quantitative-result-form').addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData();
    formData.append('sampleId', document.getElementById('quant-sample-id').value);
    formData.append('methodId', document.getElementById('quant-method-id').value);
    formData.append('analystId', document.getElementById('quant-analyst-id').value);
    formData.append('resultValue', document.getElementById('quant-result-value').value);
    formData.append('specification', document.getElementById('quant-specification').value);
    formData.append('passFail', document.getElementById('quant-pass-fail').value);
    formData.append('status', document.getElementById('quant-status').value);
    formData.append('pdfFile', document.getElementById('quant-pdf-path').files[0]); // Include file

    try {
        const response = await fetch('/upload_quantitative_result', {
            method: 'POST',
            body: formData
        });

        const result = await response.json();
        if (response.ok) {
            alert('Quantitative result added successfully!');
            loadQuantitativeResults();
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error('Error adding quantitative result:', error);
        alert('Failed to add quantitative result. Check console for details.');
    }
});

document.getElementById('add-qualitative-result-form').addEventListener('submit', async (event) => {
    event.preventDefault(); // Prevent the default form submission

    const formData = new FormData();
    formData.append('sampleId', document.getElementById('qual-sample-id').value);
    formData.append('methodId', document.getElementById('qual-method-id').value);
    formData.append('analystId', document.getElementById('qual-analyst-id').value);
    formData.append('passFail', document.getElementById('qual-pass-fail').value);
    formData.append('status', document.getElementById('qual-status').value);
    formData.append('pdfFile', document.getElementById('qual-pdf-path').files[0]);

    try {
        const response = await fetch('/upload_qualitative_result', {
            method: 'POST',
            body: formData,
        });

        const result = await response.json();
        if (response.ok) {
            alert('Qualitative result added successfully!');
            loadQualitativeResults(); // Reload the results table
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error('Error adding qualitative result:', error);
        alert('Failed to add qualitative result. Check console for details.');
    }
});



    // Add Method
    document.getElementById('add-method-form').addEventListener('submit', async (event) => {
        event.preventDefault();
        const methodData = {
            name: document.getElementById('method-name').value,
            description: document.getElementById('method-description').value
        };
        await submitForm('/add_method', methodData, loadMethods, 'Method');
    });

    // Add Operator
    document.getElementById('add-operator-form').addEventListener('submit', async (event) => {
        event.preventDefault();
        const operatorData = {
            name: document.getElementById('operator-name').value,
            contact: document.getElementById('operator-contact').value,
            status: document.getElementById('operator-status').value
        };
        await submitForm('/add_operator', operatorData, loadOperators, 'Operator');
    });

    // Add Analyst
    document.getElementById('add-analyst-form').addEventListener('submit', async (event) => {
        event.preventDefault();
        const analystData = {
            name: document.getElementById('analyst-name').value,
            contact: document.getElementById('analyst-contact').value,
            status: document.getElementById('analyst-status').value
        };
        await submitForm('/add_analyst', analystData, loadAnalysts, 'Analyst');
    });
});

// Helper to submit forms and reload data
async function submitForm(url, data, reloadCallback, entityName) {
    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await response.json();
        if (response.ok) {
            alert(`${entityName} added successfully!`);
            reloadCallback();
        } else {
            throw new Error(result.error || `Failed to add ${entityName}`);
        }
    } catch (error) {
        console.error(`Error adding ${entityName}:`, error);
        alert(`Error adding ${entityName}: ${error.message}`);
    }
}


// Function to render the table with dropdown and PDF handling
function renderTable(tableId, data, columns) {
    const tableBody = document.getElementById(tableId);
    tableBody.innerHTML = '';

    const validOptions = {
        experiments: ['Planned', 'Ongoing', 'Finished', 'Cancelled'],
        samples: ['Valid', 'Rejected'],
        methods: ['Active', 'Inactive'], // Fixed to match the tableKey
        'quantitative-results': ['Valid', 'Rejected'],
        'qualitative-results': ['Valid', 'Rejected'],
        operators: ['Active', 'Inactive'],
        analysts: ['Active', 'Inactive']
    };

    const idFieldMapping = {
        experiments: 'ExperimentID',
        samples: 'SampleID',
        methods: 'MethodID', // Fixed to match the tableKey
        'quantitative-results': 'TaskID',
        'qualitative-results': 'TaskID',
        operators: 'OperatorID',
        analysts: 'AnalystID'
    };

    const tableKey = tableId.replace('-table', '').toLowerCase();
    const idField = idFieldMapping[tableKey];

    console.log(`Table Key Debug: tableKey=${tableKey}`);

    data.forEach(item => {
        const row = document.createElement('tr');

        columns.forEach(column => {
            const cell = document.createElement('td');

            if (column === 'PdfFilePath' && item[column]) {
                const link = document.createElement('a');
                link.href = item[column].replace('\\', '/'); // Ensure proper path formatting
                link.textContent = 'View PDF';
                link.target = '_blank';
                cell.appendChild(link);
            }

            else if (column === 'PassFail') {
                cell.textContent = item[column] === true || item[column] === 1 ? 'Pass' : 'Fail';
            


            } else if (column === 'Status') {
                const dropdown = document.createElement('select');
                const statuses = validOptions[tableKey] || [];

                console.log(`Dropdown setup for ${tableKey}: statuses=${statuses.join(', ')}, status=${item[column]}`);

                if (!statuses.length) {
                    console.error(`No valid options found for ${tableKey}`);
                    return; // Skip rendering the dropdown if no options are available
                }

                statuses.forEach(status => {
                    const option = document.createElement('option');
                    option.value = status;
                    option.textContent = status;
                    option.selected = item[column] === status;
                    dropdown.appendChild(option);
                });

                const idValue = item[idField];
                dropdown.dataset.id = idValue;
                dropdown.dataset.tableKey = tableKey;

                console.log(`Dropdown setup for ${tableKey}: id=${idValue}, status=${item[column]}`);

                dropdown.addEventListener('change', async (event) => {
                    const newStatus = event.target.value;
                    const id = event.target.dataset.id;
                    const table = event.target.dataset.tableKey;

                    console.log("Updating status for:", { id, table, newStatus });

                    if (!id || id === 'undefined') {
                        alert("Failed to identify the record for updating status.");
                        return;
                    }

                    try {
                        const response = await fetch(`/api/update_${table}_status`, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ id, status: newStatus })
                        });

                        if (response.ok) {
                            alert(`Status updated to ${newStatus}`);
                        } else {
                            const error = await response.json();
                            console.error("Failed to update status:", error.error);
                            alert("Failed to update status.");
                        }
                    } catch (error) {
                        console.error("Error updating status:", error);
                        alert("Error updating status.");
                    }
                });

                cell.appendChild(dropdown);
            } else {
                cell.textContent = item[column] || '';
            }

            row.appendChild(cell);
        });

        tableBody.appendChild(row);
    });
}








// Helper to set up search functionality
function setupSearch(searchInputId, tableId) {
    const searchInput = document.getElementById(searchInputId);
    searchInput.addEventListener('input', (event) => {
        const query = event.target.value.toLowerCase();
        const rows = document.querySelectorAll(`#${tableId} tr`);
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    });
}


// Darkmode
document.getElementById('theme-toggle').addEventListener('change', (event) => {
    document.body.classList.toggle('dark-mode', event.target.checked);
});




// Australian Mode
let currentDegrees = 0; // Track the current rotation angle
let targetDegrees = 0; // The target rotation angle
const rotationSpeed = 2; // Degrees per frame

function smoothRotate() {
    if (currentDegrees !== targetDegrees) {
        // Calculate the step to increment or decrement towards the target
        const step = targetDegrees > currentDegrees ? rotationSpeed : -rotationSpeed;
        currentDegrees += step;

        // Apply rotation to the body
        document.body.style.transform = `rotate(${currentDegrees}deg)`;

        // Stop when the target is reached
        if ((step > 0 && currentDegrees >= targetDegrees) || (step < 0 && currentDegrees <= targetDegrees)) {
            currentDegrees = targetDegrees; // Snap to target
            document.body.style.transform = `rotate(${currentDegrees}deg)`;
            return;
        }

        // Continue animating
        requestAnimationFrame(smoothRotate);
    }
}

// Add event listener for checkbox
document.getElementById('australian-mode').addEventListener('change', (event) => {
    targetDegrees = event.target.checked ? 180 : 0; // Set target based on checkbox
    smoothRotate(); // Start rotation animation
});




// Detect the system's theme preference (light or dark)
const prefersDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;

// Get the dark mode toggle checkbox
const themeToggleCheckbox = document.getElementById('theme-toggle');

// Set the checkbox based on the user's system theme preference
themeToggleCheckbox.checked = prefersDarkMode;

// Toggle dark mode based on checkbox state
themeToggleCheckbox.addEventListener('change', (event) => {
    document.body.classList.toggle('dark-mode', event.target.checked);
});

// Apply dark mode on page load if the system prefers dark mode
if (prefersDarkMode) {
    document.body.classList.add('dark-mode');
}










document.addEventListener('DOMContentLoaded', () => {
    // Load Google Charts library
    google.charts.load('current', { packages: ['corechart'] });

    // Initialize the charts once the library is ready
    google.charts.setOnLoadCallback(drawCharts);

    async function drawCharts() {
        try {
            // Fetch data from existing APIs
            const quantitativeData = await fetch('/quantitative_results').then(res => res.json());
            const qualitativeData = await fetch('/qualitative_results').then(res => res.json());
            const experimentsData = await fetch('/experiments').then(res => res.json());

            // Prepare data for charts
            const quantitativeChartData = transformPassFailData(quantitativeData.results, 'PassFail');
            const qualitativeChartData = transformPassFailData(qualitativeData.results, 'PassFail');
            const experimentStatusData = transformExperimentStatusData(experimentsData.experiments);

            // Draw the charts
            drawPieChart('quantitative-chart', 'Quantitative Results Pass/Fail Ratio', quantitativeChartData);
            drawPieChart('qualitative-chart', 'Qualitative Results Pass/Fail Ratio', qualitativeChartData);
            drawPieChart('experiment-status-chart', 'Experiments by Status', experimentStatusData);
        } catch (error) {
            console.error('Error loading chart data:', error);
        }
    }

    // Helper to transform pass/fail data
    function transformPassFailData(data, field) {
        const counts = data.reduce(
            (acc, item) => {
                if (item[field] === 1) acc.Pass++; // 1 indicates Pass
                else if (item[field] === 0) acc.Fail++; // 0 indicates Fail
                return acc;
            },
            { Pass: 0, Fail: 0 }
        );
        return [['Result', 'Count'], ['Pass', counts.Pass], ['Fail', counts.Fail]];
    }


    // Helper to transform experiment status data
    function transformExperimentStatusData(data) {
        const counts = data.reduce((acc, item) => {
            acc[item.Status] = (acc[item.Status] || 0) + 1;
            return acc;
        }, {});
        return [['Status', 'Count'], ...Object.entries(counts)];
    }

    // Helper to draw a pie chart
    function drawPieChart(elementId, title, data) {
        const chartData = google.visualization.arrayToDataTable(data);
        const options = {
            title: title,
            is3D: true
        };
        const chart = new google.visualization.PieChart(document.getElementById(elementId));
        chart.draw(chartData, options);
    }
});




