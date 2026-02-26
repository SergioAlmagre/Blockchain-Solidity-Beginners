// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Importación de Smart Contracts de OpenZeppelin
// ERC721.sol: Contiene la lógica estándar para Tokens No Fungibles (NFTs).
// Counters.sol: Una librería segura y eficiente para manejar contadores que solo pueden incrementarse o decrementarse.
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

/**
 * @title Custome ERC721 (NFT) Token
 * @dev Implementación de un Token No Fungible (NFT) básico.
 *
 * DIFERENCIA CON ERC-20:
 * Los tokens ERC-20 (Fungibles) son todos idénticos entre sí, como monedas de 1€.
 * Los tokens ERC-721 (No Fungibles) son únicos. Cada token tiene un identificador (ID) único,
 * como obras de arte, entradas para un concierto o parcelas del metaverso.
 */
contract erc721 is ERC721 {
    // Configuración de los contadores para los IDs de los NFTs
    // 'using A for B' asigna las funciones de la librería A al tipo de dato B.
    using Counters for Counters.Counter;

    // Variable privada para llevar la cuenta del último ID minteado (creado).
    // Inicialmente vale 0.
    Counters.Counter private _tokensIds;

    /**
     * @dev Constructor del Smart Contract.
     * Al heredar de ERC721, debemos inicializar su constructor pasándole el nombre y símbolo.
     * @param _name El nombre descriptivo de la colección de NFTs (ej: "Bored Apes").
     * @param _symbol El símbolo corto (ej: "BAYC").
     */
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    /**
     * @notice Función para crear (mintear) y enviar un nuevo NFT a una dirección.
     * @param _account La dirección de la wallet que recibirá el nuevo NFT.
     */
    function sendNFT(address _account) public {
        // 1. Incrementamos el contador. El primer NFT creado tendrá el ID 1.
        _tokensIds.increment();

        // 2. Obtenemos el valor actual del contador para usarlo como el ID del token actual.
        uint256 newItemId = _tokensIds.current();

        // 3. Minteamos el token y se lo asignamos al receptor.
        // '_safeMint' es una función de seguridad de OpenZeppelin.
        // A diferencia de un minteo normal ('_mint'), '_safeMint' verifica si la dirección
        // receptora (_account) es un Smart Contract. Si lo es, comprueba que ese contrato
        // sea capaz de recibir NFTs (implementando onERC721Received).
        // Esto evita que los NFTs se queden bloqueados para siempre en contratos incompatibles.
        _safeMint(_account, newItemId);
    }
}
