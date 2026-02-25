# Creación de Tokens ERC-20

Este módulo cubre el estándar ERC-20, el más utilizado para la creación de tokens fungibles en la red Ethereum y compatibles.

## Contenido del Módulo

### 1. Tokens con OpenZeppelin
**Archivo:** `1_ERC20_openzeppelin.sol`

Uso de la librería estándar de la industria para crear tokens de forma segura y eficiente.
- **Herencia de OpenZeppelin:** Cómo extender la funcionalidad del contrato `ERC20`.
- **Minting Inicial:** Creación de un suministro inicial de tokens en el momento del despliegue.
- **Símbolo y Nombre:** Configuración de los metadatos del token ("Gold", "GLD").

### 2. Token ERC-20 Personalizado
**Archivo:** `2_custom_ERC20.sol`

Implementación utilizando una base local para entender mejor la estructura interna.
- **Importación Local:** Diferencias entre importar desde node_modules vs archivos locales.
- **Función createTokens:** Permite a los usuarios generar (mintear) sus propios tokens dinámicamente.
- **Interacción con el Padre:** Llamadas a funciones internas del contrato base.

### 3. Interfaz ERC-20 e Implementación
**Archivo:** `3_interfaz_ERC20.sol`

Profundización en la arquitectura de contratos mediante el uso de interfaces.
- **Interfaces (`interface`):** Qué son y por qué son fundamentales para la interoperabilidad. Son contratos que solo declaran funciones sin implementarlas.
- **Implementación de Interfaz:** Cómo un contrato puede implementar una interfaz usando la palabra clave `override`.
- **Interacción Externa:** Las interfaces permiten interactuar con cualquier token ERC-20 desplegado en la red (como USDT, DAI, etc.) sin necesidad de tener el código fuente completo del mismo.

## Conceptos Clave
- **Standard IERC20:** La interfaz que define el estándar mínimo para que un token sea compatible con el ecosistema Ethereum.
- **Herencia y Override:** El uso de `virtual` y `override` para extender y definir funcionalidades en contratos secundarios.
