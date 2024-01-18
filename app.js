import express from 'express';
import mariadb from 'mariadb';

const app = express();
let port = process.env.PORT || 3000;

console.log('DB_HOST:', process.env.DB_HOST);
// Configurations de la base de données
const pool = mariadb.createPool({
    host: process.env.DB_HOST || 'mariadb',
    user: process.env.DB_USER || 'mariaDB',
    password: process.env.DB_PASSWORD || 'mariaDB',
    database: process.env.DB_DATABASE || 'finalDB',
    connectionLimit: 5
});

app.get('/', async (req, res) => {
    res.status(200).json({message: 'Bienvenue sur l\'API de votre application'});
});

app.get('/post', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query('SELECT * FROM posts');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: 'Erreur lors de la récupération des posts'});
    } finally {
        if (conn) return conn.end();
    }
});
app.get('/test', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Test Page for Lighthouse</title>
        </head>
        <body>
            <h1>Hello Lighthouse!</h1>
        </body>
        </html>
    `);
});

function findAvailablePort() {
    return new Promise((resolve, reject) => {
        const server = app.listen(port, () => {
            const foundPort = server.address().port;
            server.close(() => resolve(foundPort));
        });

        server.on('error', (err) => {
            if (err.code === 'EADDRINUSE') {
                port++;
                server.close();
            } else {
                reject(err);
            }
        });
    });
}

// Lancer le serveur en utilisant le port disponible
findAvailablePort()
    .then((availablePort) => {
        port = availablePort;
        app.listen(port, () => {
            console.log(`Serveur en cours d'exécution sur le port ${port}`);
        });
    })
    .catch((err) => {
        console.error('Erreur lors du démarrage du serveur:', err);
    });

export default app;
