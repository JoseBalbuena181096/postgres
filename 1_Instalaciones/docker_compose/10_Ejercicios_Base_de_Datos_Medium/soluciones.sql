-- Soluciones a los ejercicios de Base de Datos Medium
-- Basado en el esquema de tablas: users, posts, comments, claps, user_lists, user_list_entry

-- 1. Cuantos Post hay - 1050
SELECT COUNT(*) as total_posts 
FROM posts;

-- 2. Cuantos Post publicados hay - 543
SELECT COUNT(*) as published_posts 
FROM posts 
WHERE published = true;

-- 3. Cual es el Post mas reciente
-- 544 - nisi commodo officia...2024-05-30 00:29:21.277
SELECT post_id, title, created_at 
FROM posts 
ORDER BY created_at DESC 
LIMIT 1;

-- 4. Quiero los 10 usuarios con más post, cantidad de posts, id y nombre
SELECT 
    COUNT(p.post_id) as post_count,
    u.user_id,
    u.name
FROM users u
INNER JOIN posts p ON u.user_id = p.created_by
GROUP BY u.user_id, u.name
ORDER BY post_count DESC
LIMIT 10;

-- 5. Quiero los 5 post con más "Claps" sumando la columna "counter"
SELECT 
    p.post_id,
    p.title,
    SUM(c.counter) as total_claps
FROM posts p
INNER JOIN claps c ON p.post_id = c.post_id
GROUP BY p.post_id, p.title
ORDER BY total_claps DESC
LIMIT 5;

-- 6. Top 5 de personas que han dado más claps (voto único no acumulado) *count
SELECT 
    COUNT(c.clap_id) as clap_count,
    u.name
FROM users u
INNER JOIN claps c ON u.user_id = c.user_id
GROUP BY u.user_id, u.name
ORDER BY clap_count DESC
LIMIT 5;

-- 7. Top 5 personas con votos acumulados (sumar counter)
SELECT 
    SUM(c.counter) as total_counter,
    u.name
FROM users u
INNER JOIN claps c ON u.user_id = c.user_id
GROUP BY u.user_id, u.name
ORDER BY total_counter DESC
LIMIT 5;

-- 8. Cuantos usuarios NO tienen listas de favoritos creada - 329
SELECT COUNT(*) as users_without_lists
FROM users u
LEFT JOIN user_lists ul ON u.user_id = ul.user_id
WHERE ul.user_list_id IS NULL;

-- 9. Quiero el comentario con id 1
-- Y en el mismo resultado, quiero sus respuestas (visibles e invisibles)
-- Tip: union
SELECT 
    comment_id,
    post_id,
    user_id,
    content
FROM comments 
WHERE comment_id = 1

UNION ALL

SELECT 
    comment_id,
    post_id,
    user_id,
    content
FROM comments 
WHERE comment_parent_id = 1
ORDER BY comment_id;

-- 10. Avanzado
-- Investigar sobre el json_agg y json_build_object
-- Crear una única linea de respuesta, con las respuestas
-- del comentario con id 1 (comment_parent_id = 1)
-- Mostrar el user_id y el contenido del comentario
SELECT json_agg(
    json_build_object(
        'user', user_id,
        'comment', content
    )
) as replies
FROM comments 
WHERE comment_parent_id = 1;

-- 11. Avanzado
-- Listar todos los comentarios principales (no respuestas) 
-- Y crear una columna adicional "replies" con las respuestas en formato JSON
SELECT 
    c.comment_id,
    c.post_id,
    c.user_id,
    c.content,
    c.created_at,
    COALESCE(
        (SELECT json_agg(
            json_build_object(
                'comment_id', r.comment_id,
                'user_id', r.user_id,
                'content', r.content,
                'created_at', r.created_at,
                'visible', r.visible
            )
        )
        FROM comments r 
        WHERE r.comment_parent_id = c.comment_id),
        '[]'::json
    ) as replies
FROM comments c
WHERE c.comment_parent_id IS NULL
ORDER BY c.comment_id;
```

## Función saludar
-- Crear una función que reciba un nombre y retorne un saludo
-- Ejemplo: saludar('Juan') -> 'Hola Juan!'
```SQL
CREATE OR REPLACE FUNCTION saludar(nombre TEXT)
RETURNS TEXT AS 
$$
BEGIN
    RETURN 'Hola ' || nombre || '!';
END
$$
LANGUAGE plpgsql;

SELECT saludar('Juan');
```

## Solucion de ejercicio 11 con funciones 

```SQL
CREATE OR REPLACE FUNCTION comment_replies(id INT)
RETURNS JSON AS 
$$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'user', user_id,
            'comment', content
        )
    ) as replies INTO result
    FROM comments 
    WHERE comment_parent_id = id;
    RETURN result;
END
$$
LANGUAGE plpgsql;

SELECT comment_replies(2);
```
La consulta 11 con la función comment_replies
```SQL
SELECT a.*, 
    comment_replies(a.comment_id) as replies
FROM comments a
WHERE a.comment_parent_id IS NULL
ORDER BY a.comment_id;
```