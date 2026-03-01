# Creación de Tokens ERC-1155 (Multi-Token Standard)

Este módulo cubre el estándar **ERC-1155**, diseñado inicialmente por Enjin. Es conocido como el "estándar Multi-Token" porque permite gestionar múltiples tipos de tokens desde un único contrato inteligente.

## Contenido del Módulo

### 1. El estándar Multi-Token (GameFi)
**Archivo:** `1_ERC1155.sol`

Implementación de un contrato ERC-1155 ideal para casos de uso como los videojuegos de la Web3 (GameFi).
- **Híbrido (Fungible y No Fungible):** Explicación de cómo un mismo contrato maneja el estado de monedas del juego (fungibles, cantidad alta) y objetos únicos (no fungibles, cantidad = 1).
- **Control de IDs:** Manejo de variables `constant` para definir de manera legible y eficiente en gas los diferentes objetos del ecosistema.
- **Eficiencia de Gas:** ¿Por qué crear 10 contratos diferentes para 10 objetos cuando puedes gestionarlos todos en 1 solo?
- **URIs Dinámicas:** Funcionamiento del mecanismo `{id}.json` para gestionar masivamente los metadatos de cientos de tokens distintos devolviendo dinámicamente el enlace correspondiente a cada ID.

## Conceptos Clave
- **Batch Transfers:** A diferencia de ERC-20 y ERC-721, ERC-1155 permite agrupar múltiples tokens distintos en una sola transacción (`safeBatchTransferFrom`), reduciendo enormemente los costes de comisión (gas) en la red Ethereum.
- **Semi-Fungibilidad:** Permite la existencia de tokens "semi-fungibles", por ejemplo, entradas para un concierto: son fungibles antes del evento (cualquier entrada vale para entrar) y se vuelven no-fungibles (coleccionables) después del evento.
