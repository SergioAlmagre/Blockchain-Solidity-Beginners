# 1. Fundamentos Básicos de Programación de Smart Contracts

Este módulo sienta las bases necesarias para empezar a programar en **Solidity**. A través de una serie de scripts progresivos, aprenderás desde la estructura mínima de un contrato hasta el manejo de transacciones de Ether y operaciones matemáticas seguras.

Cada archivo en esta carpeta (`.sol`) está diseñado para enseñar un concepto específico de forma aislada y clara.

---

## 📚 Contenido del Módulo

A continuación, se detalla qué aprenderás en cada script:

### [1_primeros_pasos.sol](./1_primeros_pasos.sol)
**El "Hola Mundo" de los Smart Contracts y la herencia.**
- **Estructura básica:** `pragma`, `contract`, y `license`.
- **Herencia:** Cómo reutilizar código de librerías estandarizadas como **OpenZeppelin**.
- **Constructores:** La función especial que se ejecuta una única vez al desplegar el contrato.
- **Variables de estado:** Almacenamiento persistente en la blockchain (`address public owner`).

### [2_variables_modificadores.sol](./2_variables_modificadores.sol)
**Tipos de datos y visibilidad.**
- **Tipos de valor:** `uint` (enteros sin signo), `int` (enteros con signo), `bool` (booleanos).
- **Strings y Bytes:** Diferencias entre `string` y `bytes32` (optimización de gas).
- **Visibilidad:**
  - `public`: Accesible desde fuera y dentro. Genera un "getter" automático.
  - `private`: Solo accesible desde el propio contrato (no desde herencia).
- **Enums:** Creación de estados personalizados (ej: `ON`, `OFF`) para gestionar el flujo lógico.

### [3_hashing.sol](./3_hashing.sol)
**Criptografía básica en Solidity.**
- **Funciones de Hash:** Transformación de datos arbitrarios en una cadena de longitud fija y única.
- **Algoritmos principales:**
  - `keccak256`: El estándar de Ethereum (usado para firmas, IDs, etc.).
  - `sha256`: Estándar común (Bitcoin).
  - `ripemd160`: Hash más corto (20 bytes).
- **`abi.encodePacked`**: Cómo empaquetar argumentos antes de hashearlos.

### [4_estructuras_de_datos.sol](./4_estructuras_de_datos.sol)
**Organización de datos complejos.**
- **Structs:** Creación de tipos de datos personalizados (ej: `Customer` con id, nombre, email).
- **Arrays (Listas):**
  - **Fijos:** Tamaño predefinido (`uint[5]`).
  - **Dinámicos:** Crecen según necesidad (`Customer[]`).
- **Mappings (Diccionarios):** La estructura más usada en Solidity para asociaciones clave-valor (ej: `address => saldo`).
  - Mappings simples y mappings complejos (mappings de structs o arrays).

### [5_funciones_sencillas.sol](./5_funciones_sencillas.sol)
**Tipos de Funciones y Gas.**
- **`view`**: Funciones que **LEEN** el estado de la blockchain pero no lo modifican. No consumen gas si se llaman externamente.
- **`pure`**: Funciones que **NO LEEN NI MODIFICAN** el estado. Solo operan con los datos que se les pasan. Tampoco consumen gas externamente.
- Entender esto es crucial para optimizar costes de ejecución.

### [6_funciones_payables.sol](./6_funciones_payables.sol)
**Manejo de Ether (Dinero programable).**
- **Modificador `payable`**: Permite que una función reciba Ether.
- **Métodos de envío:**
  - `transfer()`: Método antiguo (límite 2300 gas). Revierte si falla.
  - `send()`: Método antiguo. Devuelve `false` si falla.
  - `call()`: **Método recomendado**. Sin límite de gas por defecto, devuelve un booleano de éxito.
- **Recepción de Ether:** Cómo usar `receive()` y `fallback()` para aceptar pagos directos.

### [7_fallback_receive.sol](./7_fallback_receive.sol)
**Funciones especiales de "Respaldo".**
- Diferencia crítica entre `receive()` y `fallback()`.
- **`receive()`**: Se ejecuta cuando recibes Ether sin datos (una transferencia simple).
- **`fallback()`**: Se ejecuta cuando llamas a una función que NO existe, o envías datos con Ether pero sin `receive`.
- Importancia en la seguridad y en patrones como **Proxies**.

### [8_operaciones_matematicas.sol](./8_operaciones_matematicas.sol)
**Aritmética segura.**
- Operaciones básicas: Suma, resta, multiplicación, división, módulo y exponenciación.
- **Overflow/Underflow automáticos:** Cómo Solidity 0.8+ protege automáticamente contra desbordamientos numéricos (haciendo revertir la transacción).
- **Funciones avanzadas:** `addmod` y `mulmod` para criptografía y aritmética de precisión arbitraria.

---

## 🎯 Objetivo de este Módulo

Al finalizar este bloque, deberías ser capaz de:
1. Escribir un contrato inteligente desde cero.
2. Elegir el tipo de variable adecuado para ahorrar gas.
3. Crear estructuras de datos para guardar información de usuarios.
4. Enviar y recibir pagos en Ether de forma segura.
5. Entender por qué una transacción puede fallar (revert) debido a errores lógicos o aritméticos.

¡Manos a la obra! 🚀
