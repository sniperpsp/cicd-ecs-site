const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');

const app = express();
const port = 8080;

// Configuração do pool de conexões com o PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: 'banco-todo.trustcompras.com.br',
  database: 'postgres',
  password: 'postgres',
  port: 5432,
});

app.use(bodyParser.json());
app.use(express.static('public'));

// Endpoint para adicionar uma nova tarefa
app.post('/tasks', async (req, res) => {
  const { observacao } = req.body;

  // Validação para garantir que o campo não seja null
  if (!observacao) {
    return res.status(400).json({ error: 'O campo observacao é obrigatório.' });
  }

  const result = await pool.query(
    'INSERT INTO agenda (observacao) VALUES ($1) RETURNING *',
    [observacao]
  );
  res.status(201).json(result.rows[0]);
});

// Endpoint para marcar uma tarefa como concluída
app.put('/tasks/:id', async (req, res) => {
  const { id } = req.params;
  const result = await pool.query(
    'UPDATE agenda SET concluido = TRUE, data_finalizado = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *',
    [id]
  );
  res.json(result.rows[0]);
});

// Endpoint para obter todas as tarefas
app.get('/tasks', async (req, res) => {
  const { period } = req.query;
  let query = 'SELECT * FROM agenda ORDER BY data_criacao DESC';
  let values = [];

  if (period) {
    query = 'SELECT * FROM agenda WHERE data_criacao >= NOW() - INTERVAL $1 ORDER BY data_criacao DESC';
    values = [period];
  }

  const result = await pool.query(query, values);
  res.json(result.rows);
});

// Endpoint para deletar uma tarefa
app.delete('/tasks/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      'DELETE FROM agenda WHERE id = $1 RETURNING *',
      [id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});