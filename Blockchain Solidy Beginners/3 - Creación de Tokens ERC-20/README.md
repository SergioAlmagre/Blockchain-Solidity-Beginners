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

## El Estándar ERC-20
El estándar ERC-20 define una interfaz común que permite que los tokens funcionen de manera predecible en carteras (wallets), exchanges y otros contratos inteligentes. Incluye funciones como `transfer`, `balanceOf`, `approve` y `allowance`.
