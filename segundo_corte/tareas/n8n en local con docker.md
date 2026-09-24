porque ? porque es gratis

### Flujo diario: Cómo encender y usar n8n

Cada vez que enciendas tu equipo Linux, solo debes seguir estos **3 pasos**:

#### 1. Iniciar el servicio de Docker (si no arranca solo)

Abre la terminal y verifica que el motor de Docker esté activo. Si no, lo inicias con:

Bash

```
sudo systemctl start docker
```

#### 2. Encender el contenedor de n8n

Como ya creaste el contenedor con el nombre `n8n`, solo debes decirle a Docker que lo despierte corriendo este comando en la terminal:

Bash

```
docker start n8n
```

_(Si en algún momento quieres detenerlo manualmente antes de apagar la PC, usas `docker stop n8n`)._

#### 3. Entrar a la interfaz desde el navegador

Abre Firefox, Chrome o tu navegador favorito e ingresa a:

Plaintext

```
http://localhost:5678
```

¡Y listo! Ahí estará tu n8n tal cual como lo dejaste, con todos tus flujos, cuentas y configuraciones intactas.

|**Acción**|**Comando**|
|---|---|
|**Iniciar n8n**|`docker start n8n`|
|**Detener n8n**|`docker stop n8n`|
|**Ver si está corriendo**|`docker ps`|
|**Ver todos los contenedores**|`docker ps -a`|
|**Ver errores/logs de n8n**|`docker logs -f n8n`|

---
## Instalar Docker
### Paso 1: Instalar Docker en Fedora

Abre la terminal de Fedora y ejecuta los siguientes comandos uno por uno:

1. **Instalar el motor de Docker:**
    
    Bash
    
    ```
    sudo dnf install -y docker
    ```
    
2. **Iniciar el servicio de Docker y habilitarlo para que arranque automáticamente:**
    
    Bash
    
    ```
    sudo systemctl start docker
    sudo systemctl enable docker
    ```
    
3. **Agregar tu usuario al grupo Docker (Paso Clave):** Esto sirve para que no tengas que escribir `sudo` cada vez que vayas a usar Docker.
    
    Bash
    
    ```
    sudo usermod -aG docker $USER
    ```
    
4. **Aplicar los cambios de grupo:** Para que el sistema reconozca que ya perteneces al grupo Docker, ejecuta:
    
    Bash
    
    ```
    newgrp docker
    ```
    
5. **Verificar que Docker esté funcionando:**
    
    Bash
    
    ```
    docker run hello-world
    ```
    
    _(Si te sale un mensaje de bienvenida de Docker, ¡ya quedó perfectamente instalado!)_
    

### Paso 2: Desplegar n8n con Docker

Ahora que Docker está listo, ejecuta estos dos comandos para crear y levantar tu contenedor de **n8n**:

1. **Crear el volumen para guardar los datos de n8n:**
    
    Bash
    
    ```
    docker volume create n8n_data
    ```
    
2. **Lanzar el contenedor de n8n:**
    
    Bash
    
    ```
    docker run -d \
      --name n8n \
      -p 5678:5678 \
      -v n8n_data:/home/node/.n8n \
      --add-host=host.docker.internal:host-gateway \
      n8nio/n8n
    ```
    

### Paso 3: Abrir n8n en el Navegador

1. Abre tu navegador web y entra a esta dirección:
    
    Plaintext
    
    ```
    http://localhost:5678
    ```
    
2. Te pedirá crear una cuenta inicial de administrador (puedes poner tu correo y la contraseña que quieras; todo queda guardado localmente en tu PC).
    

### 💡 Nota importante para conectar n8n con tus BD locales

Cuando vayas a crear las credenciales de tu base de datos (**PostgreSQL** o **MariaDB**) dentro de la interfaz de n8n:

- En el campo **Host / Server**, en lugar de poner `localhost` o `127.0.0.1`, vas a escribir:
    
    Plaintext
    
    ```
    host.docker.internal
    ```
    
    _¿Por qué?_ Porque n8n está corriendo "encerrado" dentro de un contenedor. La dirección `host.docker.internal` es el puente que le permite a n8n salir del contenedor y conectarse a PostgreSQL o MariaDB que están corriendo directamente en tu sistema Fedora.