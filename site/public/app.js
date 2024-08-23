document.getElementById('taskForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const taskInput = document.getElementById('taskInput');
    const warning = document.getElementById('warning');

    // Validação para garantir que o campo não esteja vazio
    if (!taskInput.value.trim()) {
        warning.textContent = 'O campo onde você digita a tarefa não pode ser nulo.';
        return;
    }

    const task = { observacao: taskInput.value };

    const response = await fetch('/tasks', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(task)
    });

    const newTask = await response.json();
    addTaskToDOM(newTask);
    taskInput.value = '';
    warning.textContent = ''; // Limpa a mensagem de aviso após adicionar a tarefa
});

async function loadTasks(period = null) {
    let url = '/tasks';
    if (period) {
        url += `?period=${period}`;
    }

    const response = await fetch(url);
    const tasks = await response.json();
    document.getElementById('tasks').innerHTML = '';
    tasks.forEach(addTaskToDOM);
}

function addTaskToDOM(task) {
    const taskDiv = document.createElement('div');
    taskDiv.className = `task ${task.concluido ? 'completed' : 'pending'}`;
    taskDiv.dataset.id = task.id; // Adiciona o ID da tarefa ao atributo data-id

    const taskText = document.createElement('span');
    taskText.textContent = task.observacao;

    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = task.concluido;
    checkbox.addEventListener('change', () => toggleTaskCompletion(task.id, checkbox.checked, taskDiv));

    const deleteButton = document.createElement('button');
    deleteButton.textContent = 'Deletar';
    deleteButton.className = 'delete-btn';
    deleteButton.addEventListener('click', () => deleteTask(task.id, taskDiv));

    taskDiv.appendChild(taskText);
    taskDiv.appendChild(checkbox);
    taskDiv.appendChild(deleteButton);
    document.getElementById('tasks').appendChild(taskDiv);
}

async function toggleTaskCompletion(id, isCompleted, taskDiv) {
    const response = await fetch(`/tasks/${id}`, {
        method: 'PUT'
    });
    const updatedTask = await response.json();
    taskDiv.className = `task ${isCompleted ? 'completed' : 'pending'}`;
}

async function deleteSelectedTasks() {
    const tasksDiv = document.getElementById('tasks');
    const taskDivs = tasksDiv.querySelectorAll('.task');
    const tasksToDelete = [];

    // Verifica quais tarefas estão selecionadas
    taskDivs.forEach(taskDiv => {
        const checkbox = taskDiv.querySelector('input[type="checkbox"]');
        if (checkbox.checked) {
            const taskId = taskDiv.dataset.id; // Assume-se que o ID da tarefa está armazenado em um atributo data-id no elemento taskDiv
            tasksToDelete.push(taskId);
        }
    });

    if (tasksToDelete.length === 0) {
        alert('Selecione pelo menos uma tarefa para deletar.');
        return;
    }

    const confirmation = confirm(`Tem certeza que deseja deletar ${tasksToDelete.length} tarefa(s)?`);
    if (confirmation) {
        await Promise.all(tasksToDelete.map(deleteTask));
        loadTasks(); // Recarrega as tarefas após a deleção
    }
}

async function deleteTask(id, taskDiv = null) {
    const response = await fetch(`/tasks/${id}`, {
        method: 'DELETE'
    });
    const result = await response.json();
    console.log(result); // Apenas para debug, você pode tratar o resultado conforme necessário

    // Remove a tarefa do DOM se taskDiv for fornecido
    if (taskDiv) {
        taskDiv.remove();
    }
}

function filterTasks(period) {
    loadTasks(period);
}

loadTasks();