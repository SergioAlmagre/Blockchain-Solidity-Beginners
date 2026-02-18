# Smart contracts con Solidity: Nivel Avanzado

En este nivel nos enfocamos en patrones de diseño más complejos, optimización de gas y estructuras de control avanzadas.

## Contenido del Curso

### 1. Bucles y Condicionales
**Archivo:** `1_bucles_y_condicionales.sol`

Control de flujo dentro de los Smart Contracts.
- **Bucles:** Uso de `for` y `while` para iteraciones.
- **Condicionales:** Sentencias `if` y `else` para lógica de negocio.
- **Comparación de Strings:** Uso de `keccak256` para comparar cadenas de texto (ya que Solidity no permite `==` directo entre strings).

### 2. Funciones Avanzadas, Herencia y Modificadores
**Archivo:** `2_funciones_avanzadas.sol`

Estructuración profesional de contratos y reutilización de código.
- **Herencia:** Cómo un contrato puede heredar propiedades y funciones de otro (`is`).
- **Visibilidad:** Diferencias clave entre `public`, `private`, `internal` y `external`.
- **Modificadores (Modifiers):** Creación de reglas reutilizables para restringir el acceso a funciones (ej. `onlyOwner`).

### 3. Patrón Fábrica (Factory Pattern)
**Archivo:** `2_fabricas.sol`

Patrones de diseño para la creación dinámica de contratos.
- **Despliegue dinámico:** Uso de la palabra clave `new` para crear contratos desde otro contrato.
- **Registro:** Almacenamiento de direcciones de contratos hijos en mappings.
- **Interacción Padre-Hijo:** Cómo enviar datos al constructor del nuevo contrato.
