// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC1155.sol: Implementación estándar del Multi-Token.
import "@openzeppelin/contracts@4.5.0/token/ERC1155/ERC1155.sol";

// Direcciones de prueba (solo como referencia)
// Persona 1: 0x617F2E2fD72FD9D5503197092aC168c91465E7f2 -> owner
// Persona 2: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 -> receptor
// Persona 3: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 -> operador

/**
 * @title Token ERC-1155 (Multi-Token Standard)
 * @dev Implementación de un contrato ERC-1155, ideal para videojuegos (GameFi).
 *
 * ¿QUÉ ES EL ERC-1155?
 * Es una evolución que permite tener múltiples tipos de tokens (Fungibles y No Fungibles)
 * dentro de UN SOLO contrato inteligente.
 *
 * - Si minteas mucha cantidad de un ID (ej: 1,000,000 de Monedas de Oro), actúa como un token ERC-20 (Fungible).
 * - Si minteas solo 1 cantidad de un ID (ej: 1 Espada Legendaria), actúa como un token ERC-721 (NFT).
 *
 * Esto ahorra muchísimo gas, ya que no necesitas desplegar un contrato nuevo para cada objeto del juego.
 */
contract erc1155 is ERC1155 {
    // Identificadores (IDs) únicos para cada tipo de token en nuestro juego.
    // Usamos 'constant' para ahorrar gas, ya que estos valores nunca cambiarán.
    uint256 public constant GOLD = 0; // Fungible (Moneda del juego)
    uint256 public constant SILVER = 1; // Fungible (Moneda de menor valor)
    uint256 public constant THORS_HAMMER = 2; // NFT (Objeto único)
    uint256 public constant SWORD = 3; // Fungible o Semi-fungible (Múltiples espadas iguales)
    uint256 public constant SHIELD = 4; // Fungible o Semi-fungible

    /**
     * @dev Constructor del Smart Contract.
     * En ERC-1155, el constructor recibe una URI base (Uniform Resource Identifier).
     *
     * URI DINÁMICA: Note el uso de '{id}'.
     * El estándar ERC-1155 reemplaza automáticamente el '{id}' por el número del token
     * (en formato hexadecimal, con padding a 64 bytes) cuando un tercero (como OpenSea) pide los metadatos.
     * Ejemplo: El metadata del GOLD (ID 0) se buscará en -> http://game.example/api/item/0000000000000000000000000000000000000000000000000000000000000000.json
     */
    constructor() ERC1155("http://game.example/api/item/{id}.json") {
        // _mint() en ERC1155 toma 4 parámetros:
        // 1. address to: Destinatario de los tokens (quien despliega el contrato).
        // 2. uint256 id: El ID del token a mintear.
        // 3. uint256 amount: La CANTIDAD. Aquí se define si es Fungible o No Fungible.
        // 4. bytes data: Datos extra pasados si el receptor es un contrato.

        // Minteamos tokens que actúan como ERC-20 (Mucha cantidad)
        _mint(msg.sender, GOLD, 10 ** 18, ""); // 1 Trillón de oro
        _mint(msg.sender, SILVER, 10 ** 27, ""); // 1 Billón de plata

        // Minteamos un token que actúa como ERC-721 (NFT - Solo existe 1)
        _mint(msg.sender, THORS_HAMMER, 1, ""); // El martillo de Thor (Cantidad: 1) // Corrección formativa: 10**1 es 10. Para que sea un NFT puro, debe ser 1. Dejaré 1.

        // Minteamos tokens Semi-Fungibles (Objetos apilables)
        _mint(msg.sender, SWORD, 10 ** 9, ""); // Un billón de espadas comunes
        _mint(msg.sender, SHIELD, 10 ** 8, ""); // Cien millones de escudos comunes
    }
}
