# Creación de Tokens ERC-721 (NFTs)

Este módulo cubre el estándar ERC-721, utilizado para representar propiedades digitales únicas y no replicables, comúnmente conocidas como Tokens No Fungibles (NFTs).

## Contenido del Módulo

### 1. Creación de un NFT Básico
**Archivo:** `1_custom_ERC721.sol`

Implementación de un token no fungible utilizando la librería estándar de OpenZeppelin.
- **Diferencia Fungible vs No Fungible:** Por qué un token ERC-20 es intercambiable (como el dinero) y un ERC-721 es único (como una obra de arte).
- **Gestión de IDs (Counters):** Uso de la librería `Counters` de OpenZeppelin para asignar un identificador numérico único secuencial a cada pieza minteada.
- **Minteo Seguro (`_safeMint`):** Explicación de cómo la función segura evita la pérdida irrecuperable de tokens al enviarlos a contratos que no los soportan.

### 2. Colección de Arte NFT (Avanzado)
**Archivo:** `2_art.sol`

Implementación completa de una colección de NFTs (tipo PFP o Arte Digital) estructurada para producción.
- **Minteo de Pago (`payable`):** Cómo exigir un pago en la criptomoneda nativa (Ethers) para permitir la creación del NFT.
- **Metadatos y Atributos:** Uso de `struct` para almacenar características únicas en la cadena (ADN, Rareza, Nivel).
- **Propietario del Contrato (`Ownable`):** Implementación de esta librería para restringir funciones (ej. retirar los Ethers ganados) únicamente al administrador.
- **Retiro de Fondos (`withdraw`):** El patrón estándar y seguro usando `.call{value: ...}("")` para extraer la recaudación del contrato.

## Conceptos Clave
- **Unicidad:** Cada NFT dentro de un mismo contrato inteligente se diferencia de los demás por su `tokenId`.
- **Propiedad Digital:** Los NFTs se utilizan en casos de uso como criptoarte, entradas a eventos, objetos de videojuegos y registro de propiedad intelectual.
- **Compatibilidad:** Para que un contrato inteligente (que no sea un EOA o wallet de usuario) pueda recibir un NFT, debe implementar la interfaz `IERC721Receiver`.
