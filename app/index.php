<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<h1 style="text-align: center;">Libros Disponibles</h1>
<?php
    $host = getenv('DB_HOST') ?: '127.0.0.1';
    $dbname = 'biblioteca_db';
    $username = 'biblioteca_user';
    $password = 'secret123';

    try {
        $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $stmt = $conn->prepare("SELECT * FROM libros");
        $stmt->execute();
        echo '<table>';
        echo '<tr><th>ID</th><th>Título</th><th>Autor</th><th>Año</th></tr>';

        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo '<tr>';
            echo '<td>' . $row['id'] . '</td>';
            echo '<td>' . htmlspecialchars($row['titulo']) . '</td>';
            echo '<td>' . htmlspecialchars($row['autor']) . '</td>';
            echo '<td>' . $row['año_publicacion'] . '</td>';
            echo '</tr>';
        }
        echo '</table>';
    } catch(PDOException $e) {
        echo "<p style='color: red; text-align: center;'>Error de conexión: " .
        $e->getMessage() . "</p>";
    }
?>
</body>
</html>