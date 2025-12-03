<?php
if(isset($_FILES['file'])){
    $file = $_FILES['file']['name'];
    $dest = "uploads/" . $file;

    // ❌ Sin validación de extensión
    // ❌ Sin validación MIME
    // ❌ Sin saneamiento del nombre
    // ❌ Sin control de tamaño
    // ❌ Sin control de permisos

    if(move_uploaded_file($_FILES['file']['tmp_name'], $dest)){
        echo "Archivo subido: <a href='uploads/$file'>$file</a>";
    } else {
        echo "Error subiendo archivo.";
    }
}
?>

<html>
<body>
    <h2>Subida INSEGURA de archivos</h2>
    <form method="POST" enctype="multipart/form-data">
        <input type="file" name="file">
        <input type="submit" value="Subir">
    </form>
</body>
</html>
