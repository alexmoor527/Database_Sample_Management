document.addEventListener('DOMContentLoaded', () => {
    // Initialize each tab
    loadOperators();
    loadExperiments();
    loadSamples();
    loadMethods();
    loadAnalysts();

    // Add operator functionality
    document.getElementById('add-operator-form').addEventListener('submit', (event) => {
        event.preventDefault();
        const name = document.getElementById('name').value;
        const contact = document.getElementById('contact').value;
        addEntry('/add_operator', { name, contact }, loadOperators);
    });

    // Add experiment functionality
    document.getElementById('add-experiment-form').addEventListener('submit', (event) => {
        event.preventDefault();
        const name = document.getElementById('experiment-name').value;
        const startDate = document.getElementById('start-date').value;
        const endDate = document.getElementById('end-date').value;
        const description = document.getElementById('description').value;
        const operatorId = document.getElementById('operator-id').value;
        addEntry('/add_experiment', { name, startDate, endDate, description, operatorId }, loadExperiments);
    });

    // Add sample functionality
    document.getElementById('add-sample-form').addEventListener('submit', (event) => {
        event.preventDefault();
        const experimentId = document.getElementById('sample-experiment-id').value;
        const name = document.getElementById('sample-name').value;
        const description = document.getElementById('sample-description').value;
        const operatorId = document.getElementById('sample-operator-id').value;
        addEntry('/add_sample', { experimentId, name, description, operatorId }, loadSamples);
    });

    // Add method functionality
    document.getElementById('add-method-form').addEventListener('submit', (event) => {
        event.preventDefault();
        const name = document.getElementById('method-name').value;
        const description = document.getElementById('method-description').value;
        addEntry('/add_method', { name, description }, loadMethods);
    });

    // Add analyst functionality
    document.getElementById('add-analyst-form').addEventListener('submit', (event) => {
        event.preventDefault();
        const name = document.getElementById('analyst-name').value;
        const contact = document.getElementById('analyst-contact').value;
        addEntry('/add_analyst', { name, contact }, loadAnalysts);
    });

    // Search functionality for all tabs
    setupSearch('search-operators', 'operators-table');
    setupSearch('search-experiments', 'experiments-table');
    setupSearch('search-samples', 'samples-table');
    setupSearch('search-methods', 'methods-table');
    setupSearch('search-analysts', 'analysts-table');
});

// Fetch and display operators
function loadOperators() {
    fetch('/operators')
        .then(response => response.json())
        .then(data => renderTable('operators-table', data.operators, ['OperatorID', 'Name', 'ContactInfo']))
        .catch(error => console.error('Error loading operators:', error));
}

// Fetch and display experiments
function loadExperiments() {
    fetch('/experiments')
        .then(response => response.json())
        .then(data => renderTable('experiments-table', data.experiments, ['ExperimentID', 'Name', 'StartDate', 'EndDate', 'Description', 'OperatorID']))
        .catch(error => console.error('Error loading experiments:', error));
}


// Fetch and display samples
function loadSamples() {
    fetch('/samples')
        .then(response => response.json())
        .then(data => renderTable('samples-table', data.samples, ['SampleID', 'ExperimentID', 'Name', 'Description', 'OperatorID']))
        .catch(error => console.error('Error loading samples:', error));
}

// Fetch and display methods
function loadMethods() {
    fetch('/methods')
        .then(response => response.json())
        .then(data => renderTable('methods-table', data.methods, ['MethodID', 'Name', 'Description']))
        .catch(error => console.error('Error loading methods:', error));
}

// Fetch and display analysts
function loadAnalysts() {
    fetch('/analysts')
        .then(response => response.json())
        .then(data => renderTable('analysts-table', data.analysts, ['AnalystID', 'Name', 'ContactInfo']))
        .catch(error => console.error('Error loading analysts:', error));
}

// Helper to send data to the server
function addEntry(endpoint, payload, callback) {
    fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            callback(); // Refresh the table
        })
        .catch(error => console.error(`Error adding entry to ${endpoint}:`, error));
}

// Helper to render a table dynamically
function renderTable(tableId, data, columns) {
    const tableBody = document.getElementById(tableId);
    tableBody.innerHTML = ''; // Clear existing rows
    data.forEach(item => {
        const row = document.createElement('tr');
        columns.forEach(column => {
            const cell = document.createElement('td');
            cell.textContent = item[column];
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





